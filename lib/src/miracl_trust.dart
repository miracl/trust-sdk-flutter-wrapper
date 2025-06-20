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

class MIRACLTrust {
  static MIRACLTrust? _instance;

  final MiraclSdk _sdk = MiraclSdk();

  MIRACLTrust._createInstance();

  factory MIRACLTrust() {
    assert(_instance != null, "MIRACLTrust Flutter plugin is not initialized!");
    return _instance!;
  }

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
        platformUrl: configuration._platformUrl
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

  Future<List<User>> getUsers() async {
    final mUsersList = await _sdk.getUsers();
    final usersList = mUsersList.map(
      (mUser) => mUser._toUser()
    ).toList();

    return usersList;
  }

  Future<User?> getUser(String userId) async {
    final mUser = await _sdk.getUser(userId);

    if (mUser != null) {
      final user = mUser._toUser();
      return user;
    }
    return null;
  }

  Future<void> delete(User user) async {
    final mUser = user._toMUser();
    return await _sdk.delete(mUser);
  }
}
