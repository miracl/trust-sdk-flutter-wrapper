import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final platformURL = "https://api.mpin.io";
  final clientId = "";
  final clientSecret = "";
  final userId = "";
  final dvProjectId = "";
  final cuvProjectId = "";

  testWidgets('test compatiblity of the wrapper', (WidgetTester tester) async {
      final pin = createRandomPin();
      final wrongPin = createRandomPin();

      MIRACLTrust sdk = MIRACLTrust();
      
      final configuration = MConfiguration(
        projectId: dvProjectId
      );

      await sdk.initSDK(configuration);

      // Send verification email.
      await sdk.sendVerificationEmail(userId);

      await expectLater(
        sdk.sendVerificationEmail(""), 
        throwsA(
          isA<EmailVerificationException>()
            .having((e) => e.code, "Email code is different", equals(EmailVerificationExceptionCode.emptyUserId))
        )
      ); 

      // Get activation token.
      await sdk.setProjectId(cuvProjectId);
      await expectLater(
        sdk.setProjectId(""),
        throwsA(isA<ConfigurationException>().having( (e) => e.code, "", equals(ConfigurationExceptionCode.emptyProjectId)))
      );

      String verificationURL = await getVerificationURL(cuvProjectId, userId, clientId, clientSecret, platformURL);
      Uri verificationURI = Uri.parse(verificationURL);

      MActivationTokenResponse activationTokenResponse = await sdk.getActivationTokenByURI(verificationURI);
      expect(cuvProjectId, equals(activationTokenResponse.projectId));

      await expectLater(
        sdk.getActivationTokenByURI(verificationURI), 
        throwsA(isA<ActivationTokenException>().having(
          (e) => e.code ,
          "", 
          equals(ActivationTokenExceptionCode.unsuccessfulVerification))
        ) 
      );

      // Register user.
      MUser user = await sdk.register(userId, activationTokenResponse.activationToken, pin);
      expect(user.userId, equals(userId));

      await expectLater(
        sdk.register("", activationTokenResponse.activationToken, pin), 
        throwsA(
          isA<RegistrationException>().having((e) => e.code , "", equals(RegistrationExceptionCode.emptyUserId))
        )
      );

      // In-app authentication.
      final jwt = await sdk.authenticate(user, pin);
      final jwtVerificationResult = await verifyJWT(jwt, cuvProjectId, userId, platformURL);
      expect(jwtVerificationResult, equals(true));

      await expectLater(
        sdk.authenticate(user, ""),
        throwsA(
          isA<AuthenticationException>().having((e) => e.code , "", equals(AuthenticationExceptionCode.invalidPin))
        )
      );

      // QuickCode
      final quickCode = await sdk.generateQuickCode(user, pin);
      expect(quickCode.code, isNotNull);
      await expectLater(
        sdk.generateQuickCode(user, ""),
        throwsA(
          isA<QuickCodeException>().having((e) => e.code , "", equals(QuickCodeExceptionCode.invalidPin))
        )
      );

      // Get activation token by user id and code.
      activationTokenResponse = await sdk.getActivationTokenByUserIdAndCode(userId, quickCode.code);
      expect(cuvProjectId, equals(activationTokenResponse.projectId));

      await expectLater(
        sdk.getActivationTokenByUserIdAndCode(userId, quickCode.code), 
        throwsA(isA<ActivationTokenException>().having((e) => e.code  , "", equals(ActivationTokenExceptionCode.unsuccessfulVerification)) ) 
      );

      user = await sdk.register(userId, activationTokenResponse.activationToken, pin);

      // Get authentication session.
      final qrURLAsString = await startAuthenticationSession(cuvProjectId, userId, platformURL);
      final qrURL = Uri.parse(qrURLAsString);

      MAuthenticationSessionDetails authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromQRCode(qrURLAsString);
      expect(cuvProjectId, equals(authenticationSessionDetails.projectId));
      
      await expectLater(
        sdk.getAuthenticationSessionDetailsFromQRCode("https://google.com"), 
        throwsA(isA<AuthenticationSessionDetailsException>().having((e) => e.code  , "", equals(AuthenticationSessionDetailsExceptionCode.invalidQRCode))) 
      );

      authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromLink(qrURL);
      expect(cuvProjectId, equals(authenticationSessionDetails.projectId));
      
      await expectLater(
        sdk.getAuthenticationSessionDetailsFromLink(Uri.parse("https://google.com")), 
        throwsA(isA<AuthenticationSessionDetailsException>().having((e) => e.code  , "", equals(AuthenticationSessionDetailsExceptionCode.invalidLink))) 
      );

      Map<String, String> payload = {
        "userID" : userId,
        "qrURL" : qrURL.toString(),
        "projectID": cuvProjectId
      };
      authenticationSessionDetails = await sdk.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload);
      
      payload = {
        "qrURL" : "https://google.com",
        "projectID": cuvProjectId
      };
      
      await expectLater(
        sdk.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload), 
        throwsA(isA<AuthenticationSessionDetailsException>().having((e) => e.code  , "", equals(AuthenticationSessionDetailsExceptionCode.invalidNotificationPayload))) 
      );

      // Authentication with session.
      payload = {
        "userID" : userId,
        "qrURL" : qrURL.toString(),
        "projectID": cuvProjectId
      };
      await expectLater(sdk.authenticateWithQRCode(user, qrURL.toString(), pin), completion(isTrue));
      await expectLater(sdk.authenticateWithLink(user, qrURL, pin),  completion(isTrue));
      await expectLater(sdk.authenticateWithNotificationPayload(payload, pin),  completion(isTrue));

      await expectLater(
        sdk.authenticateWithQRCode(user, qrURL.toString(), wrongPin), 
        throwsA(isA<AuthenticationException>().having(
          (e) => e.code, "", equals(AuthenticationExceptionCode.unsuccessfulAuthentication)
        ))
      );
      await expectLater(
        sdk.authenticateWithLink(user, qrURL, wrongPin), 
        throwsA(isA<AuthenticationException>().having(
          (e) => e.code, "", equals(AuthenticationExceptionCode.unsuccessfulAuthentication)
        )));

      await expectLater(
        sdk.authenticateWithNotificationPayload(payload, wrongPin), 
        throwsA(isA<AuthenticationException>().having(
          (e) => e.code, "", equals(AuthenticationExceptionCode.revoked)
        ))
      );

      //Re-register revoked identity.
      verificationURL = await getVerificationURL(cuvProjectId, userId, clientId, clientSecret,platformURL);
      verificationURI = Uri.parse(verificationURL);
      activationTokenResponse = await sdk.getActivationTokenByURI(verificationURI);
      user = await sdk.register(userId, activationTokenResponse.activationToken, pin);

      // Start a signing session.
      final signingQRCode = await startSigningSession(cuvProjectId, userId, "Hello World", "Hello Desc", platformURL);

      MSigningSessionDetails signingSessionDetails = await sdk.getSigningSessionDetailsFromQRCode(signingQRCode);
      expect(signingSessionDetails.projectId, equals(cuvProjectId));

      signingSessionDetails = await sdk.getSigningSessionDetailsFromLink(Uri.parse(signingQRCode));
      expect(signingSessionDetails.projectId, equals(cuvProjectId));

      await expectLater(
        sdk.getSigningSessionDetailsFromQRCode(""),
        throwsA(isA<SigningSessionDetailsException>().having(
          (e) => e.code, "", equals(SigningSessionDetailsExceptionCode.invalidQRCode)
        ))
      );

      await expectLater(
        sdk.getSigningSessionDetailsFromLink(Uri.parse("https://google.com")),
        throwsA(isA<SigningSessionDetailsException>().having(
          (e) => e.code, "", equals(SigningSessionDetailsExceptionCode.invalidLink)
        ))
      );

      // Sign messages.
      String myString = "Hello, world! 😊";
      List<int> codeUnits = utf8.encode(myString);
      Uint8List message = Uint8List.fromList(codeUnits);
      final signingResult = await sdk.sign(user, message, pin);

      await expectLater(
        sdk.sign(user, message, wrongPin), 
        throwsA(isA<SigningException>().having(
          (e) => e.code, "", equals(SigningExceptionCode.unsuccessfulAuthentication)
        ))
      );


      // Оperations with users.
      List<MUser> users = await sdk.getUsers();
      expect(users.length, 1);

      final fetchedUser = await sdk.getUser(userId);
      expect(fetchedUser!.userId, userId);

      await sdk.delete(user);
      
      users = await sdk.getUsers();
      expect(users.length, 0);
  }); 
}