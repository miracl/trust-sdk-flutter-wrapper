part of 'miracl_trust.dart';

/// An enumeration that describes email verification issues.
enum EmailVerificationExceptionCode {
  /// An empty User ID.
  emptyUserId,

  /// The session identifier in SessionDetails is empty or blank.
  invalidSessionDetails,

  /// Too many verification requests. Wait for the [EmailVerificationException.backoff] period.
  requestBackoff,

  /// Verification failed.
  verificaitonFail;
}

/// An exception thrown when there is an issue with the email verification.
class EmailVerificationException implements Exception {
  /// The specific [EmailVerificationExceptionCode] indicating the type of error.
  final EmailVerificationExceptionCode code;

  /// A Unix timestamp before a new verification email can be sent for the same User ID.
  final int? backoff;

  /// An optional string representation of the underlying error, if any.
  final String? underlyingError;

  EmailVerificationException._create(this.code, this.backoff, this.underlyingError);
}

/// An enumeration that describes email verification issues.
enum ActivationTokenExceptionCode {
  /// An empty User ID.
  emptyUserId,

  /// An empty verification code.
  emptyVerificationCode,

  /// An invalid or expired verification code. There may be [ActivationTokenErrorResponse] in the error.
  unsuccessfulVerification,

  /// The request for fetching the activation token failed.
  getActivationTokenFail;
}

/// An exception thrown when there is an issue with the verification confirmation.
class ActivationTokenException implements Exception {
  /// The specific [ActivationTokenExceptionCode] indicating the type of error.
  final ActivationTokenExceptionCode code;

  /// An optional error response providing more context.
  final ActivationTokenErrorResponse? activationTokenErrorResponse;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  ActivationTokenException._create(this.code, this.activationTokenErrorResponse, this.underlyingError);
}

/// An enumeration that describes registration issues.
enum RegistrationExceptionCode {
  /// An empty User ID.
  emptyUserId,

  /// An empty activation token.
  emptyActivationToken,

  /// An invalid activation token.
  invalidActivationToken,

  /// The registration failed.
  registrationFail,

  /// The curve returned by the platform is unsupported by this version of the SDK.
  unsupportedEllipticCurve,

  /// PIN not entered.
  pinCancelled,

  /// The PIN code includes invalid symbols or the PIN length does not match.
  invalidPin,

  /// The registration was started for a different project.
  projectMismatch;
}

/// An exception thrown when there is an issue with the registration.
class RegistrationException implements Exception {
  /// The specific [RegistrationExceptionCode] indicating the type of error.
  final RegistrationExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  RegistrationException._create(this.code, this.underlyingError);
}

/// An enumeration that describes authentication issues.
enum AuthenticationExceptionCode {
  /// The user object passed for authentication is not valid.
  invalidUserData,

  /// Could not find the session identifier in the QR URL.
  invalidQRCode,

  /// Could not find a valid `projectID`, `qrURL`, or `userID` in the
  /// push notification payload.
  invalidPushNotificationPayload,

  /// There isn't a registered user for the provided User ID and project
  /// in the push notification payload.
  userNotFound,

  /// Could not find the session identifier in the link.
  invalidLink,

  /// Authentication failed.
  authenticationFail,

  /// The user registration has been revoked due to too many unsuccessful
  /// authentication attempts or prolonged inactivity. The device must be
  /// re-registered.
  revoked,

  /// An invalid or expired authentication session.
  invalidAuthenticationSession,

  /// The authentication was not successful.
  unsuccessfulAuthentication,

  /// PIN not entered.
  pinCancelled,

  /// The PIN code includes invalid symbols or the PIN length does not match.
  invalidPin, 
  
  /// Invalid or expired cross-device session.
  invalidCrossDeviceSession;
}

/// An exception thrown when there is an issue with the authentication.
class AuthenticationException implements Exception {
  /// The specific [AuthenticationExceptionCode] indicating the type of error.
  final AuthenticationExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  AuthenticationException._create(this.code, this.underlyingError);
}

