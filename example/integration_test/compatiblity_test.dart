import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_miracl_sdk/pigeon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:typed_data';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<String> getVerificationURL(String projectId, String userId) async {
      String clientId = "";
      String clientSecret = "";
      List<int> bytes = utf8.encode('$clientId:$clientSecret');
      String base64String = base64Encode(bytes);
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic $base64String'
      };
      
      var request = http.Request('POST', Uri.parse('https://api.mpin.io/verification'));
      final Map<String, dynamic> body = {
        'projectId': projectId,
        'userId': userId,
        'delivery': 'no',
      };
      final String jsonBody = jsonEncode(body);
      request.body = jsonBody;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseString = jsonDecode(await response.stream.bytesToString());
      
      final String verificationURI = responseString['verificationURL'];
      return verificationURI;
  }

  Future<bool> verifyJWT(String token, String projectId, String userId) async {
    final String endpoint = "https://api.mpin.io/.well-known/jwks";
    var request = http.Request('GET', Uri.parse(endpoint));
    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> jwksResponse = jsonDecode(await response.stream.bytesToString());
    final respKey = jwksResponse['keys'][0];
    final key = JWTKey.fromJWK(respKey);

    final jwt = JWT.verify(token, key);
    final jwtAudience = jwt.audience?.first;
    if (jwtAudience != null) {
      if (jwtAudience != projectId) {
        return false;
      }
    } else {
      return false;
    }

    if (jwt.subject != userId) {
      return false;
    }

    return true;
  }

  Future<String> startAuthenticationSession(String projectId, String userId) async {
      var request = http.Request('POST', Uri.parse('https://api.mpin.io/rps/v2/session'));
      final Map<String, dynamic> body = {
        'projectId': projectId,
        'userId': userId,
      };
      final String jsonBody = jsonEncode(body);
      request.body = jsonBody;

      http.StreamedResponse response = await request.send();
      final responseString = jsonDecode(await response.stream.bytesToString());

      return responseString["qrURL"];
  }

    Future<String> startSigningSession(String projectId, String userId, String hash, String description) async {
      var request = http.Request('POST', Uri.parse('https://api.mpin.io/dvs/session'));
      final Map<String, dynamic> body = {
        'projectId': projectId,
        'userId': userId,
        'hash' : hash,
        'description': description
      };
      final String jsonBody = jsonEncode(body);
      request.body = jsonBody;

      http.StreamedResponse response = await request.send();
      final responseString = jsonDecode(await response.stream.bytesToString());

      return responseString["qrURL"];
  }

  testWidgets('test compatiblity of all methods', (WidgetTester tester) async {
      MiraclSdk sdk = MiraclSdk();

      final configuration = MConfiguration(
        projectId: ""
      );

      final String userId = "";
      await sdk.initSdk(configuration);
      await sdk.setProjectId("");
      await sdk.sendVerificationEmail(userId, null);

      String projectId = "";
      await sdk.setProjectId(projectId);
      final verificationURL = await getVerificationURL(projectId, userId);

      MActivationTokenResponse activationTokenResponse = await sdk.getActivationTokenByURI(verificationURL);
      final String pin = "";
      MUser user = await sdk.register(userId, activationTokenResponse.activationToken, pin, null);
      final String token = await sdk.authenticate(user, pin);
      expect(await verifyJWT(token, projectId, user.userId), true);

      final quickCode = await sdk.generateQuickCode(userId, pin);
      activationTokenResponse = await sdk.getActivationTokenByUserIdAndCode(userId, quickCode.code);
      user = await sdk.register(userId, activationTokenResponse.activationToken, pin, null);

      final qrURL = await startAuthenticationSession(projectId, userId);
      MAuthenticationSessionDetails authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromQRCode(qrURL);
      authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromLink(qrURL);
      final Map<String, String> payload = {
        "userID" : userId,
        "qrURL" : qrURL,
        "projectID": projectId
      };
      authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload);

      expect(await sdk.authenticateWithQrCode(userId, pin, qrURL), true);
      expect(await sdk.authenticateWithLink(userId, pin, qrURL), true);
      expect(await sdk.authenticateWithNotificationPayload(payload, pin), true);

      final signingQRCode = await startSigningSession(projectId, userId, "Hello World", "Hello Desc");
      MSigningSessionDetails signingSessionDetails = await sdk.getSigningDetailsFromQRCode(signingQRCode);
      signingSessionDetails = await sdk.getSigningSessionDetailsFromLink(signingQRCode);

      String myString = "Hello, world! 😊";
      List<int> codeUnits = utf8.encode(myString);
      Uint8List message = Uint8List.fromList(codeUnits);
      await sdk.sign(userId, pin, message);
      
      List<MUser> users = await sdk.getUsers();
      expect(users.length, 1);

      final fetchedUser = await sdk.getUser(userId);
      expect(fetchedUser!.userId, userId);

      await sdk.delete(userId);
      
      users = await sdk.getUsers();
      expect(users.length, 0);
  });
}