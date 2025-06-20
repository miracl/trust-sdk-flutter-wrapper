part of 'miracl_trust.dart';

enum EmailVerificationExceptionCode {
  emptyUserId,
  invalidSessionDetails,
  requestBackoff,
  verificaitonFail;
}

class EmailVerificationException implements Exception {
  final EmailVerificationExceptionCode code;
  final int? backoff;
  final String? underlyingError;

  EmailVerificationException._create(this.code, this.backoff, this.underlyingError);
}

enum ActivationTokenExceptionCode {
  emptyUserId,
  emptyVerificationCode,
  unsuccessfulVerification,
  getActivationTokenFail;
}

class ActivationTokenException implements Exception {
  final ActivationTokenExceptionCode code;
  final ActivationTokenErrorResponse? activationTokenErrorResponse;
  final String? underlyingError;

  ActivationTokenException._create(this.code, this.activationTokenErrorResponse, this.underlyingError);
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
}

class RegistrationException implements Exception {
  final RegistrationExceptionCode code;
  final String? underlyingError;

  RegistrationException._create(this.code, this.underlyingError);
}

enum AuthenticationExceptionCode {
  invalidUserData,
  invalidQRCode,
  invalidPushNotificationPayload,
  userNotFound,
  invalidLink,
  authenticationFail,
  revoked,
  invalidAuthenticationSession,
  unsuccessfulAuthentication,
  pinCancelled,
  invalidPin;
}

class AuthenticationException implements Exception {
  final AuthenticationExceptionCode code;
  final String? underlyingError;

  AuthenticationException._create(this.code, this.underlyingError);
}

enum QuickCodeExceptionCode {
  revoked,
  unsuccessfulAuthentication,
  pinCancelled,
  invalidPin,
  limitedQuickCodeGeneration,
  generationFail;
}

class QuickCodeException implements Exception {
  final QuickCodeExceptionCode code;
  final String? underlyingError;

  QuickCodeException._create(this.code, this.underlyingError);
}

enum AuthenticationSessionDetailsExceptionCode {
  invalidLink,
  invalidQRCode,
  invalidNotificationPayload,
  invalidAuthenticationSessionDetails,
  getAuthenticationSessionDetailsFail,
  abortSessionFail;
}

class AuthenticationSessionDetailsException implements Exception {
  final AuthenticationSessionDetailsExceptionCode code;
  final String? underlyingError;

  AuthenticationSessionDetailsException._create(this.code, this.underlyingError);
}

enum SigningSessionDetailsExceptionCode {
  invalidLink,
  invalidQRCode,
  invalidSigningSessionDetails,
  getSigningSessionDetailsFail,
  invalidSigningSession,
  completeSigningSessionFail,
  abortSigningSessionFail;
}

class SigningSessionDetailsException implements Exception {
  final SigningSessionDetailsExceptionCode code;
  final String? underlyingError;

  SigningSessionDetailsException._create(this.code, this.underlyingError);
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
}

class SigningException implements Exception {
  final SigningExceptionCode code;
  final String? underlyingError;

  SigningException._create(this.code, this.underlyingError);
}

enum ConfigurationExceptionCode {
  emptyProjectId;
}

class ConfigurationException implements Exception {
  final ConfigurationExceptionCode code;

  ConfigurationException._create(this.code);
}
