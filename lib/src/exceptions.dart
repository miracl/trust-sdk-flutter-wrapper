part of 'miracl_trust.dart';

class EmailVerificationException implements Exception {
  final EmailVerificationExceptionCode code;
  final int? backoff;
  final String? underlyingError;

  EmailVerificationException._create(this.code, this.backoff, this.underlyingError);
}

class ActivationTokenException implements Exception {
  final ActivationTokenExceptionCode code;
  final ActivationTokenErrorResponse? activationTokenErrorResponse;
  final String? underlyingError;

  ActivationTokenException._create(this.code, this.activationTokenErrorResponse, this.underlyingError);
}

class RegistrationException implements Exception {
  final RegistrationExceptionCode code;
  final String? underlyingError;

  RegistrationException._create(this.code, this.underlyingError);
}

class AuthenticationException implements Exception {
  final AuthenticationExceptionCode code;
  final String? underlyingError;

  AuthenticationException._create(this.code, this.underlyingError);
}

class QuickCodeException implements Exception {
  final QuickCodeExceptionCode code;
  final String? underlyingError;

  QuickCodeException._create(this.code, this.underlyingError);
}

class AuthenticationSessionDetailsException implements Exception {
  final AuthenticationSessionDetailsExceptionCode code;
  final String? underlyingError;

  AuthenticationSessionDetailsException._create(this.code, this.underlyingError);
}

class SigningSessionDetailsException implements Exception {
  final SigningSessionDetailsExceptionCode code;
  final String? underlyingError;

  SigningSessionDetailsException._create(this.code, this.underlyingError);
}

class SigningException implements Exception {
  final SigningExceptionCode code;
  final String? underlyingError;

  SigningException._create(this.code, this.underlyingError);
}

class ConfigurationException implements Exception {
  final ConfigurationExceptionCode code;

  ConfigurationException._create(this.code);
}
