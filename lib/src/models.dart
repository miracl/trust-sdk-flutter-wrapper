part of 'miracl_trust.dart';

/// The Configuration class is used to set up the MIRACLTrust SDK.
class Configuration {
    /// Required to link the SDK with the project on the MIRACL Trust platform.
    final String projectId;

    /// Creates a [Configuration] instance.
    ///
    /// Requires a [projectId] to link the SDK with the project
    /// on the MIRACLTrust platform.
    Configuration({required this.projectId});
}

/// Possible email verification methods.
enum EmailVerificationMethod {
  /// Verification code is sent to the user email.
  code,

  /// Verification link is sent to the user email.
  link;

  /// Returns the [EmailVerificationMethod] corresponding to the given string [name].
  ///
  /// If no method matches the [name], this returns [EmailVerificationMethod.link] as a default.
  static EmailVerificationMethod getEmailVerificationMethod(String name) {
    return EmailVerificationMethod.values.firstWhere(
      (e) => e.name == name,
      orElse: () => EmailVerificationMethod.link,
    );
  }
}

/// Response object returned from the [MIRACLTrust.sendVerificationEmail] method.
class EmailVerificationResponse {
    /// Unix timestamp indicating the earliest time a new verification email
    /// can be sent for the same user ID.
    final int backoff;

    /// Indicates the method of the verification.
    final EmailVerificationMethod emailVerificationMethod;

    EmailVerificationResponse._create({
        required this.backoff,
        required this.emailVerificationMethod,
    });
}

/// Response object returned from either the
/// [MIRACLTrust.getActivationTokenByURI] or
/// [MIRACLTrust.getActivationTokenByUserIdAndCode] methods.
class ActivationTokenResponse {
  /// Identifier of the project against which the verification is performed.
  final String projectId;

  /// Identifier of the session from which the verification started.
  final String? accessId;

  /// Identifier of the user that is currently verified.
  final String userId;

  /// The activation token returned after successful user verification.
  final String activationToken;

  ActivationTokenResponse._create({
    required this.projectId,
    required this.accessId,
    required this.userId,
    required this.activationToken}
  );
}

/// The response returned from activation token retrieval methods
/// (e.g., [MIRACLTrust.getActivationTokenByURI],
/// [MIRACLTrust.getActivationTokenByUserIdAndCode])
/// when there is an issue with the request or processing.
class ActivationTokenErrorResponse {
  /// Identifier of the project against which the verification is performed.
  final String projectId;

  /// Identifier of the session from which the verification started.
  final String? accessId;

  /// Identifier of the user for which the verification is performed.
  final String userId;

  ActivationTokenErrorResponse._create({
    required this.projectId,
    required this.accessId,
    required this.userId,
  });
}

/// Object representing the user in the platform.
class User {
  /// Identifier of the user. Could be email, username, etc.
  final String userId;

  /// Required to link the user with the project on the MIRACLTrust platform.
  final String projectId;

  /// Whether the user is revoked.
  final bool revoked;

  /// The number of the digits the user PIN should be.
  final int pinLength;

  /// Hex encoded SHA256 representation of the mpinId property.
  final String hashedMpinId;

  User._create({
    required this.userId,
    required this.projectId,
    required this.revoked,
    required this.pinLength,
    required this.hashedMpinId,
  });
}

/// Possible verification methods that can be used for identity verification.
enum VerificationMethod {
  /// Custom identity verification, done with a client implementation.
  fullCustom,

  /// Identity verification done by email.
  standardEmail;

  /// Returns the [VerificationMethod] corresponding to the given string [name].
  ///
  /// If no method matches the [name], this returns [VerificationMethod.standardEmail] as a default.
  static VerificationMethod getVerificationMethod(String name) {
    return VerificationMethod.values.firstWhere(
      (e) => e.name == name,
      orElse: () => VerificationMethod.standardEmail,
    );
  }
}

/// Possible identity types that can be used for identity verification.
enum IdentityType {
  /// Identity is identified with email.
  email,

  /// Identity is identified with alphanumeric symbols.
  alphanumeric;

