part of 'miracl_trust.dart';

class MIRACLException implements Exception {}

enum EmailVerificationExceptionCode {
  emptyUserId,
  invalidSessionDetails,
  requestBackoff,
  verificaitonFail;

  static EmailVerificationExceptionCode? codeFromString(String value) {
    return EmailVerificationExceptionCode.values._firstWhereOrNull((e) => e.name.toLowerCase() == value.toLowerCase());
  }
}

class EmailVerificationException extends MIRACLException {
  final EmailVerificationExceptionCode code;
  final String? message;
  final int? backoff;
  final String? underlyingError;

  EmailVerificationException._create(this.code ,this.message, this.backoff, this.underlyingError);
}

enum ActivationTokenExceptionCode {
  emptyUserId,
  emptyVerificationCode,
  unsuccessfulVerification,
  getActivationTokenFail;

  static ActivationTokenExceptionCode? codeFromString(String value) {
    return ActivationTokenExceptionCode.values._firstWhereOrNull((e) => e.name.toLowerCase() == value.toLowerCase());
  }
}

class ActivationTokenException extends MIRACLException {
  final ActivationTokenExceptionCode code;
  final String? message;
  final ActivationTokenErrorResponse? activationTokenErrorResponse;
  final String? underlyingError;

  ActivationTokenException._create(this.code, this.message, this.activationTokenErrorResponse, this.underlyingError);
}

enum RegistrationExceptionCode {
  emptyUserId,
  emptyActivationToken,
  invalidActivationToken,
  registrationFail,
  unsupportedEllipticCurve,
  pinCancelled,
  invalidPin,
  projectMismatch;

  static RegistrationExceptionCode? codeFromString(String value) {
    return RegistrationExceptionCode.values._firstWhereOrNull((e) => e.name.toLowerCase() == value.toLowerCase());
  }
}

class RegistrationException extends MIRACLException {
  final RegistrationExceptionCode code;
  final String? message;
  final String? underlyingError;

  RegistrationException._create(this.code, this.message, this.underlyingError);
}

enum AuthenticationExceptionCode {
  invalidUserData,
  invalidQRCode,
  invalidPushNotificationPayload,
  userNotFound,
  invalidUniversalLink,
  authenticationFail,
  revoked,
  invalidAuthenticationSession,
  unsuccessfulAuthentication,
  pinCancelled,
  invalidPin;

  static AuthenticationExceptionCode? codeFromString(String value) {
    return AuthenticationExceptionCode.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase()
    ); 
  }
}

class AuthenticationException extends MIRACLException {
  final AuthenticationExceptionCode code;
  final String? message;
  final String? underlyingError;

  AuthenticationException._create(this.code, this.message, this.underlyingError);
}

enum QuickCodeExceptionCode {
  revoked,
  unsuccessfulAuthentication,
  pinCancelled,
  invalidPin,
  limitedQuickCodeGeneration,
  generationFail;

  static QuickCodeExceptionCode? codeFromString(String value) {
    return QuickCodeExceptionCode.values._firstWhereOrNull((e) => e.name.toLowerCase() == value.toLowerCase());
  }
}

class QuickCodeException extends MIRACLException {
  final QuickCodeExceptionCode code;
  final String? message;
  final String? underlyingError;

  QuickCodeException._create(this.code, this.message, this.underlyingError);
}

enum AuthenticationSessionDetailsExceptionCode {
  invalidLink,
  invalidQRCode,
  invalidNotificationPayload,
  invalidAuthenticationSessionDetails,
  getAuthenticationSessionDetailsFail,
  abortSessionFail;

  static AuthenticationSessionDetailsExceptionCode? codeFromString(String value) {
    if (value == "InvalidAppLink" || value == "invalidUniversalLinkURL")  {
      return AuthenticationSessionDetailsExceptionCode.invalidLink;
    }

    if (value == "invalidPushNotificationPayload" || value == "InvalidNotificationPayload")  {
      return AuthenticationSessionDetailsExceptionCode.invalidNotificationPayload;
    }

    return AuthenticationSessionDetailsExceptionCode
      .values
      ._firstWhereOrNull((e) => e.name.toLowerCase() == value.toLowerCase());
  }
}

class AuthenticationSessionDetailsException extends MIRACLException {
  final AuthenticationSessionDetailsExceptionCode code;
  final String? message;
  final String? underlyingError;

  AuthenticationSessionDetailsException._create(this.code, this.message, this.underlyingError);
}

enum SigningSessionDetailsExceptionCode {
  invalidLink,
  invalidQRCode,
  invalidSigningSessionDetails,
  getSigningSessionDetailsFail,
  invalidSigningSession,
  abortSigningSessionFail;

  static SigningSessionDetailsExceptionCode? codeFromString(String value) {
    if (value == "InvalidAppLink" || value == "invalidUniversalLinkURL")  {
      return SigningSessionDetailsExceptionCode.invalidLink;
    }
    return SigningSessionDetailsExceptionCode.values._firstWhereOrNull((e) => e.name.toLowerCase() == value.toLowerCase());
  }
}

class SigningSessionDetailsException extends MIRACLException {
  final SigningSessionDetailsExceptionCode code;
  final String? message;
  final String? underlyingError;

  SigningSessionDetailsException._create(this.code, this.message, this.underlyingError);
}

enum SigningExceptionCode {
  emptyMessageHash,
  emptyPublicKey,
  invalidUserData,
  pinCancelled,
  invalidPin,
  signingFail,
  revoked,
  unsuccessfulAuthentication,
  invalidSigningSession,
  invalidSigningSessionDetails;

  static SigningExceptionCode? codeFromString(String value) {
    return SigningExceptionCode.values._firstWhereOrNull((e) => e.name.toLowerCase() == value.toLowerCase());
  }

}

class SigningException extends MIRACLException {
  final SigningExceptionCode code;
  final String? message;
  final String? underlyingError;

  SigningException._create(this.code, this.message, this.underlyingError);
}

enum ConfigurationExceptionCode {
  emptyProjectId;

  static ConfigurationExceptionCode? codeFromString(String value) {
    if (value == "EmptyProjectId" || value == "configurationEmptyProjectId") {
      return ConfigurationExceptionCode.emptyProjectId;
    }
    
    return null;
  }
}

class ConfigurationException extends MIRACLException {
  final ConfigurationExceptionCode code;
  final String? message;

  ConfigurationException._create(this.code, this.message);
}
