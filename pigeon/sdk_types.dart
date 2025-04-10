import 'package:pigeon/pigeon.dart';

class MConfiguration {
  final String projectId;
  final String clientId;
  final String redirectUri;

  MConfiguration(this.projectId, this.clientId, this.redirectUri);
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

class MAuthenticationSessionDetails {
  final String userId;

  MAuthenticationSessionDetails(this.userId);
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
  bool sendVerificationEmail(String userId);

  @async
  MActivationTokenResponse getActivationToken(String uri);

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
  MAuthenticationSessionDetails getAuthenticationSessionDetailsFromQRCode(
    String qrCode,
  );

  @async
  void delete(String userId);

  @async
  MQuickCode generateQuickCode(String userId, String pin);

  @async
  MSigningResult sign(String userId, String pin, Uint8List message);

  @async
  bool authenticateWithQrCode(String userId, String pin, String qrCode);

  @async
  void authenticateWithNotificationPayload(
    Map<String, String> payload,
    String pin,
  );
}