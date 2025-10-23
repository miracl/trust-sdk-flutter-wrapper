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

extension on MConfigurationExceptionCode {
  ConfigurationExceptionCode toConfigurationExceptionCode() => switch (this) {
    MConfigurationExceptionCode.emptyProjectId => ConfigurationExceptionCode.emptyProjectId,
    MConfigurationExceptionCode.invalidProjectUrl => ConfigurationExceptionCode.invalidProjectUrl
  };
}


extension on MEmailVerificationExceptionCode {
  EmailVerificationExceptionCode toEmailVerificationExceptionCode() => switch(this) {
    MEmailVerificationExceptionCode.emptyUserId => EmailVerificationExceptionCode.emptyUserId,
    MEmailVerificationExceptionCode.invalidSessionDetails => EmailVerificationExceptionCode.invalidSessionDetails,
    MEmailVerificationExceptionCode.requestBackoff => EmailVerificationExceptionCode.requestBackoff,
    MEmailVerificationExceptionCode.verificaitonFail => EmailVerificationExceptionCode.verificaitonFail,
  };
}

extension on MActivationTokenExceptionCode {
  ActivationTokenExceptionCode toActivationTokenExceptionCode() => switch(this) {
    MActivationTokenExceptionCode.emptyUserId => ActivationTokenExceptionCode.emptyUserId,
    MActivationTokenExceptionCode.emptyVerificationCode => ActivationTokenExceptionCode.emptyVerificationCode,
    MActivationTokenExceptionCode.unsuccessfulVerification => ActivationTokenExceptionCode.unsuccessfulVerification,
    MActivationTokenExceptionCode.getActivationTokenFail => ActivationTokenExceptionCode.getActivationTokenFail,
  };
}

extension on MRegistrationExceptionCode {
  RegistrationExceptionCode toRegistrationExceptionCode() => switch (this) {
    MRegistrationExceptionCode.emptyUserId => RegistrationExceptionCode.emptyUserId,
    MRegistrationExceptionCode.emptyActivationToken => RegistrationExceptionCode.emptyActivationToken,
    MRegistrationExceptionCode.invalidActivationToken => RegistrationExceptionCode.invalidActivationToken,
    MRegistrationExceptionCode.registrationFail => RegistrationExceptionCode.registrationFail,
    MRegistrationExceptionCode.unsupportedEllipticCurve => RegistrationExceptionCode.unsupportedEllipticCurve,
    MRegistrationExceptionCode.pinCancelled => RegistrationExceptionCode.pinCancelled,
    MRegistrationExceptionCode.invalidPin => RegistrationExceptionCode.invalidPin,
    MRegistrationExceptionCode.projectMismatch => RegistrationExceptionCode.projectMismatch,
  };
}

extension on MAuthenticationExceptionCode {
  AuthenticationExceptionCode toAuthenticationExceptionCode() => switch (this) {
    MAuthenticationExceptionCode.invalidUserData => AuthenticationExceptionCode.invalidUserData,
    MAuthenticationExceptionCode.invalidQRCode => AuthenticationExceptionCode.invalidQRCode,
    MAuthenticationExceptionCode.invalidPushNotificationPayload => AuthenticationExceptionCode.invalidPushNotificationPayload,
    MAuthenticationExceptionCode.userNotFound => AuthenticationExceptionCode.userNotFound,
    MAuthenticationExceptionCode.invalidLink => AuthenticationExceptionCode.invalidLink,
    MAuthenticationExceptionCode.authenticationFail => AuthenticationExceptionCode.authenticationFail,
    MAuthenticationExceptionCode.revoked => AuthenticationExceptionCode.revoked,
    MAuthenticationExceptionCode.invalidAuthenticationSession => AuthenticationExceptionCode.invalidAuthenticationSession,
    MAuthenticationExceptionCode.unsuccessfulAuthentication => AuthenticationExceptionCode.unsuccessfulAuthentication,
    MAuthenticationExceptionCode.pinCancelled => AuthenticationExceptionCode.pinCancelled,
    MAuthenticationExceptionCode.invalidPin => AuthenticationExceptionCode.invalidPin,
    MAuthenticationExceptionCode.invalidCrossDeviceSession => AuthenticationExceptionCode.invalidCrossDeviceSession
  };
}

