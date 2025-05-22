import 'package:flutter/services.dart';
import 'package:flutter_miracl_sdk/src/pigeon.dart';
import 'package:flutter_miracl_sdk/src/constants.dart';

part 'models.dart';
part 'exceptions.dart';
part 'extensions.dart';

class MIRACLTrust {
  final MiraclSdk _sdk = MiraclSdk();

  Future<void> initSDK(Configuration configuration) async {
    try {
      final mConfiguration = MConfiguration(
        projectId: configuration.projectId, 
        applicationInfo: sdkApplicationInfo
      );
      return await _sdk.initSdk(mConfiguration);
    } on PlatformException catch(e) {
      final configurationExceptionCode = ConfigurationExceptionCode.codeFromString(e.code);
      if (configurationExceptionCode != null) {
        throw ConfigurationException._create(
          configurationExceptionCode, 
          e.message
        );
      } else {
        rethrow;
      }
    }
  }

  Future<void> setProjectId(String projectId) async {
    try {
      return await _sdk.setProjectId(projectId);
    } on PlatformException catch(e) {
      final configurationExceptionCode = ConfigurationExceptionCode.codeFromString(e.code);
      if (configurationExceptionCode != null) {
        throw ConfigurationException._create(
          configurationExceptionCode, 
          e.message
        );
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
      final emailVerificationExceptionCode = EmailVerificationExceptionCode.codeFromString(e.code);
      if (emailVerificationExceptionCode != null) {
        throw EmailVerificationException._create(
          emailVerificationExceptionCode, 
          e.message, 
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
      final activationTokenExceptionCode = ActivationTokenExceptionCode.codeFromString(e.code);
      if (activationTokenExceptionCode != null) {
        final mActivationTokenErrorResponse = e.details["activationTokenErrorResponse"];

        ActivationTokenErrorResponse? errorResponse;
        if (mActivationTokenErrorResponse != null && mActivationTokenErrorResponse is MActivationTokenErrorResponse) {
          errorResponse = mActivationTokenErrorResponse._toActivationTokeErrorResponse();
        }

        throw ActivationTokenException._create(
          activationTokenExceptionCode, 
          e.message,
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
      final activationTokenExceptionCode = ActivationTokenExceptionCode.codeFromString(e.code);
      if (activationTokenExceptionCode != null) {
        final mActivationTokenErrorResponse = e.details["activationTokenErrorResponse"];

        ActivationTokenErrorResponse? errorResponse;
        if (mActivationTokenErrorResponse != null && mActivationTokenErrorResponse is MActivationTokenErrorResponse) {
          errorResponse = mActivationTokenErrorResponse._toActivationTokeErrorResponse();
        }

        throw ActivationTokenException._create(
          activationTokenExceptionCode, 
          e.message,
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
      final registrationExceptionCode = RegistrationExceptionCode.codeFromString(e.code);
      if (registrationExceptionCode != null) {
        throw RegistrationException._create(
          registrationExceptionCode, 
          e.message, 
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
      final authenticationExceptionCode = AuthenticationExceptionCode.codeFromString(e.code);
      if (authenticationExceptionCode != null) {
        throw AuthenticationException._create(
          authenticationExceptionCode, 
          e.message, 
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
      final authenticationSessionDetailsExceptionCode = AuthenticationSessionDetailsExceptionCode.codeFromString(e.code);
      if (authenticationSessionDetailsExceptionCode != null) {
        throw AuthenticationSessionDetailsException._create(
          authenticationSessionDetailsExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    } 
  }

  Future<bool> authenticateWithLink(User user,Uri link, String pin) async {
    try {
      final mUser = user._toMUser();

      return await _sdk.authenticateWithLink(mUser, link.toString(), pin);
    } on PlatformException catch(e) {
      final authenticationExceptionCode = AuthenticationExceptionCode.codeFromString(e.code);
      if (authenticationExceptionCode != null) {
        throw AuthenticationException._create(
          authenticationExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<bool> authenticateWithQRCode(User user, String qrCode, String pin) async {
    try {
      final mUser = user._toMUser();
      
      return await _sdk.authenticateWithQrCode(mUser, qrCode, pin);
    } on PlatformException catch(e) {
      final authenticationExceptionCode = AuthenticationExceptionCode.codeFromString(e.code);
      if (authenticationExceptionCode != null) {
        throw AuthenticationException._create(
          authenticationExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<bool> authenticateWithNotificationPayload(Map<String, String> payload, String pin) async {
    try {
      return await _sdk.authenticateWithNotificationPayload(payload, pin);
    } on PlatformException catch(e) {
      final authenticationExceptionCode = AuthenticationExceptionCode.codeFromString(e.code);
      if (authenticationExceptionCode != null) {
        throw AuthenticationException._create(
          authenticationExceptionCode, 
          e.message, 
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
      final quickCodeExceptionCode = QuickCodeExceptionCode.codeFromString(e.code);
      if (quickCodeExceptionCode != null) {
        throw QuickCodeException._create(
          quickCodeExceptionCode, 
          e.message, 
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
      final authenticationSessionDetailsExceptionCode = AuthenticationSessionDetailsExceptionCode.codeFromString(e.code);
      if (authenticationSessionDetailsExceptionCode != null) {
        throw AuthenticationSessionDetailsException._create(
          authenticationSessionDetailsExceptionCode, 
          e.message, 
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
      final authenticationSessionDetailsExceptionCode = AuthenticationSessionDetailsExceptionCode.codeFromString(e.code);
      if (authenticationSessionDetailsExceptionCode != null) {
        throw AuthenticationSessionDetailsException._create(
          authenticationSessionDetailsExceptionCode, 
          e.message, 
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
      final signingSessionDetailsExceptionCode = SigningSessionDetailsExceptionCode.codeFromString(e.code);
      if (signingSessionDetailsExceptionCode != null) {
        throw SigningSessionDetailsException._create(
          signingSessionDetailsExceptionCode, 
          e.message, 
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
      final signingSessionDetailsExceptionCode = SigningSessionDetailsExceptionCode.codeFromString(e.code);
      if (signingSessionDetailsExceptionCode != null) {
        throw SigningSessionDetailsException._create(
          signingSessionDetailsExceptionCode, 
          e.message, 
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
      final signingExceptionCode = SigningExceptionCode.codeFromString(e.code);
      if (signingExceptionCode != null) {
        throw SigningException._create(
          signingExceptionCode, 
          e.message, 
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