/// An enumeration that describes [QuickCode] generation issues.
enum QuickCodeExceptionCode {
  /// The user registration has been revoked due to too many unsuccessful
  /// authentication attempts or prolonged inactivity. The device must be
  /// re-registered.
  revoked,

  /// The authentication was not successful.
  unsuccessfulAuthentication,

  /// PIN not entered.
  pinCancelled,

  /// The PIN code includes invalid symbols or the PIN length does not match.
  invalidPin,

  /// The `QuickCode` generation failed.
  generationFail;
}

/// An exception thrown when there is an issue with the [QuickCode] generation.
class QuickCodeException implements Exception {
  /// The specific [QuickCodeExceptionCode] indicating the type of error.
  final QuickCodeExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  QuickCodeException._create(this.code, this.underlyingError);
}

/// An enumeration that describes authentication session management issues.
enum AuthenticationSessionDetailsExceptionCode {
  /// Could not find the session identifier in the link.
  invalidLink,

  /// Could not find the session identifier in the QR code.
  invalidQRCode,

  /// Could not find the session identifier in the push notification payload.
  invalidNotificationPayload,

  /// The session identifier in `AuthenticationSessionDetails` is empty or blank.
  invalidAuthenticationSessionDetails,

  /// Fetching the authentication session details failed.
  getAuthenticationSessionDetailsFail,

  /// The abort of the authentication session has failed.
  abortSessionFail;
}

/// An exception thrown when there is an issue with the authentication session management.
class AuthenticationSessionDetailsException implements Exception {
  /// The specific [AuthenticationSessionDetailsExceptionCode] indicating the type of error.
  final AuthenticationSessionDetailsExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  AuthenticationSessionDetailsException._create(this.code, this.underlyingError);
}

/// An enumeration that describes signing session management issues.
enum SigningSessionDetailsExceptionCode {
  /// Could not find the session identifier in the link.
  invalidLink,

  /// Could not find the session identifier in the QR code.
  invalidQRCode,

  /// The session identifier in `SigningSessionDetails` is empty or blank.
  invalidSigningSessionDetails,

  /// Fetching the signing session details failed.
  getSigningSessionDetailsFail,

  /// An invalid or expired signing session.
  invalidSigningSession,

  /// Signing session completion failed.
  completeSigningSessionFail,

  /// The abort of the signing session has failed.
  abortSigningSessionFail;
}

/// An exception thrown when there is an issue with the signing session management.
class SigningSessionDetailsException implements Exception {
  /// The specific [SigningSessionDetailsExceptionCode] indicating the type of error.
  final SigningSessionDetailsExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  SigningSessionDetailsException._create(this.code, this.underlyingError);
}

/// An enumeration that describes signing issues.
enum SigningExceptionCode {
  /// Empty message hash.
  emptyMessageHash,

  /// The public key of the signing identity is empty.
  emptyPublicKey,

  /// The user object passed for signing is not valid.
  invalidUserData,

  /// PIN not entered.
  pinCancelled,

  /// The PIN code includes invalid symbols or the PIN length does not match.
  invalidPin,

  /// The signing failed.
  signingFail,

  /// The user registration has been revoked due to too many unsuccessful
  /// authentication attempts or prolonged inactivity. The device must be
  /// re-registered.
  revoked,

  /// The authentication was not successful.
  unsuccessfulAuthentication,

  /// The signing session is invalid or has expired.
  invalidSigningSession,

  /// The session identifier in `SigningSessionDetails` is empty or blank.
  invalidSigningSessionDetails;
}

/// An exception thrown when there is an issue with the signing.
class SigningException implements Exception {
  /// The specific [SigningExceptionCode] indicating the type of error.
  final SigningExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  SigningException._create(this.code, this.underlyingError);
}

/// An enumeration that describes issues with the SDK configuration.
enum ConfigurationExceptionCode {
  /// An empty project ID.
  emptyProjectId,

  // An invalid project URL.
  invalidProjectUrl;
}

/// An exception thrown when there is an issue with the SDK configuration.
class ConfigurationException implements Exception {
  /// The specific [ConfigurationExceptionCode] indicating the type of configuration error.
  final ConfigurationExceptionCode code;

  ConfigurationException._create(this.code);
}
