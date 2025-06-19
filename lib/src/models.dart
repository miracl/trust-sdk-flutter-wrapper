part of 'miracl_trust.dart';

/// The Configuration class is used to set up the MIRACL Trust Flutter Plugin.
class Configuration {
  final String _projectId;
  final LoggingLevel _loggingLevel;
  final Logger? _logger;
  final String? _platformUrl;

  /// Creates a [Configuration] instance.
  ///
  /// Parameters:
  /// - [projectId]: (Required) Links the SDK with the project on the MIRACL Trust platform.
  /// - [loggingLevel]: Provides a specific [LoggingLevel] for the MIRACL Trust Flutter
  ///   plugin's default logger.  Defaults to [LoggingLevel.none]. **Note:** This has no
  ///   effect if a custom [logger] is provided.
  /// - [logger]: Provides a custom [Logger] implementation for the MIRACL Trust Flutter
  ///   plugin. If this is set, the [loggingLevel] parameter is ignored.
  /// - [platformUrl]: Sets a custom MIRACL Trust platform URL.
  Configuration({
    required String projectId,
    LoggingLevel loggingLevel = LoggingLevel.none,
    Logger? logger,
    String? platformUrl,
  })  : _projectId = projectId,
        _loggingLevel = loggingLevel,
        _logger = logger,
        _platformUrl = platformUrl;
}

/// Possible email verification methods.
enum EmailVerificationMethod {
  /// Verification code is sent to the end user's email.
  code,

  /// Verification link is sent to the end user's email.
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
    /// The Unix timestamp indicating the earliest time a new verification email
    /// can be sent for the same User ID.
    final int backoff;

    /// Indicates the verification method.
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
  /// The identifier of the project against which the verification is performed.
  final String projectId;

  /// The identifier of the session from which the verification started.
  final String? accessId;

  /// The identifier of the user that is currently verified.
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
/// when there is an issue with the verification confirmation.
class ActivationTokenErrorResponse {
  /// The identifier of the project against which the verification is performed.
  final String projectId;

  /// The identifier of the session from which the verification started.
  final String? accessId;

  /// The identifier of the user for whom the verification is performed.
  final String userId;

  ActivationTokenErrorResponse._create({
    required this.projectId,
    required this.accessId,
    required this.userId,
  });
}

/// An object representing the user in the platform.
class User {
  /// The identifier of the end user - an email, username, etc.
  final String userId;

  /// The Project ID setting for the application in the MIRACL Trust platform.
  final String projectId;

  /// Whether the user is revoked.
  final bool revoked;

  /// The number of digits in the user's PIN.
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

/// An object representing details from an incoming authentication session.
class AuthenticationSessionDetails {
  /// The User ID entered by the user when the session is started.
  final String userId;

  /// The name of the project in the MIRACL Trust platform.
  final String projectName;

  /// The URL of the project logo.
  final String projectLogoURL;

  /// The Project ID setting for the application in the MIRACL Trust platform.
  final String projectId;

  /// The required length (number of digits) for the user's PIN.
  final int pinLength;

  /// Indicates the method of user verification.
  final VerificationMethod verificationMethod;

  /// The URL for verification in case a custom verification method is used.
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

  /// The identifier of the authentication session.
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

/// An object representing a `QuickCode` and its validity period.
class QuickCode {
  /// The issued `QuickCode`.
  final String code;

  /// The MIRACL Trust system time when this `QuickCode` will expire.
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

/// The result returned by the [MIRACLTrust.sign] method.
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

/// An object representing details from an incoming signing session.
class SigningSessionDetails {
  /// The User ID entered by the user when the session is started.
  final String userId;

  /// The name of the project in the MIRACL Trust platform.
  final String projectName;

  /// The URL of the project logo.
  final String projectLogoURL;

  /// The Project ID setting for the application in the MIRACL Trust platform.
  final String projectId;

  /// The required length (number of digits) for the user's PIN.
  final int pinLength;

  /// Indicates the method of user verification.
  final VerificationMethod verificationMethod;

  /// The URL for verification in case a custom verification method is used.
  final String verificationURL;

  /// The custom text specified in the MIRACL Trust portal, for the
  /// custom verification.
  final String verificationCustomText;

  /// The label of the identity which will be used for identity verification.
  final String identityTypeLabel;

  /// Indicates whether `QuickCode` is enabled for the project.
  final bool quickCodeEnabled;

  /// Indicates whether registration with `QuickCode` is allowed for identities
  /// that were also registered using `QuickCode`.
  final bool limitQuickCodeRegistration;

  /// The [IdentityType] which will be used for identity verification.
  final IdentityType identityType;

  /// The identifier of the signing session.
  final String sessionId;

  /// The hash of the transaction that needs to be signed.
  final String signingHash;

  /// The description of the transaction that needs to be signed.
  final String signingDescription;

  /// The current [SigningSessionStatus] of the session (e.g., active, signed).
  final SigningSessionStatus status;

  /// The date indicating if the session has expired.
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