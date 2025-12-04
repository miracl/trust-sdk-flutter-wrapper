import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk.dart';
import 'package:flutter_miracl_sdk/src/constants.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'test_helpers.dart';
import 'extenstions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const serviceAccountToken = String.fromEnvironment("TEST_CUV_SERVICE_ACCOUNT_TOKEN");
  const userId = String.fromEnvironment("TEST_USER_ID");
  const dvProjectId = String.fromEnvironment("TEST_DV_PROJECT_ID");
  const cuvProjectId = String.fromEnvironment("TEST_CUV_PROJECT_ID");
  const cuvProjectUrl = String.fromEnvironment("TEST_CUV_PROJECT_URL");
  const dvProjectUrl = String.fromEnvironment("TEST_DV_PROJECT_URL");

  testWidgets('test compatiblity', (WidgetTester tester) async {
      final pin = createRandomPin();
      final wrongPin = createRandomPin();

      // Test getting instace before initialization.
      expect(
        () => MIRACLTrust(),
        throwsA(isA<AssertionError>().having((e) => e.message, "", equals(pluginNotInitializedErrorMessage)))
      );
      
      // Initialize the plugin.
      final configuration = Configuration(
        projectId: dvProjectId,
        projectUrl: dvProjectUrl
      );

      await MIRACLTrust.initialize(configuration);
      await expectLater(
        MIRACLTrust.initialize(Configuration(projectId: "", projectUrl: cuvProjectUrl)),
        throwsA(isA<ConfigurationException>().having( (e) => e.code, "", equals(ConfigurationExceptionCode.emptyProjectId)))
      );

      await expectLater(
        MIRACLTrust.initialize(Configuration(projectId: cuvProjectId, projectUrl: "")),
        throwsA(isA<ConfigurationException>().having( (e) => e.code, "", equals(ConfigurationExceptionCode.invalidProjectUrl)))
      );

      final miraclTrust = MIRACLTrust();

      // Test calling the constructor second time returns the same instance.
      expect(MIRACLTrust(), equals(miraclTrust));

      // Send verification email.
      await miraclTrust.sendVerificationEmail(userId);

      await expectLater(
        miraclTrust.sendVerificationEmail(""), 
        throwsA(
          isA<EmailVerificationException>()
            .having((e) => e.code, "Email code is different", equals(EmailVerificationExceptionCode.emptyUserId))
        )
      ); 

      await miraclTrust.updateProjectSettings(cuvProjectId, cuvProjectUrl);
      await expectLater(
        miraclTrust.updateProjectSettings("", cuvProjectUrl),
        throwsA(isA<ConfigurationException>().having( (e) => e.code, "", equals(ConfigurationExceptionCode.emptyProjectId)))
      );

      await expectLater(
        miraclTrust.updateProjectSettings(cuvProjectId, ""),
        throwsA(isA<ConfigurationException>().having( (e) => e.code, "", equals(ConfigurationExceptionCode.invalidProjectUrl)))
      );

      await miraclTrust.setProjectId(dvProjectId);

      await expectLater(
        miraclTrust.setProjectId(""),
        throwsA(isA<ConfigurationException>().having( (e) => e.code, "", equals(ConfigurationExceptionCode.emptyProjectId)))
      );

      await miraclTrust.setProjectId(cuvProjectId);

      // Get activation token.
      String verificationURL = await getVerificationURL(cuvProjectId, userId, serviceAccountToken, cuvProjectUrl);
      Uri verificationURI = Uri.parse(verificationURL);

      ActivationTokenResponse activationTokenResponse = await miraclTrust.getActivationTokenByURI(verificationURI);
      expect(cuvProjectId, equals(activationTokenResponse.projectId));

      int expirationDuration = 5;
      final expiration = DateTime.now().add(Duration(seconds: expirationDuration)).unixtime;
      verificationURL = await getVerificationURL(cuvProjectId, userId, serviceAccountToken, cuvProjectUrl, expiration);
      verificationURI = Uri.parse(verificationURL);
      sleep(Duration(seconds: expirationDuration + 1));

      await expectLater(
        miraclTrust.getActivationTokenByURI(verificationURI), 
        throwsA(isA<ActivationTokenException>().having(
            (e) => e.code ,
            "", 
            equals(ActivationTokenExceptionCode.unsuccessfulVerification)
          ).having(
            (e) => e.activationTokenErrorResponse,
            "", 
            isNotNull
          ).having(
            (e) => e.activationTokenErrorResponse!.projectId,
            "", 
            equals(cuvProjectId)
          )
        )
      );

      // Register user.
      User user = await miraclTrust.register(userId, activationTokenResponse.activationToken, pin);
      expect(user.userId, equals(userId));

      await expectLater(
        miraclTrust.register("", activationTokenResponse.activationToken, pin), 
        throwsA(
          isA<RegistrationException>().having((e) => e.code , "", equals(RegistrationExceptionCode.emptyUserId))
        )
      );

      // In-app authentication.
      final jwt = await miraclTrust.authenticate(user, pin);
      final jwtVerificationResult = await verifyJWT(jwt, cuvProjectId, userId, cuvProjectUrl);
      expect(jwtVerificationResult, equals(true));

      await expectLater(
        miraclTrust.authenticate(user, ""),
        throwsA(
          isA<AuthenticationException>().having((e) => e.code , "", equals(AuthenticationExceptionCode.invalidPin))
        )
      );

      // QuickCode
      final quickCode = await miraclTrust.generateQuickCode(user, pin);
      expect(quickCode.code, isNotNull);
      await expectLater(
        miraclTrust.generateQuickCode(user, ""),
        throwsA(
          isA<QuickCodeException>().having((e) => e.code , "", equals(QuickCodeExceptionCode.invalidPin))
        )
      );

      // Get activation token by user id and code.
      activationTokenResponse = await miraclTrust.getActivationTokenByUserIdAndCode(userId, quickCode.code);
      expect(cuvProjectId, equals(activationTokenResponse.projectId));

      await expectLater(
        miraclTrust.getActivationTokenByUserIdAndCode(userId, quickCode.code), 
        throwsA(isA<ActivationTokenException>()
          .having((e) => e.code  , "", equals(ActivationTokenExceptionCode.unsuccessfulVerification))
        ) 
      );

      user = await miraclTrust.register(userId, activationTokenResponse.activationToken, pin);

      // Get authentication session.
      final qrURLAsString = await startAuthenticationSession(cuvProjectId, userId, cuvProjectUrl);
      final qrURL = Uri.parse(qrURLAsString);

      AuthenticationSessionDetails authenticationSessionDetails = await miraclTrust.getAuthenticationSessionDetailsFromQRCode(qrURLAsString);
      expect(cuvProjectId, equals(authenticationSessionDetails.projectId));
      
      await expectLater(
        miraclTrust.getAuthenticationSessionDetailsFromQRCode("https://google.com"), 
        throwsA(isA<AuthenticationSessionDetailsException>().having((e) => e.code  , "", equals(AuthenticationSessionDetailsExceptionCode.invalidQRCode))) 
      );

      authenticationSessionDetails = await miraclTrust.getAuthenticationSessionDetailsFromLink(qrURL);
      expect(cuvProjectId, equals(authenticationSessionDetails.projectId));
      
      await expectLater(
        miraclTrust.getAuthenticationSessionDetailsFromLink(Uri.parse("https://google.com")), 
        throwsA(isA<AuthenticationSessionDetailsException>().having((e) => e.code  , "", equals(AuthenticationSessionDetailsExceptionCode.invalidLink))) 
      );

      Map<String, String> payload = {
        "userID" : userId,
        "qrURL" : qrURL.toString(),
        "projectID": cuvProjectId
      };
      authenticationSessionDetails = await miraclTrust.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload);
      
      payload = {
        "qrURL" : "https://google.com",
        "projectID": cuvProjectId
      };
      
      await expectLater(
        miraclTrust.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload), 
        throwsA(isA<AuthenticationSessionDetailsException>().having((e) => e.code  , "", equals(AuthenticationSessionDetailsExceptionCode.invalidNotificationPayload))) 
      );

      // Authentication with session.
      payload = {
        "userID" : userId,
        "qrURL" : qrURL.toString(),
        "projectID": cuvProjectId
      };
      await expectLater(miraclTrust.authenticateWithQRCode(user, qrURL.toString(), pin), completes);
      await expectLater(miraclTrust.authenticateWithLink(user, qrURL, pin), completes);
      await expectLater(miraclTrust.authenticateWithNotificationPayload(payload, pin), completes);

      await expectLater(
        miraclTrust.authenticateWithQRCode(user, qrURL.toString(), wrongPin), 
        throwsA(isA<AuthenticationException>().having(
          (e) => e.code, "", equals(AuthenticationExceptionCode.unsuccessfulAuthentication)
        ))
      );
      await expectLater(
        miraclTrust.authenticateWithLink(user, qrURL, wrongPin), 
        throwsA(isA<AuthenticationException>().having(
          (e) => e.code, "", equals(AuthenticationExceptionCode.unsuccessfulAuthentication)
        )));

      await expectLater(
        miraclTrust.authenticateWithNotificationPayload(payload, wrongPin), 
        throwsA(isA<AuthenticationException>().having(
          (e) => e.code, "", equals(AuthenticationExceptionCode.revoked)
        ))
      );

      //Re-register revoked identity.
      verificationURL = await getVerificationURL(cuvProjectId, userId, serviceAccountToken, cuvProjectUrl);
      verificationURI = Uri.parse(verificationURL);
      activationTokenResponse = await miraclTrust.getActivationTokenByURI(verificationURI);
      user = await miraclTrust.register(userId, activationTokenResponse.activationToken, pin);

      // Start a signing session.
      final signingQRCode = await startSigningSession(cuvProjectId, userId, "Hello World", "Hello Desc", cuvProjectUrl);

      SigningSessionDetails signingSessionDetails = await miraclTrust.getSigningSessionDetailsFromQRCode(signingQRCode);
      expect(signingSessionDetails.projectId, equals(cuvProjectId));

      signingSessionDetails = await miraclTrust.getSigningSessionDetailsFromLink(Uri.parse(signingQRCode));
      expect(signingSessionDetails.projectId, equals(cuvProjectId));

      await expectLater(
        miraclTrust.getSigningSessionDetailsFromQRCode(""),
        throwsA(isA<SigningSessionDetailsException>().having(
          (e) => e.code, "", equals(SigningSessionDetailsExceptionCode.invalidQRCode)
        ))
      );

      await expectLater(
        miraclTrust.getSigningSessionDetailsFromLink(Uri.parse("https://google.com")),
        throwsA(isA<SigningSessionDetailsException>().having(
          (e) => e.code, "", equals(SigningSessionDetailsExceptionCode.invalidLink)
        ))
      );

      // Sign messages.
      String myString = "Hello, world! 😊";
      List<int> codeUnits = utf8.encode(myString);
      Uint8List message = Uint8List.fromList(codeUnits);
      final signingResult = await miraclTrust.sign(user, message, pin);
      final signatureVerificationResult = await verifySignature(signingResult, serviceAccountToken, cuvProjectUrl);
      expect(signatureVerificationResult, equals(true));

      await expectLater(
        miraclTrust.sign(user, message, wrongPin), 
        throwsA(isA<SigningException>().having(
          (e) => e.code, "", equals(SigningExceptionCode.unsuccessfulAuthentication)
        ))
      );


      // Оperations with users.
      List<User> users = await miraclTrust.getUsers();
      expect(users.length, 1);

      final fetchedUser = await miraclTrust.getUser(userId);
      expect(fetchedUser!.userId, userId);

      await miraclTrust.delete(user);
      
      users = await miraclTrust.getUsers();
      expect(users.length, 0);
  }); 
}