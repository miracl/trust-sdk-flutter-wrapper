import 'package:pigeon/pigeon.dart';

class MConfiguration {
  final String projectId;

  MConfiguration(this.projectId);
}

class MExceptions {
  final String message;

  MExceptions(this.message);
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
  final String hashedMpinId;

  MUser(
    this.projectId,
    this.revoked,
    this.userId,
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

@HostApi()
abstract class MiraclSdk {
  @async
  void initSdk(MConfiguration configuration);

  @async
  void setProjectId(String projectId);

  @async
  bool sendVerificationEmail(String userId, MAuthenticationSessionDetails? authenticationSessionDetails);

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
  void delete(String userId);

  @async
  MUser? getUser(String userId);

  @async
  MQuickCode generateQuickCode(String userId, String pin);

  @async
  MSigningResult sign(String userId, String pin, Uint8List message);

  @async
  bool authenticateWithQrCode(String userId, String pin, String qrCode);

  @async
  bool authenticateWithLink(String userId, String pin, String link);

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