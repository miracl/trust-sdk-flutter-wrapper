import 'package:pigeon/pigeon.dart';

class MConfiguration {
  final String projectId;
  final String applicationInfo;

  MConfiguration(this.projectId, this.applicationInfo);
}

class MActivationTokenResponse {
  final String projectId;
  final String? accessId;
  final String userId;
  final String activationToken;

  MActivationTokenResponse(
    this.projectId,
    this.accessId,
    this.userId,
    this.activationToken,
  );
}

enum MVerificationMethod {
   fullCustom, 
   standardEmail
}

enum MEmailVerificationMethod {
  code,
  link
}

enum MIdentityType {
  email, 
  alphanumeric
}

enum MSigningSessionStatus {
  active, 
  signed
}

class MAuthenticationSessionDetails {
  final String userId;
  final String projectName;
  final String projectLogoURL;
  final String projectId; 
  final int pinLength;
  final MVerificationMethod verificationMethod;
  final String verificationURL;
  final String verificationCustomText;
  final String identityTypeLabel;
  final bool quickCodeEnabled;
  final bool limitQuickCodeRegistration;
  final MIdentityType identityType;
  final String accessId;

  MAuthenticationSessionDetails(
    this.userId, 
    this.projectName,
    this.projectLogoURL,
    this.projectId,
    this.pinLength,
    this.verificationMethod,
    this.verificationURL,
    this.verificationCustomText,
    this.identityTypeLabel,
    this.quickCodeEnabled,
    this.limitQuickCodeRegistration,
    this.identityType,
    this.accessId
  );
}

class MSigningSessionDetails {
  final String userId;
  final String projectName;
  final String projectLogoURL;
  final String projectId; 
  final int pinLength;
  final MVerificationMethod verificationMethod;
  final String verificationURL;
  final String verificationCustomText;
  final String identityTypeLabel;
  final bool quickCodeEnabled;
  final bool limitQuickCodeRegistration;
  final MIdentityType identityType;
  final String sessionId;
  final String signingHash;
  final String signingDescription;
  final MSigningSessionStatus status;
  final int expireTime;

  MSigningSessionDetails(
    this.userId, 
    this.projectName,
    this.projectLogoURL,
    this.projectId,
    this.pinLength,
    this.verificationMethod,
    this.verificationURL,
    this.verificationCustomText,
    this.identityTypeLabel,
    this.quickCodeEnabled,
    this.limitQuickCodeRegistration,
    this.identityType,
    this.sessionId,
    this.signingHash,
    this.signingDescription,
    this.status,
    this.expireTime
  );
}

class MUser {
  final String projectId;
  final bool revoked;
  final String userId;
  final int pinLength;
  final String hashedMpinId;

  MUser(
    this.projectId,
    this.revoked,
    this.userId,
    this.pinLength,
    this.hashedMpinId,
  );
}

class MQuickCode {
  final String code;
  final int expiryTime;
  final int ttlSeconds;

  MQuickCode(this.code, this.expiryTime, this.ttlSeconds);
}

class MSignature {
  final String u;
  final String v;
  final String dtas;
  final String mpinId;
  final String hash;
  final String publicKey;

  MSignature(this.u, this.v, this.dtas, this.mpinId, this.hash, this.publicKey);
}

class MSigningResult {
  final MSignature signature;
  final int timestamp;

  MSigningResult(this.signature, this.timestamp);
}

class MActivationTokenErrorResponse {
  final String projectId;
  final String? accessId;
  final String userId;

  MActivationTokenErrorResponse(this.projectId, this.accessId, this.userId);
}

class MEmailVerificationResponse {
  final int backoff;
  final MEmailVerificationMethod emailVerificationMethod;

  MEmailVerificationResponse(this.backoff, this.emailVerificationMethod);
}

/// An enumeration that describes issues with the SDK configuration.
enum ConfigurationExceptionCode {
  /// Empty project ID.
  emptyProjectId;
}

/// An enumeration that describes email verification issues.
enum EmailVerificationExceptionCode {
  /// Empty user ID.
  emptyUserId,

  /// The session identifier in SessionDetails is empty or blank.
  invalidSessionDetails,

  /// Too many verification requests. Wait for the [EmailVerificationException.backoff] period.
  requestBackoff,

  /// Verification failed.
  verificaitonFail;
}

/// An enumeration that describes email verification issues.
enum ActivationTokenExceptionCode {
  /// Empty user ID.
  emptyUserId,

  /// Empty verification code.
  emptyVerificationCode,

  /// Invalid or expired verification code. There may be [ActivationTokenErrorResponse] in the error.
  unsuccessfulVerification,

  /// The request for fetching the activation token failed.
  getActivationTokenFail;
}

/// An enumeration that describes registration issues.
enum RegistrationExceptionCode {
  /// Empty user ID.
  emptyUserId,

  /// Empty activation token.
  emptyActivationToken,

