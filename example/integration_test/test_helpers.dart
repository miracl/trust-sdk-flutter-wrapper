import 'dart:convert';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:math';

Future<String> getVerificationURL(
  String projectId,
  String userId,
  String clientId,
  String clientSecret,
  String platformURL
) async {
    List<int> bytes = utf8.encode('$clientId:$clientSecret');
    String base64String = base64Encode(bytes);
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic $base64String'
    };
    
    var request = http.Request('POST', Uri.parse('$platformURL/verification'));
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

Future<bool> verifyJWT(
  String token,
  String projectId,
  String userId,
  String platformURL
) async {
  final String endpoint = "$platformURL/.well-known/jwks";
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

Future<String> startAuthenticationSession(
  String projectId, 
  String userId, 
  String platformURL
) async {
    var request = http.Request('POST', Uri.parse('$platformURL/rps/v2/session'));
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

String createRandomPin() {
  final random = Random();
  List<int> randomDigits = List.generate(4, (_) => random.nextInt(10));
  String smh = randomDigits.map((word) => word.toString()).join();
  return smh;
}

Future<String> startSigningSession(
  String projectId,
  String userId,
  String hash,
  String description,
  String platformURL
) async {
    var request = http.Request('POST', Uri.parse('$platformURL/dvs/session'));
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

Future<bool> verifySignature(
  SigningResult signingResult,
  String clientId,
  String clientSecret,
  String platformURL
) async {
    List<int> bytes = utf8.encode('$clientId:$clientSecret');
    String base64String = base64Encode(bytes);
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic $base64String'
    };

    var request = http.Request('POST', Uri.parse('$platformURL/dvs/verify'));
    final Map<String, dynamic> body = {
      'signature': {
         'u': signingResult.signature.u,
         'v': signingResult.signature.v,
         'dtas': signingResult.signature.dtas,
         'mpinId': signingResult.signature.mpinId,
         'hash': signingResult.signature.hash,
         'publicKey': signingResult.signature.publicKey
      },
      'timestamp' : signingResult.timestamp,
      'type': "verification"
    };
    final String jsonBody = jsonEncode(body);
    request.body = jsonBody;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response.statusCode == 200;
}