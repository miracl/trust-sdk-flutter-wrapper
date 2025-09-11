import 'package:flutter/services.dart';
import 'package:flutter_miracl_sdk/src/constants.dart';
import 'package:flutter_miracl_sdk/src/pigeon.dart';
import 'package:flutter_miracl_sdk/src/logging.dart';

export 'package:flutter_miracl_sdk/src/logging.dart'
    show 
        Logger, 
        LoggingLevel;

part 'models.dart';
part 'exceptions.dart';
part 'extensions.dart';

/// The entry point of the MIRACL Trust Flutter Plugin.
class MIRACLTrust {
  static MIRACLTrust? _instance;

  final MiraclSdk _sdk = MiraclSdk();

  MIRACLTrust._createInstance();

  /// Provides access to the singleton instance of the MIRACL Trust Flutter Plugin.
  ///
  /// This factory constructor is the primary way to access the functionalities
  /// of the MIRACL Trust Flutter Plugin. It follows the singleton pattern,
  /// ensuring that only one instance of the plugin exists throughout the
  /// application's lifecycle.
  ///
  /// **Important:** The MIRACL Trust Flutter Plugin must be initialized before
  /// this factory is used. The initialization should be performed once, for
  /// example, in your app's `main` function.
  ///
  /// ## Example
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   // Initialize the plugin
  ///   final configuration = Configuration(
  ///     projectId: "YOUR_PROJECT_ID"
  ///   );
  ///   await MIRACLTrust.initialize();
  ///
  ///   // Now it's safe to access the singleton instance
  ///   final miraclTrust = MIRACLTrust();
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  ///
  /// Throws an [AssertionError] if the plugin is not initialized before this
  /// constructor is called. This helps in catching configuration issues early
  /// in the development process.
  factory MIRACLTrust() {
    assert(_instance != null, pluginNotInitializedErrorMessage);
    return _instance!;
  }

  /// Configures the MIRACL Trust Flutter Plugin via the [configuration] object.
  /// 
  /// **IMPORTANT: This method must only be called once.**
  /// Subsequent calls may lead to unpredictable behavior or errors.
  /// 
  /// Throws a [ConfigurationException] if the configuration is invalid.
  static Future<void> initialize(Configuration configuration) async {
    try {
      Logger logger;

      if (configuration._logger != null) {
        logger = configuration._logger!;
      } else {
        logger = DefaultLogger(configuration._loggingLevel);
      }

      final mConfiguration = MConfiguration(
        projectId: configuration._projectId, 
        applicationInfo: sdkApplicationInfo,
        projectUrl: configuration._projectUrl
      );

      final miraclTrust = MIRACLTrust._createInstance();
      await miraclTrust._sdk.initSdk(mConfiguration);
      MLogger.setUp(logger);
      _instance = miraclTrust;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if(exceptionCode is MConfigurationExceptionCode) {
        throw ConfigurationException._create(exceptionCode.toConfigurationExceptionCode());
      } else {
        rethrow;
      }
    }
  }

  /// Reconfigures the MIRACL Trust Flutter Plugin with a new project ID.
  ///
  /// Call this when you need the SDK to interact with a different project than the one it's currently using.
  /// 
  /// - [projectId]: `Project ID` setting for the MIRACL Trust Platform that needs to be updated.
  /// 
  /// Throws a [ConfigurationException] if the project ID is empty.
  Future<void> setProjectId(String projectId) async {
    try {
      return await _sdk.setProjectId(projectId);
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if(exceptionCode is MConfigurationExceptionCode) {
        throw ConfigurationException._create(exceptionCode.toConfigurationExceptionCode());
      } else {
        rethrow;
      }
    }
  }

  /// Configures new project settings when the MIRACL Trust Flutter Plugin have to work with a different project.
  ///
  /// - [projectId]: The unique identifier for your MIRACL Trust project.
  /// - [projectUrl]: MIRACL Trust Project URL that is used for communication with the MIRACL Trust API.
  /// 
  /// Throws a [ConfigurationException] if the project ID is empty or the project URL is invalid
  Future<void> updateProjectSettings(String projectId, String projectUrl) async {
    try {
      return await _sdk.updateProjectSettings(projectId, projectUrl);
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if(exceptionCode is MConfigurationExceptionCode) {
        throw ConfigurationException._create(exceptionCode.toConfigurationExceptionCode());
      } else {
        rethrow;
      }
    } 
  }

