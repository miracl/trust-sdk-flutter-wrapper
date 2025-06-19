part of 'miracl_trust.dart';

/// Exception thrown when there is an issue with the email verification.
class EmailVerificationException implements Exception {
  /// The specific [EmailVerificationExceptionCode] indicating the type of error.
  final EmailVerificationExceptionCode code;

  /// Unix timestamp before a new verification email could be sent for the same user ID.
  final int? backoff;

  /// An optional string representation of the underlying error, if any.
  final String? underlyingError;

  EmailVerificationException._create(this.code, this.backoff, this.underlyingError);
}

/// Exception thrown when there is an issue with the verification confirmation.
class ActivationTokenException implements Exception {
  /// The specific [ActivationTokenExceptionCode] indicating the type of error.
  final ActivationTokenExceptionCode code;

  /// An optional error response providing more context.
  final ActivationTokenErrorResponse? activationTokenErrorResponse;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  ActivationTokenException._create(this.code, this.activationTokenErrorResponse, this.underlyingError);
}

/// Exception thrown when there is an issue with the registration.
class RegistrationException implements Exception {
  /// The specific [RegistrationExceptionCode] indicating the type of error.
  final RegistrationExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  RegistrationException._create(this.code, this.underlyingError);
}

/// Exception thrown when there is an issue with the authentication.
class AuthenticationException implements Exception {
  /// The specific [AuthenticationExceptionCode] indicating the type of error.
  final AuthenticationExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  AuthenticationException._create(this.code, this.underlyingError);
}

/// Exception thrown when there is an issue with the `QuickCode` generation.
class QuickCodeException implements Exception {
  /// The specific [QuickCodeExceptionCode] indicating the type of error.
  final QuickCodeExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  QuickCodeException._create(this.code, this.underlyingError);
}

/// Exception thrown when there is an issue with the authentication session management.
class AuthenticationSessionDetailsException implements Exception {
  /// The specific [AuthenticationSessionDetailsExceptionCode] indicating the type of error.
  final AuthenticationSessionDetailsExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  AuthenticationSessionDetailsException._create(this.code, this.underlyingError);
}

/// Exception thrown when there is an issue with the signing session management.
class SigningSessionDetailsException implements Exception {
  /// The specific [SigningSessionDetailsExceptionCode] indicating the type of error.
  final SigningSessionDetailsExceptionCode code;

  /// An optional, human-readable message providing more details about the error.
  final String? underlyingError;

  SigningSessionDetailsException._create(this.code, this.underlyingError);
}

/// Exception thrown when there is an issue with the signing.
class SigningException implements Exception {
  /// The specific [SigningExceptionCode] indicating the type of error.
  final SigningExceptionCode code;
  final String? underlyingError;

  SigningException._create(this.code, this.underlyingError);
}

/// Exception thrown when there is an issue with the SDK configuration.
class ConfigurationException implements Exception {
  /// The specific [ConfigurationExceptionCode] indicating the type of configuration error.
  final ConfigurationExceptionCode code;

  ConfigurationException._create(this.code);
}