  /// Returns the [IdentityType] corresponding to the given string [name].
  ///
  /// If no method matches the [name], this returns [IdentityType.alphanumeric] as a default.
  static IdentityType getIdentityType(String name) {
    return IdentityType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => IdentityType.alphanumeric,
    );
  }
}

/// Object representing details from an incoming authentication session.
class AuthenticationSessionDetails {
  /// User ID entered by the user when the session is started.
  final String userId;

  /// Name of the project in the MIRACL Trust platform.
  final String projectName;

  /// URL of the project logo.
  final String projectLogoURL;

  /// Project ID setting for the application in the MIRACL Trust platform.
  final String projectId;

  /// The required length (number of digits) for the user's PIN.
  final int pinLength;

  /// Indicates the method of user verification.
  final VerificationMethod verificationMethod;

  /// URL for verification in case of custom verification method.
  final String verificationURL;

  /// Custom text specified in the MIRACL Trust portal for the
  /// custom verification.
  final String verificationCustomText;

  /// Label of the identity which will be used for identity verification.
  final String identityTypeLabel;

  /// Indicates whether `QuickCode` is enabled for the project.
  final bool quickCodeEnabled;

  /// Indicates whether registration with `QuickCode` is allowed for identities
  /// that were also registered using `QuickCode`.
  final bool limitQuickCodeRegistration;

  /// The [IdentityType] which will be used for identity verification.
  final IdentityType identityType;

  /// Identifier of the authentication session.
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

/// Object representing a `QuickCode` and its validity period.
class QuickCode {
  /// The issued `QuickCode`.
  final String code;

  /// The MIRACL Trust system time at which this `QuickCode` will expire.
  final int expiryTime;

  /// The expiration period in seconds.
  final int ttlSeconds;

  QuickCode._create({
    required this.code,
    required this.expiryTime,
    required this.ttlSeconds,
  });
}

/// Represents the components of a MIRACL Trust cryptographic signature.
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

/// Result returned from the [MIRACLTrust.sign] method.
class SigningResult {
  /// The cryptographic representation of the signature.
  final Signature signature;

  /// When the document has been signed.
  final int timestamp;

  SigningResult._create({
    required this.signature,
    required this.timestamp,
  });
}

/// An enumeration describing the status of the signing session.
enum SigningSessionStatus {
  /// The session is active.
  active,

  /// The session has finished signing the transaction.
  signed;

  /// Returns the [SigningSessionStatus] corresponding to the given string [name].
  ///
  /// If no method matches the [name], this returns [SigningSessionStatus.active] as a default.
  static SigningSessionStatus getSigningSessionStatus(String name) {
    return SigningSessionStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => SigningSessionStatus.active,
    );
  }
}

/// Object representing details from an incoming signing session.
class SigningSessionDetails {
  /// User ID entered by the user when the session is started.
  final String userId;

  /// Name of the project in the MIRACL Trust platform.
  final String projectName;

  /// URL of the project logo.
  final String projectLogoURL;

  /// Project ID setting for the application in the MIRACL Trust platform.
  final String projectId;

  /// The required length (number of digits) for the user's PIN.
  final int pinLength;

  /// Indicates the method of user verification.
  final VerificationMethod verificationMethod;

  /// URL for verification in case of custom verification method.
  final String verificationURL;

  /// Custom text specified in the MIRACL Trust portal, for the
  /// custom verification.
  final String verificationCustomText;

  /// Label of the identity which will be used for identity verification.
  final String identityTypeLabel;

  /// Indicates whether `QuickCode` is enabled for the project.
  final bool quickCodeEnabled;

  /// Indicates whether registration with `QuickCode` is allowed for identities
  /// that were also registered using `QuickCode`.
  final bool limitQuickCodeRegistration;

  /// The [IdentityType] which will be used for identity verification.
  final IdentityType identityType;

  /// Identifier of the signing session.
  final String sessionId;

  /// Hash of the transaction that needs to be signed.
  final String signingHash;

  /// Description of the transaction that needs to be signed.
  final String signingDescription;

  /// Current [SigningSessionStatus] of the session (e.g., active, signed).
  final SigningSessionStatus status;

  /// Date indicating if session is expired.
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