  /// Sends an email for User ID verification.
  ///
  /// [userId] should be a valid email address, as it's used for identity verification.
  /// 
  /// Throws [EmailVerificationException] if the email sending fails or
  /// if another issue occurs during the email verification process.
  Future<EmailVerificationResponse> sendVerificationEmail(String userId) async {
    try {
      final response = await _sdk.sendVerificationEmail(userId);
      final emailVerificationResponse = response._toEmailVerificationResponse();
      return emailVerificationResponse;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if(exceptionCode is MEmailVerificationExceptionCode) {
        throw EmailVerificationException._create(
          exceptionCode.toEmailVerificationExceptionCode(),
          e.details["backoff"],
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Confirms user verification and as a result, an activation token is obtained.
  ///
  /// This activation token must be used in the subsequent registration process.
  ///
  /// - [uri]: A verification URI that was received as part of the verification process.
  ///
  /// Throws [ActivationTokenException] if the [uri] is invalid or expired.
  Future<ActivationTokenResponse> getActivationTokenByURI(Uri uri) async {
    try {
      final result = await _sdk.getActivationTokenByURI(uri.toString());
      final activationTokenResponse = result._toActivationTokenResponse();
      return activationTokenResponse;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MActivationTokenExceptionCode) {
        final mActivationTokenErrorResponse = e.details["activationTokenErrorResponse"];

        ActivationTokenErrorResponse? errorResponse;
        if (mActivationTokenErrorResponse != null && mActivationTokenErrorResponse is MActivationTokenErrorResponse) {
          errorResponse = mActivationTokenErrorResponse._toActivationTokeErrorResponse();
        }

        throw ActivationTokenException._create(
          exceptionCode.toActivationTokenExceptionCode(),
          errorResponse,
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Confirms user verification and as a result, an activation token is obtained.
  ///
  /// This activation token must be used in the subsequent registration process.
  ///
  /// - [userId]: Identifier of the user.
  /// - [code]: The verification code sent to the user's email.
  ///
  /// Throws [ActivationTokenException] if the verification confirmation fails.
  Future<ActivationTokenResponse> getActivationTokenByUserIdAndCode(String userId, String code) async {
    try {
      final result = await _sdk.getActivationTokenByUserIdAndCode(userId, code);
      final activationTokenResponse = result._toActivationTokenResponse();

      return activationTokenResponse;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MActivationTokenExceptionCode) {
        final mActivationTokenErrorResponse = e.details["activationTokenErrorResponse"];

        ActivationTokenErrorResponse? errorResponse;
        if (mActivationTokenErrorResponse != null && mActivationTokenErrorResponse is MActivationTokenErrorResponse) {
          errorResponse = mActivationTokenErrorResponse._toActivationTokeErrorResponse();
        }

        throw ActivationTokenException._create(
          exceptionCode.toActivationTokenExceptionCode(),
          errorResponse,
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Provides end-user registration.
  ///
  /// Registers an end-user for a given MIRACL Trust Project on the MIRACL Trust platform.
  ///
  /// Parameters:
  /// - [userId]: The unique user identifier (e.g., email address).
  /// - [activationToken]: The token received after a successful verification process.
  /// - [pin]: The user's desired PIN.
  /// - [pushToken]: An optional push notification token for this device.
  ///   This should be provided if your project is configured to use push
  ///   notifications.
  ///
  /// Throws [RegistrationException] if any part of the registration process fails.
  Future<User> register(String userId, String activationToken, String pin, [ String? pushToken ]) async {
    try {
      final mUser = await _sdk.register(userId, activationToken, pin, pushToken);
      final user = mUser._toUser();

      return user;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MRegistrationExceptionCode) {
        throw RegistrationException._create(
          exceptionCode.toRegistrationExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Authenticates a [user] to the MIRACL Trust platform by generating a
  /// [JWT](https://datatracker.ietf.org/doc/html/rfc7519) authentication token.
  ///
  /// Use this method to authenticate a user within your application.
  ///
  /// **Important Server-Side Verification:**
  /// After the JWT authentication token is generated by this method, it must be
  /// sent to your application server for verification. The application server
  /// should verify the token's signature using the MIRACL Trust
  /// [JWKS](https://api.mpin.io/.well-known/jwks) endpoint and also validate
  /// the `audience` claim, which should match your application's project ID.
  ///
  /// Parameters:
  /// - [user]: The [User] to authenticate.
  /// - [pin]: The user's PIN.
  ///
  /// Throws [AuthenticationException] if the authentication process fails for
  /// any reason (e.g., incorrect PIN, revoked user).
  Future<String> authenticate(User user, String pin) async {
    try {
      final mUser = user._toMUser();

      return await _sdk.authenticate(mUser, pin);
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MAuthenticationExceptionCode) {
        throw AuthenticationException._create(
          exceptionCode.toAuthenticationExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Gets [AuthenticationSessionDetails] from the MIRACL Trust platform using a push notification.
  ///
  /// Use this method to get session details for an application that is authenticating
  /// against the MIRACL Trust Platform via a push notification.
  ///
  /// Parameters:
  /// - [payload]: Key-value data provided by the notification.
  ///
  /// Throws [AuthenticationSessionDetailsException] if fetching the session details
  /// fails (e.g., due to an invalid notification payload).
  Future<AuthenticationSessionDetails> getAuthenticationSessionDetailsFromPushNofitifactionPayload(
    Map<String, String> payload
  ) async {
    try {
      final mAuthenticationSessionDetails = await _sdk.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload);
      final authenticationSessionDetails = mAuthenticationSessionDetails._toAuthenticationSessionDetails();

      return authenticationSessionDetails;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MAuthenticationSessionDetailsExceptionCode) {
        throw AuthenticationSessionDetailsException._create(
          exceptionCode.toAuthenticationSessionDetailsExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    } 
  }

  /// Authenticates a user in the MIRACL Trust platform via a link.
  ///
  /// Use this method to authenticate another application using a link
  /// URI provided by the MIRACL Trust platform (e.g., received via a deep link).
  ///
  /// Parameters:
  /// - [user]: The [User] to authenticate.
  /// - [link]: A URI received via a deep link.
  /// - [pin]: The user's PIN.
  ///
  /// Throws [AuthenticationException] if the authentication process fails for
  /// any reason (e.g., incorrect PIN, invalid link, expired session).
  Future<void> authenticateWithLink(User user, Uri link, String pin) async {
    try {
      final mUser = user._toMUser();

      await _sdk.authenticateWithLink(mUser, link.toString(), pin);
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MAuthenticationExceptionCode) {
        throw AuthenticationException._create(
          exceptionCode.toAuthenticationExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Authenticates a user in the MIRACL Trust platform via QR code.
  ///
  /// Use this method to authenticate another application using a QR code
  /// presented on the MIRACL Trust login page.
  ///
  /// Parameters:
  /// - [user]: The [User] to authenticate.
  /// - [qrCode]: A string read from the QR code.
  /// - [pin]: The user's PIN.
  ///
  /// Throws [AuthenticationException] if the authentication process fails for
  /// any reason (e.g., incorrect PIN, invalid QR code, expired session).
  Future<void> authenticateWithQRCode(User user, String qrCode, String pin) async {
    try {
      final mUser = user._toMUser();
      
      await _sdk.authenticateWithQrCode(mUser, qrCode, pin);
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MAuthenticationExceptionCode) {
        throw AuthenticationException._create(
          exceptionCode.toAuthenticationExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Authenticates a user in the MIRACL Trust platform via push notification.
  ///
  /// Use this method to authenticate another application using a push
  /// notification sent by the MIRACL Trust platform.
  ///
  /// Parameters:
  /// - [payload]: key-value data provided by the notification.
  /// - [pin]: The user's PIN.
  ///
  /// Throws [AuthenticationException] if the authentication process fails for
  /// any reason (e.g., incorrect PIN, invalid push notification payload,
  /// expired session).
  Future<void> authenticateWithNotificationPayload(Map<String, String> payload, String pin) async {
    try {
      await _sdk.authenticateWithNotificationPayload(payload, pin);
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MAuthenticationExceptionCode) {
        throw AuthenticationException._create(
          exceptionCode.toAuthenticationExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Generates a [QuickCode](https://miracl.com/resources/docs/guides/built-in-user-verification/quickcode/)
  /// for a registered user.
  ///
  /// Parameters:
  /// - [user]: The registered [User] to generate the [QuickCode] for.
  /// - [pin]: The user's PIN.
  ///
  /// Throws [QuickCodeException] if the `QuickCode` generation fails for
  /// any reason (e.g., incorrect PIN, user not found).
  Future<QuickCode> generateQuickCode(User user, String pin) async {
    try {
      final mUser = user._toMUser();
      final mQuickCode = await _sdk.generateQuickCode(mUser, pin);
      final quickCode = mQuickCode._toQuickCode();

      return quickCode;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MQuickCodeExceptionCode) {
        throw QuickCodeException._create(
          exceptionCode.toQuickCodeExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Gets [AuthenticationSessionDetails] from the MIRACL Trust platform using a QR code.
  ///
  /// Use this method to get session details for an application that is authenticating
  /// against the MIRACL Trust Platform via a QR code.
  ///
  /// Parameters:
  /// - [qrCode]: The raw string content read from the QR code.
  ///
  /// Throws [AuthenticationSessionDetailsException] if fetching the session details
  /// fails (e.g., due to an invalid or expired QR code).
  Future<AuthenticationSessionDetails> getAuthenticationSessionDetailsFromQRCode(String qrCode) async {
    try {
      final mAuthenticationSessionDetails = await _sdk.getAuthenticationSessionDetailsFromQRCode(qrCode);
      final authenticationSessionDetails = mAuthenticationSessionDetails._toAuthenticationSessionDetails();
      return authenticationSessionDetails;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MAuthenticationSessionDetailsExceptionCode) {
        throw AuthenticationSessionDetailsException._create(
          exceptionCode.toAuthenticationSessionDetailsExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Gets [AuthenticationSessionDetails] from the MIRACL Trust platform using a deep link.
  ///
  /// Use this method to get session details for an application that is authenticating
  /// against the MIRACL Trust Platform via a deep link.
  ///
  /// Parameters:
  /// - [link]: A URI received via a deep link.
  ///
  /// Throws [AuthenticationSessionDetailsException] if fetching the session details
  /// fails (e.g., due to an invalid or expired deep link).
  Future<AuthenticationSessionDetails> getAuthenticationSessionDetailsFromLink(Uri link) async {
    try {
      final mAuthenticationSessionDetails = await _sdk.getAuthenticationSessionDetailsFromLink(link.toString());
      final authenticationSessionDetails = mAuthenticationSessionDetails._toAuthenticationSessionDetails();
      return authenticationSessionDetails;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MAuthenticationSessionDetailsExceptionCode) {
        throw AuthenticationSessionDetailsException._create(
          exceptionCode.toAuthenticationSessionDetailsExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Gets [SigningSessionDetails] from the MIRACL Trust platform using a QR code.
  ///
  /// Use this method to get session details for an application that is signing
  /// against the MIRACL Trust Platform via a QR code.
  ///
  /// Parameters:
  /// - [qrCode]: The raw string content read from the QR code.
  ///
  /// Throws [SigningSessionDetailsException] if fetching the session details
  /// fails (e.g., due to an invalid or expired QR code).
  Future<SigningSessionDetails> getSigningSessionDetailsFromQRCode(String qrCode) async {
    try {
      final mSigningSessionDetails = await _sdk.getSigningDetailsFromQRCode(qrCode);
      final signingSessionDetails = mSigningSessionDetails._toSigningSessionDetails();

      return signingSessionDetails;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MSigningSessionDetailsExceptionCode) {
        throw SigningSessionDetailsException._create(
          exceptionCode.toSigningSessionDetailsExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Gets [SigningSessionDetails] from the MIRACL Trust platform using a deep link.
  ///
  /// Use this method to get session details for an application that is signing
  /// against the MIRACL Trust Platform via a deep link.
  ///
  /// Parameters:
  /// - [link]: A URI received via a deep link.
  ///
  /// Throws [SigningSessionDetailsException] if fetching the session details
  /// fails (e.g., due to an invalid or expired deep link).
  Future<SigningSessionDetails> getSigningSessionDetailsFromLink(Uri link) async {
    try {
      final mSigningSessionDetails = await _sdk.getSigningSessionDetailsFromLink(link.toString());
      final signingSessionDetails = mSigningSessionDetails._toSigningSessionDetails();

      return signingSessionDetails;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MSigningSessionDetailsExceptionCode) {
        throw SigningSessionDetailsException._create(
          exceptionCode.toSigningSessionDetailsExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Creates a cryptographic signature for a given document hash.
  ///
  /// This method requires the user's PIN for authorization and, upon success,
  /// returns a [SigningResult] object containing the signature and timestamp.
  ///
  /// Parameters:
  /// - [message]: The hash of the document to be signed.
  /// - [user]: The registered [User] performing the signature.
  /// - [pin]: The user's PIN.
  ///
  /// Throws [SigningException] if the signing process fails for any reason
  /// (e.g., incorrect PIN, revoked user).
  Future<SigningResult> sign(User user, Uint8List message, String pin) async {
    try {
      final mUser = user._toMUser();

      final mSigningResult = await _sdk.sign(mUser, message, pin);
      final signingResult = mSigningResult._toSigningResult();
      return signingResult;
    } on PlatformException catch(e) {
      final exceptionCode = e._getExceptionCode();
      if (exceptionCode is MSigningExceptionCode) {
        throw SigningException._create(
          exceptionCode.toSigningExceptionCode(),
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  /// Retrieves the registered users, returning a list of [User] objects.
  Future<List<User>> getUsers() async {
    final mUsersList = await _sdk.getUsers();
    final usersList = mUsersList.map(
      (mUser) => mUser._toUser()
    ).toList();

    return usersList;
  }

  /// Finds a registered user by their [userId].
  ///
  /// Returns the [User] object if found, otherwise returns `null`.
  Future<User?> getUser(String userId) async {
    final mUser = await _sdk.getUser(userId);

    if (mUser != null) {
      final user = mUser._toUser();
      return user;
    }
    return null;
  }

  /// Deletes a registered user from the device.
  Future<void> delete(User user) async {
    final mUser = user._toMUser();
    return await _sdk.delete(mUser);
  }
}