  /// Invalid activation token.
  invalidActivationToken,

  /// Registration failed.
  registrationFail,

  /// Curve returned by the platform is unsupported by this version of the SDK.
  unsupportedEllipticCurve,

  /// Pin not entered.
  pinCancelled,

  /// Pin code includes invalid symbols or pin length does not match.
  invalidPin,

  /// The registration was started for a different project.
  projectMismatch;
}

/// An enumeration that describes authentication issues.
enum AuthenticationExceptionCode {
  /// User object passed for authentication is not valid.
  invalidUserData,

  /// Could not find the session identifier in the QR URL.
  invalidQRCode,

  /// Could not find a valid `projectID`, `qrURL`, or `userID` in the
  /// push notification payload.
  invalidPushNotificationPayload,

  /// There isn't a registered user for the provided user ID and project
  /// in the push notification payload.
  userNotFound,

  /// Could not find the session identifier in the link.
  invalidLink,

  /// Authentication failed.
  authenticationFail,

  /// The user is revoked because of too many unsuccessful authentication attempts
  /// or has not been used in a substantial amount of time. The device needs to
  /// be re-registered.
  revoked,

  /// Invalid or expired authentication session.
  invalidAuthenticationSession,

  /// The authentication was not successful.
  unsuccessfulAuthentication,

  /// Pin not entered.
  pinCancelled,

  /// Pin code includes invalid symbols or pin length does not match.
  invalidPin;
}

/// An enumeration that describes `QuickCode` generation issues.
enum QuickCodeExceptionCode {
  /// The user is revoked because of too many unsuccessful authentication attempts
  /// or has not been used in a substantial amount of time. The device needs to
  /// be re-registered.
  revoked,

  /// The authentication was not successful.
  unsuccessfulAuthentication,

  /// Pin not entered.
  pinCancelled,

  /// Pin code includes invalid symbols or pin length does not match.
  invalidPin,

  /// Generating `QuickCode` from this registration is not allowed.
  limitedQuickCodeGeneration,

  /// `QuickCode` generation failed.
  generationFail;
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

  /// Abort of the authentication session has failed.
  abortSessionFail;
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

  /// Invalid or expired signing session.
  invalidSigningSession,

  /// Signing session completion failed.
  completeSigningSessionFail,

  /// Abort of the signing session has failed.
  abortSigningSessionFail;
}

/// An enumeration that describes signing issues.
enum SigningExceptionCode {
  /// Empty message hash.
  emptyMessageHash,

  /// The public key of the signing identity is empty.
  emptyPublicKey,

  /// The user object passed for signing is not valid.
  invalidUserData,

  /// Pin not entered.
  pinCancelled,

  /// Pin code includes invalid symbols or pin length does not match.
  invalidPin,

  /// Signing failed.
  signingFail,

  /// The user is revoked because of too many unsuccessful authentication attempts
  /// or has not been used in a substantial amount of time. The device needs to
  /// be re-registered.
  revoked,

  /// The authentication was not successful.
  unsuccessfulAuthentication,

  /// The signing session is invalid or has expired.
  invalidSigningSession,

  /// The session identifier in `SigningSessionDetails` is empty or blank.
  invalidSigningSessionDetails;
}

@HostApi()
abstract class MiraclSdk {
  @async
  void initSdk(MConfiguration configuration);

  @async
  void setProjectId(String projectId);

  @async
  MEmailVerificationResponse sendVerificationEmail(String userId);

  @async
  MActivationTokenResponse getActivationTokenByURI(String uri);

  @async
  MActivationTokenResponse getActivationTokenByUserIdAndCode(String userId, String code);

  @async
  List<MUser> getUsers();

  @async
  MUser register(
    String userId,
    String activationToken,
    String pin,
    String? pushToken,
  );

  @async
  String authenticate(
    MUser user,
    String pin,
  );

  @async
  void delete(MUser user);

  @async
  MUser? getUser(String userId);

  @async
  MQuickCode generateQuickCode(MUser user, String pin);

  @async
  MSigningResult sign(MUser user, Uint8List message, String pin);

  @async
  bool authenticateWithQrCode(MUser user, String qrCode, String pin);

  @async
  bool authenticateWithLink(MUser user, String link, String pin);

  @async
  bool authenticateWithNotificationPayload(
    Map<String, String> payload,
    String pin,
  );

  @async
  MAuthenticationSessionDetails getAuthenticationSessionDetailsFromQRCode(
    String qrCode
  );

  @async
  MAuthenticationSessionDetails getAuthenticationSessionDetailsFromLink(
    String link
  );

  @async
  MAuthenticationSessionDetails getAuthenticationSessionDetailsFromPushNofitifactionPayload(
    Map<String, String> payload
  );
  
  @async
  MSigningSessionDetails getSigningDetailsFromQRCode(
    String qrCode
  );

  @async
  MSigningSessionDetails getSigningSessionDetailsFromLink(
    String link
  );
}