extension on MQuickCodeExceptionCode {
  QuickCodeExceptionCode toQuickCodeExceptionCode() => switch (this) {
    MQuickCodeExceptionCode.revoked => QuickCodeExceptionCode.revoked,
    MQuickCodeExceptionCode.unsuccessfulAuthentication => QuickCodeExceptionCode.unsuccessfulAuthentication,
    MQuickCodeExceptionCode.pinCancelled => QuickCodeExceptionCode.pinCancelled,
    MQuickCodeExceptionCode.invalidPin => QuickCodeExceptionCode.invalidPin,
    MQuickCodeExceptionCode.generationFail => QuickCodeExceptionCode.generationFail,
  };
}

extension on MAuthenticationSessionDetailsExceptionCode {
  AuthenticationSessionDetailsExceptionCode toAuthenticationSessionDetailsExceptionCode() => switch (this) {
    MAuthenticationSessionDetailsExceptionCode.invalidLink => AuthenticationSessionDetailsExceptionCode.invalidLink,
    MAuthenticationSessionDetailsExceptionCode.invalidQRCode => AuthenticationSessionDetailsExceptionCode.invalidQRCode,
    MAuthenticationSessionDetailsExceptionCode.invalidNotificationPayload => AuthenticationSessionDetailsExceptionCode.invalidNotificationPayload,
    MAuthenticationSessionDetailsExceptionCode.invalidAuthenticationSessionDetails => AuthenticationSessionDetailsExceptionCode.invalidAuthenticationSessionDetails,
    MAuthenticationSessionDetailsExceptionCode.getAuthenticationSessionDetailsFail => AuthenticationSessionDetailsExceptionCode.getAuthenticationSessionDetailsFail,
    MAuthenticationSessionDetailsExceptionCode.abortSessionFail => AuthenticationSessionDetailsExceptionCode.abortSessionFail,
  };
}

extension on MSigningSessionDetailsExceptionCode {
  SigningSessionDetailsExceptionCode toSigningSessionDetailsExceptionCode() => switch (this) {
    MSigningSessionDetailsExceptionCode.invalidLink => SigningSessionDetailsExceptionCode.invalidLink,
    MSigningSessionDetailsExceptionCode.invalidQRCode => SigningSessionDetailsExceptionCode.invalidQRCode,
    MSigningSessionDetailsExceptionCode.invalidSigningSessionDetails => SigningSessionDetailsExceptionCode.invalidSigningSessionDetails,
    MSigningSessionDetailsExceptionCode.getSigningSessionDetailsFail => SigningSessionDetailsExceptionCode.getSigningSessionDetailsFail,
    MSigningSessionDetailsExceptionCode.invalidSigningSession => SigningSessionDetailsExceptionCode.invalidSigningSession,
    MSigningSessionDetailsExceptionCode.completeSigningSessionFail => SigningSessionDetailsExceptionCode.completeSigningSessionFail,
    MSigningSessionDetailsExceptionCode.abortSigningSessionFail => SigningSessionDetailsExceptionCode.abortSigningSessionFail,
  };
}

extension on MSigningExceptionCode {
  SigningExceptionCode toSigningExceptionCode() => switch (this) {
    MSigningExceptionCode.emptyMessageHash => SigningExceptionCode.emptyMessageHash,
    MSigningExceptionCode.emptyPublicKey => SigningExceptionCode.emptyPublicKey,
    MSigningExceptionCode.invalidUserData => SigningExceptionCode.invalidUserData,
    MSigningExceptionCode.pinCancelled => SigningExceptionCode.pinCancelled,
    MSigningExceptionCode.invalidPin => SigningExceptionCode.invalidPin,
    MSigningExceptionCode.signingFail => SigningExceptionCode.signingFail,
    MSigningExceptionCode.revoked => SigningExceptionCode.revoked,
    MSigningExceptionCode.unsuccessfulAuthentication => SigningExceptionCode.unsuccessfulAuthentication,
    MSigningExceptionCode.invalidSigningSession => SigningExceptionCode.invalidSigningSession,
    MSigningExceptionCode.invalidSigningSessionDetails => SigningExceptionCode.invalidSigningSessionDetails,
  };
}
