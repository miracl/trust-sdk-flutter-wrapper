part of 'miracl_trust.dart';

extension on PlatformException {
  Object? _getExceptionCode() {
    if (details is Map<Object?, Object?>) {
        return details["exceptionCode"];
    }

    return null;
  }
}

extension on MAuthenticationSessionDetails {
  AuthenticationSessionDetails _toAuthenticationSessionDetails() {
    return AuthenticationSessionDetails._create(
        userId: userId, 
        projectName: projectName, 
        projectLogoURL: projectLogoURL, 
        projectId: projectId, 
        pinLength: pinLength,
        verificationMethod: VerificationMethod.getVerificationMethod(verificationMethod.name), 
        verificationURL: verificationURL,
        verificationCustomText: verificationCustomText, 
        identityTypeLabel: identityTypeLabel, 
        quickCodeEnabled: quickCodeEnabled,
        limitQuickCodeRegistration: limitQuickCodeRegistration, 
        identityType: IdentityType.getIdentityType(identityType.name),
        accessId: accessId
    );
  }
}

extension on MEmailVerificationResponse {
  EmailVerificationResponse _toEmailVerificationResponse(){
    final emailVerificationMethodPublic = EmailVerificationMethod.getEmailVerificationMethod(
      emailVerificationMethod.name
    );

    return  EmailVerificationResponse._create(
      backoff: backoff, 
      emailVerificationMethod: emailVerificationMethodPublic
    );
  }
}

extension on MActivationTokenResponse {
  ActivationTokenResponse _toActivationTokenResponse(){
    return ActivationTokenResponse._create(
        projectId: projectId, 
        accessId: accessId,
        userId: userId, 
        activationToken: activationToken
    );
  }
}

extension on MActivationTokenErrorResponse {
  ActivationTokenErrorResponse _toActivationTokeErrorResponse(){
    return ActivationTokenErrorResponse._create(
      projectId: projectId,
      accessId: accessId,
      userId: userId
    );
  }
}

extension on MUser {
  User _toUser(){
    return User._create(
        userId: userId,
        projectId: projectId,
        revoked: revoked,
        pinLength: pinLength,
        hashedMpinId: hashedMpinId
    );
  }
}

extension on User {
  MUser _toMUser(){
    return MUser(
      projectId: projectId,
      revoked: revoked,
      userId: userId,
      pinLength: pinLength,
      hashedMpinId: hashedMpinId
    );
  }
}

extension on MQuickCode {
  QuickCode _toQuickCode(){
    return QuickCode._create(
      code: code,
      expiryTime: expiryTime,
      ttlSeconds: ttlSeconds
    );
  }
}

extension on MSigningSessionDetails {
  SigningSessionDetails _toSigningSessionDetails() {
    return SigningSessionDetails._create(
        userId: userId,
        projectName: projectName,
        projectLogoURL: projectLogoURL,
        projectId: projectId, 
        pinLength: pinLength, 
        verificationMethod: VerificationMethod.getVerificationMethod(verificationMethod.name),
        verificationURL: verificationURL,
        verificationCustomText: verificationCustomText,
        identityTypeLabel: identityTypeLabel, 
        quickCodeEnabled: quickCodeEnabled, 
        limitQuickCodeRegistration: limitQuickCodeRegistration, 
        identityType: IdentityType.getIdentityType(identityType.name), 
        sessionId: sessionId, 
        signingHash: signingHash, 
        signingDescription: signingDescription, 
        status: SigningSessionStatus.getSigningSessionStatus(status.name),
        expireTime: expireTime
      );
  }
}

extension on MSigningResult {
  SigningResult _toSigningResult() {
    final signatureForReturn = Signature._create(
      u: signature.u, 
      v: signature.v, 
      dtas: signature.dtas, 
      mpinId: signature.mpinId, 
      hash: signature.hash, 
      publicKey: signature.publicKey
    );

    final signingResult = SigningResult._create(
      signature: signatureForReturn,
      timestamp: timestamp
    );

    return signingResult;
  }
}