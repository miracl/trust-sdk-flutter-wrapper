import 'package:flutter/services.dart';
import 'package:flutter_miracl_sdk/src/pigeon.dart';
import 'package:flutter_miracl_sdk/src/exceptions.dart';

class MIRACLTrust {
  final MiraclSdk _sdk = MiraclSdk();

  Future<void> initSDK(MConfiguration configuration) async {
    try {
      return await _sdk.initSdk(configuration);
    } on PlatformException catch(e) {
      final configurationExceptionCode = ConfigurationExceptionCode.codeFromString(e.code);
      if (configurationExceptionCode != null) {
        throw ConfigurationException(
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
        throw ConfigurationException(
          configurationExceptionCode, 
          e.message
        );
      } else {
        rethrow;
      }
    } 
  }

  Future<MEmailVerificationResponse> sendVerificationEmail(String userId) async {
    try {
      return await _sdk.sendVerificationEmail(userId);
    } on PlatformException catch(e) {
      final emailVerificationExceptionCode = EmailVerificationExceptionCode.codeFromString(e.code);
      if (emailVerificationExceptionCode != null) {
        throw EmailVerificationException(
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

  Future<MActivationTokenResponse> getActivationTokenByURI(Uri uri) async {
    try {
      return await _sdk.getActivationTokenByURI(uri.toString());
    } on PlatformException catch(e) {
      final activationTokenExceptionCode = ActivationTokenExceptionCode.codeFromString(e.code);
      if (activationTokenExceptionCode != null) {
        throw ActivationTokenException(
          activationTokenExceptionCode, 
          e.message,
          e.details["activationTokenErrorResponse"], 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MActivationTokenResponse> getActivationTokenByUserIdAndCode(String userId, String code) async {
    try {
      return await _sdk.getActivationTokenByUserIdAndCode(userId, code);
    } on PlatformException catch(e) {
      final activationTokenExceptionCode = ActivationTokenExceptionCode.codeFromString(e.code);
      if (activationTokenExceptionCode != null) {
        throw ActivationTokenException(
          activationTokenExceptionCode, 
          e.message,
          e.details["activationTokenErrorResponse"], 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MUser> register(String userId, String activationToken, String pin, [ String? pushToken ]) async {
    try {
      return await _sdk.register(userId, activationToken, pin, pushToken);
    } on PlatformException catch(e) {
      final registrationExceptionCode = RegistrationExceptionCode.codeFromString(e.code);
      if (registrationExceptionCode != null) {
        throw RegistrationException(
          registrationExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<String> authenticate(MUser user, String pin) async {
    try {
      return await _sdk.authenticate(user, pin);
    } on PlatformException catch(e) {
      final authenticationExceptionCode = AuthenticationExceptionCode.codeFromString(e.code);
      if (authenticationExceptionCode != null) {
        throw AuthenticationException(
          authenticationExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MAuthenticationSessionDetails> getAuthenticationSessionDetailsFromPushNofitifactionPayload(
    Map<String, String> payload
  ) async {
    try {
      return await _sdk.getAuthenticationSessionDetailsFromPushNofitifactionPayload(payload);
    } on PlatformException catch(e) {
      final authenticationSessionDetailsExceptionCode = AuthenticationSessionDetailsExceptionCode.codeFromString(e.code);
      if (authenticationSessionDetailsExceptionCode != null) {
        throw AuthenticationSessionDetailsException(
          authenticationSessionDetailsExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    } 
  }

  Future<bool> authenticateWithLink(MUser user,Uri link, String pin) async {
    try {
      return await _sdk.authenticateWithLink(user, link.toString(), pin);
    } on PlatformException catch(e) {
      final authenticationExceptionCode = AuthenticationExceptionCode.codeFromString(e.code);
      if (authenticationExceptionCode != null) {
        throw AuthenticationException(
          authenticationExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<bool> authenticateWithQRCode(MUser user, String qrCode, String pin) async {
    try {
      return await _sdk.authenticateWithQrCode(user, qrCode, pin);
    } on PlatformException catch(e) {
      final authenticationExceptionCode = AuthenticationExceptionCode.codeFromString(e.code);
      if (authenticationExceptionCode != null) {
        throw AuthenticationException(
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
        throw AuthenticationException(
          authenticationExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MQuickCode> generateQuickCode(MUser user, String pin) async {
    try {
      return await _sdk.generateQuickCode(user, pin);
    } on PlatformException catch(e) {
      final quickCodeExceptionCode = QuickCodeExceptionCode.codeFromString(e.code);
      if (quickCodeExceptionCode != null) {
        throw QuickCodeException(
          quickCodeExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MAuthenticationSessionDetails> getAuthenticationSessionDetailsFromQRCode(String qrCode) async {
    try {
      return await _sdk.getAuthenticationSessionDetailsFromQRCode(qrCode);
    } on PlatformException catch(e) {
      final authenticationSessionDetailsExceptionCode = AuthenticationSessionDetailsExceptionCode.codeFromString(e.code);
      if (authenticationSessionDetailsExceptionCode != null) {
        throw AuthenticationSessionDetailsException(
          authenticationSessionDetailsExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MAuthenticationSessionDetails> getAuthenticationSessionDetailsFromLink(Uri link) async {
    try {
      return await _sdk.getAuthenticationSessionDetailsFromLink(link.toString());
    } on PlatformException catch(e) {
      final authenticationSessionDetailsExceptionCode = AuthenticationSessionDetailsExceptionCode.codeFromString(e.code);
      if (authenticationSessionDetailsExceptionCode != null) {
        throw AuthenticationSessionDetailsException(
          authenticationSessionDetailsExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MSigningSessionDetails> getSigningSessionDetailsFromQRCode(String qrCode) async {
    try {
      return await _sdk.getSigningDetailsFromQRCode(qrCode);
    } on PlatformException catch(e) {
      final signingSessionDetailsExceptionCode = SigningSessionDetailsExceptionCode.codeFromString(e.code);
      if (signingSessionDetailsExceptionCode != null) {
        throw SigningSessionDetailsException(
          signingSessionDetailsExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MSigningSessionDetails> getSigningSessionDetailsFromLink(Uri link) async {
    try {
      return await _sdk.getSigningSessionDetailsFromLink(link.toString());
    } on PlatformException catch(e) {
      final signingSessionDetailsExceptionCode = SigningSessionDetailsExceptionCode.codeFromString(e.code);
      if (signingSessionDetailsExceptionCode != null) {
        throw SigningSessionDetailsException(
          signingSessionDetailsExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<MSigningResult> sign(MUser user, Uint8List message, String pin) async {
    try {
      return await _sdk.sign(user, message, pin);
    } on PlatformException catch(e) {
      final signingExceptionCode = SigningExceptionCode.codeFromString(e.code);
      if (signingExceptionCode != null) {
        throw SigningException(
          signingExceptionCode, 
          e.message, 
          e.details["error"]
        );
      } else {
        rethrow;
      }
    }
  }

  Future<List<MUser>> getUsers() async {
    return await _sdk.getUsers();
  }

  Future<MUser?> getUser(String userId) async {
    return await _sdk.getUser(userId);
  }

  Future<void> delete(MUser user) async {
    return await _sdk.delete(user);
  }
}
