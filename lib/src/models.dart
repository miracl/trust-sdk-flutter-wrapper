part of 'miracl_trust.dart';

class Configuration {
    final String projectId;

    Configuration({required this.projectId});
}

enum EmailVerificationMethod {
  code,
  link;

  static EmailVerificationMethod getEmailVerificationMethod(String name) {
    return EmailVerificationMethod.values.firstWhere(
      (e) => e.name == name,
      orElse: () => EmailVerificationMethod.link,
    );
  }
}

class EmailVerificationResponse {
    final int backoff;
    final EmailVerificationMethod emailVerificationMethod;

    EmailVerificationResponse._create({
        required this.backoff,
        required this.emailVerificationMethod,
    });
}

class ActivationTokenResponse {
  final String projectId;
  final String? accessId;
  final String userId;
  final String activationToken;

  ActivationTokenResponse._create({
    required this.projectId,
    required this.accessId,
    required this.userId,
    required this.activationToken}
  );
}

class ActivationTokenErrorResponse {
  final String projectId;
  final String? accessId;
  final String userId;

  ActivationTokenErrorResponse._create({
    required this.projectId,
    required this.accessId,
    required this.userId,
  });
}

class User {
  final String userId;
  final String projectId;
  final bool revoked;
  final int pinLength;
  final String hashedMpinId;

  User._create({
    required this.userId,
    required this.projectId,
    required this.revoked,
    required this.pinLength,
    required this.hashedMpinId,
  });
}

enum VerificationMethod {
   fullCustom, 
   standardEmail;

  static VerificationMethod getVerificationMethod(String name) {
    return VerificationMethod.values.firstWhere(
      (e) => e.name == name,
      orElse: () => VerificationMethod.standardEmail,
    );
  }
}


enum IdentityType {
  email, 
  alphanumeric;

  static IdentityType getIdentityType(String name) {
    return IdentityType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => IdentityType.alphanumeric,
    );
  }
}

class AuthenticationSessionDetails {
  final String userId;
  final String projectName;
  final String projectLogoURL;
  final String projectId;
  final int pinLength;
  final VerificationMethod verificationMethod;
  final String verificationURL;
  final String verificationCustomText;
  final String identityTypeLabel;
  final bool quickCodeEnabled;
  final bool limitQuickCodeRegistration;
  final IdentityType identityType;
  final String accessId;

  AuthenticationSessionDetails._create({
    required this.userId,
    required this.projectName,
    required this.projectLogoURL,
    required this.projectId,
    required this.pinLength,
    required this.verificationMethod,
    required this.verificationURL,
    required this.verificationCustomText,
    required this.identityTypeLabel,
    required this.quickCodeEnabled,
    required this.limitQuickCodeRegistration,
    required this.identityType,
    required this.accessId,
  });
}

class QuickCode {
  final String code;
  final int expiryTime;
  final int ttlSeconds;

  QuickCode._create({
    required this.code,
    required this.expiryTime,
    required this.ttlSeconds,
  });
}

class Signature {
  final String u;
  final String v;
  final String dtas;
  final String mpinId;
  final String hash;
  final String publicKey;

  Signature._create({
    required this.u,
    required this.v,
    required this.dtas,
    required this.mpinId,
    required this.hash,
    required this.publicKey,
  });
}

class SigningResult {
  final Signature signature;
  final int timestamp;

  SigningResult._create({
    required this.signature,
    required this.timestamp,
  });
}

enum SigningSessionStatus {
  active, 
  signed;

  static SigningSessionStatus getSigningSessionStatus(String name) {
    return SigningSessionStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => SigningSessionStatus.active,
    );
  }
}

class SigningSessionDetails {
  final String userId;
  final String projectName;
  final String projectLogoURL;
  final String projectId;
  final int pinLength;
  final VerificationMethod verificationMethod;
  final String verificationURL;
  final String verificationCustomText;
  final String identityTypeLabel;
  final bool quickCodeEnabled;
  final bool limitQuickCodeRegistration;
  final IdentityType identityType;
  final String sessionId;
  final String signingHash;
  final String signingDescription;
  final SigningSessionStatus status;
  final int expireTime;

  SigningSessionDetails._create({
    required this.userId,
    required this.projectName,
    required this.projectLogoURL,
    required this.projectId,
    required this.pinLength,
    required this.verificationMethod,
    required this.verificationURL,
    required this.verificationCustomText,
    required this.identityTypeLabel,
    required this.quickCodeEnabled,
    required this.limitQuickCodeRegistration,
    required this.identityType,
    required this.sessionId,
    required this.signingHash,
    required this.signingDescription,
    required this.status,
    required this.expireTime,
  });
}