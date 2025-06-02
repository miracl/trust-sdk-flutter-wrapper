part of 'miracl_trust.dart';

class MIRACLException implements Exception {}

class EmailVerificationException extends MIRACLException {
  final EmailVerificationExceptionCode code;
  final String? message;
  final int? backoff;
  final String? underlyingError;

  EmailVerificationException._create(this.code ,this.message, this.backoff, this.underlyingError);
}

class ActivationTokenException extends MIRACLException {
  final ActivationTokenExceptionCode code;
  final String? message;
  final ActivationTokenErrorResponse? activationTokenErrorResponse;
  final String? underlyingError;

  ActivationTokenException._create(this.code, this.message, this.activationTokenErrorResponse, this.underlyingError);
}

class RegistrationException extends MIRACLException {
  final RegistrationExceptionCode code;
  final String? message;
  final String? underlyingError;

  RegistrationException._create(this.code, this.message, this.underlyingError);
}

class AuthenticationException extends MIRACLException {
  final AuthenticationExceptionCode code;
  final String? message;
  final String? underlyingError;

  AuthenticationException._create(this.code, this.message, this.underlyingError);
}

class QuickCodeException extends MIRACLException {
  final QuickCodeExceptionCode code;
  final String? message;
  final String? underlyingError;

  QuickCodeException._create(this.code, this.message, this.underlyingError);
}

class AuthenticationSessionDetailsException extends MIRACLException {
  final AuthenticationSessionDetailsExceptionCode code;
  final String? message;
  final String? underlyingError;

  AuthenticationSessionDetailsException._create(this.code, this.message, this.underlyingError);
}

class SigningSessionDetailsException extends MIRACLException {
  final SigningSessionDetailsExceptionCode code;
  final String? message;
  final String? underlyingError;

  SigningSessionDetailsException._create(this.code, this.message, this.underlyingError);
}

class SigningException extends MIRACLException {
  final SigningExceptionCode code;
  final String? message;
  final String? underlyingError;

  SigningException._create(this.code, this.message, this.underlyingError);
}

class ConfigurationException extends MIRACLException {
  final ConfigurationExceptionCode code;
  final String? message;

  ConfigurationException._create(this.code, this.message);
}
