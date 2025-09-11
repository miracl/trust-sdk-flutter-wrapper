import 'package:pigeon/pigeon.dart';

class MConfiguration {
  final String projectId;
  final String? projectUrl;
  final String applicationInfo;

  MConfiguration(
    this.projectId,
    this.projectUrl,
    this.applicationInfo,
  );
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

enum MConfigurationExceptionCode {
  emptyProjectId,
  invalidProjectUrl;
}

enum MEmailVerificationExceptionCode {
  emptyUserId,
  invalidSessionDetails,
  requestBackoff,
  verificaitonFail;
}

enum MActivationTokenExceptionCode {
  emptyUserId,
  emptyVerificationCode,
  unsuccessfulVerification,
  getActivationTokenFail;
}

enum MRegistrationExceptionCode {
  emptyUserId,
  emptyActivationToken,
  invalidActivationToken,
  registrationFail,
  unsupportedEllipticCurve,
  pinCancelled,
  invalidPin,
  projectMismatch;
}

enum MAuthenticationExceptionCode {
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
  invalidPin, 
  invalidCrossDeviceSession;
}

enum MQuickCodeExceptionCode {
  revoked,
  unsuccessfulAuthentication,
  pinCancelled,
  invalidPin,
  limitedQuickCodeGeneration,
  generationFail;
}

enum MAuthenticationSessionDetailsExceptionCode {
  invalidLink,
  invalidQRCode,
  invalidNotificationPayload,
  invalidAuthenticationSessionDetails,
  getAuthenticationSessionDetailsFail,
  abortSessionFail;
}

enum MSigningSessionDetailsExceptionCode {
  invalidLink,
  invalidQRCode,
  invalidSigningSessionDetails,
  getSigningSessionDetailsFail,
  invalidSigningSession,
  completeSigningSessionFail,
  abortSigningSessionFail;
}

enum MSigningExceptionCode {
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

@HostApi()
abstract class MiraclSdk {
  @async
  void initSdk(MConfiguration configuration);

  @async
  void updateProjectSettings(String projectId, String projectUrl);

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

@FlutterApi()
abstract class MLogger {
  void debug(String category, String message);
  void info(String category, String message);
  void warning(String category, String message);
  void error(String category, String message);
}