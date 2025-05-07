import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final platformURL = "https://api.mpin.io";
  final clientId = "";
  final clientSecret = "";
  final userId = "";
  final dvProjectId = "";
  final cuvProjectId = "";

  testWidgets('test compatiblity of all methods', (WidgetTester tester) async {
      MiraclSdk sdk = MiraclSdk();

      final configuration = MConfiguration(
        projectId: dvProjectId
      );

      await sdk.initSdk(configuration);
      await expectLater(sdk.setProjectId(""), throwsA(isA<PlatformException>()));
      await sdk.sendVerificationEmail(userId);
      await expectLater(sdk.sendVerificationEmail(""), throwsA(isA<PlatformException>()));

      await sdk.setProjectId(cuvProjectId);
      String verificationURL = await getVerificationURL(cuvProjectId, userId, clientId, clientSecret, platformURL);

      MActivationTokenResponse activationTokenResponse = await sdk.getActivationTokenByURI(verificationURL);
      expect(() async => await sdk.getActivationTokenByURI(verificationURL), throwsA(isA<PlatformException>()));

      final String pin = "1234";
      final String wrongPin = "2234";
      MUser user = await sdk.register(userId, activationTokenResponse.activationToken, pin, null);
      expect(() async => await sdk.register("", activationTokenResponse.activationToken, pin, null), throwsA(isA<PlatformException>()));
      final String token = await sdk.authenticate(user, pin);
      await expectLater(verifyJWT(token, cuvProjectId, user.userId, platformURL), completion(isTrue));

      await expectLater(sdk.authenticate(user, wrongPin), throwsA(isA<PlatformException>()));
      final quickCode = await sdk.generateQuickCode(user, pin);
      await expectLater(sdk.generateQuickCode(user, wrongPin), throwsA(isA<PlatformException>()));
      activationTokenResponse = await sdk.getActivationTokenByUserIdAndCode(userId, quickCode.code);
      await expectLater(sdk.getActivationTokenByUserIdAndCode(userId, quickCode.code), throwsA(isA<PlatformException>()));
      user = await sdk.register(userId, activationTokenResponse.activationToken, pin, null);

      final qrURL = await startAuthenticationSession(cuvProjectId, userId, platformURL);
      MAuthenticationSessionDetails authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromQRCode(qrURL);
      authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromLink(qrURL);
      final Map<String, String> payload = {
        "userID" : userId,
        "qrURL" : qrURL,
        "projectID": cuvProjectId
      };
      authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload);
      
      await expectLater(sdk.getAuthenticationSessionDetailsFromQRCode(""), throwsA(isA<PlatformException>()));
      await expectLater(sdk.getAuthenticationSessionDetailsFromPushNofitifactionPayload({}), throwsA(isA<PlatformException>()));

      await expectLater(sdk.authenticateWithQrCode(user, qrURL, pin), completion(isTrue));
      await expectLater(sdk.authenticateWithLink(user, qrURL, pin),  completion(isTrue));
      await expectLater(sdk.authenticateWithNotificationPayload(payload, pin),  completion(isTrue));

      await expectLater(sdk.authenticateWithQrCode(user, qrURL, wrongPin), throwsA(isA<PlatformException>()));
      await expectLater(sdk.authenticateWithLink(user, qrURL, wrongPin), throwsA(isA<PlatformException>()));
      await expectLater(sdk.authenticateWithNotificationPayload(payload, wrongPin), throwsA(isA<PlatformException>()));

      verificationURL = await getVerificationURL(cuvProjectId, userId, clientId, clientSecret, platformURL);
      activationTokenResponse = await sdk.getActivationTokenByURI(verificationURL);
      user = await sdk.register(userId, activationTokenResponse.activationToken, pin, null);

      final signingQRCode = await startSigningSession(cuvProjectId, userId, "Hello World", "Hello Desc", platformURL);
      MSigningSessionDetails signingSessionDetails = await sdk.getSigningDetailsFromQRCode(signingQRCode);
      signingSessionDetails = await sdk.getSigningSessionDetailsFromLink(signingQRCode);

      String myString = "Hello, world! 😊";
      List<int> codeUnits = utf8.encode(myString);
      Uint8List message = Uint8List.fromList(codeUnits);
      await sdk.sign(user, message, pin);
      
      List<MUser> users = await sdk.getUsers();
      expect(users.length, 1);

      final fetchedUser = await sdk.getUser(userId);
      expect(fetchedUser!.userId, userId);

      await sdk.delete(user);
      
      users = await sdk.getUsers();
      expect(users.length, 0);
  });
}