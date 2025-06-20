import MIRACLTrust

extension Error {
    var errorDebugDescription: String {
        return String(describing: self).components(separatedBy: "(").first ?? String(describing: self)
    }
}

extension ConfigurationError {
    var flutterExceptionCodeRepresentation: MConfigurationExceptionCode {
        switch self {
        case .configurationEmptyProjectId:
            return MConfigurationExceptionCode.emptyProjectId
        }
    }
}

extension VerificationError {
    var flutterExceptionCodeRepresentation: MEmailVerificationExceptionCode {
        switch self {
        case .emptyUserId:
            return MEmailVerificationExceptionCode.emptyUserId
        case .invalidSessionDetails:
            return MEmailVerificationExceptionCode.invalidSessionDetails
        case .requestBackoff:
            return MEmailVerificationExceptionCode.requestBackoff
        case .verificaitonFail:
            return MEmailVerificationExceptionCode.verificaitonFail
        }
    }
}

extension ActivationTokenError {
    var flutterExceptionCodeRepresentation: MActivationTokenExceptionCode {
        switch self {
        case .emptyUserId:
            return MActivationTokenExceptionCode.emptyUserId
        case .emptyVerificationCode:
            return MActivationTokenExceptionCode.emptyVerificationCode
        case .getActivationTokenFail:
            return MActivationTokenExceptionCode.getActivationTokenFail
        case .unsuccessfulVerification:
            return MActivationTokenExceptionCode.unsuccessfulVerification
        }
    }
}

extension RegistrationError {
    var flutterExceptionCodeRepresentation: MRegistrationExceptionCode {
        switch self {
        case .emptyActivationToken:
            return MRegistrationExceptionCode.emptyActivationToken
        case .emptyUserId:
            return MRegistrationExceptionCode.emptyUserId
        case .invalidActivationToken:
            return MRegistrationExceptionCode.invalidActivationToken
        case .invalidPin:
            return MRegistrationExceptionCode.invalidPin
        case .pinCancelled:
            return MRegistrationExceptionCode.pinCancelled
        case .projectMismatch:
            return MRegistrationExceptionCode.projectMismatch
        case .registrationFail:
            return MRegistrationExceptionCode.registrationFail
        case .unsupportedEllipticCurve:
            return MRegistrationExceptionCode.unsupportedEllipticCurve
        }
    }
}

extension AuthenticationError {
    var flutterExceptionCodeRepresentation: MAuthenticationExceptionCode {
        switch self {
        case .invalidUserData:
            return MAuthenticationExceptionCode.invalidUserData
        case .invalidQRCode:
            return MAuthenticationExceptionCode.invalidQRCode
        case .invalidPushNotificationPayload:
            return MAuthenticationExceptionCode.invalidPushNotificationPayload
        case .userNotFound:
            return MAuthenticationExceptionCode.userNotFound
        case .invalidUniversalLink:
            return MAuthenticationExceptionCode.invalidLink
        case .authenticationFail:
            return MAuthenticationExceptionCode.authenticationFail
        case .revoked:
            return MAuthenticationExceptionCode.revoked
        case .invalidAuthenticationSession:
            return MAuthenticationExceptionCode.invalidAuthenticationSession
        case .unsuccessfulAuthentication:
            return MAuthenticationExceptionCode.unsuccessfulAuthentication
        case .pinCancelled:
            return MAuthenticationExceptionCode.pinCancelled
        case .invalidPin:
            return MAuthenticationExceptionCode.invalidPin
        }
    }
}

extension QuickCodeError {
    var flutterExceptionCodeRepresentation: MQuickCodeExceptionCode {
        switch self {
        case .generationFail:
            return MQuickCodeExceptionCode.generationFail
        case .invalidPin:
            return MQuickCodeExceptionCode.invalidPin
        case .limitedQuickCodeGeneration:
            return MQuickCodeExceptionCode.limitedQuickCodeGeneration
        case .pinCancelled:
            return MQuickCodeExceptionCode.pinCancelled
        case .revoked:
            return MQuickCodeExceptionCode.revoked
        case .unsuccessfulAuthentication:
            return MQuickCodeExceptionCode.unsuccessfulAuthentication
        }
    }
}

extension AuthenticationSessionError {
    var flutterExceptionCodeRepresentation: MAuthenticationSessionDetailsExceptionCode {
        switch self {
        case .abortSessionFail:
            return MAuthenticationSessionDetailsExceptionCode.abortSessionFail
        case .getAuthenticationSessionDetailsFail:
            return MAuthenticationSessionDetailsExceptionCode.getAuthenticationSessionDetailsFail
        case .invalidAuthenticationSessionDetails:
            return MAuthenticationSessionDetailsExceptionCode.invalidAuthenticationSessionDetails
        case .invalidPushNotificationPayload:
            return MAuthenticationSessionDetailsExceptionCode.invalidNotificationPayload
        case .invalidQRCode:
            return MAuthenticationSessionDetailsExceptionCode.invalidQRCode
        case .invalidUniversalLinkURL:
            return MAuthenticationSessionDetailsExceptionCode.invalidLink
        }
    }
}

extension SigningSessionError {
    var flutterExceptionCodeRepresentation: MSigningSessionDetailsExceptionCode {
        switch self {
        case .abortSigningSessionFail:
            return MSigningSessionDetailsExceptionCode.abortSigningSessionFail
        case .getSigningSessionDetailsFail:
            return MSigningSessionDetailsExceptionCode.getSigningSessionDetailsFail
        case .invalidQRCode:
            return MSigningSessionDetailsExceptionCode.invalidQRCode
        case .invalidSigningSession:
            return MSigningSessionDetailsExceptionCode.invalidSigningSession
        case .invalidSigningSessionDetails:
            return MSigningSessionDetailsExceptionCode.invalidSigningSessionDetails
        case .invalidUniversalLinkURL:
            return MSigningSessionDetailsExceptionCode.invalidLink
        }
    }
}

extension SigningError {
    var flutterExceptionCodeRepresentation: MSigningExceptionCode {
        switch self {
        case .emptyMessageHash:
            return MSigningExceptionCode.emptyMessageHash
        case .emptyPublicKey:
            return MSigningExceptionCode.emptyPublicKey
        case .invalidPin:
            return MSigningExceptionCode.invalidPin
        case .invalidSigningSession:
            return MSigningExceptionCode.invalidSigningSession
        case .invalidSigningSessionDetails:
            return MSigningExceptionCode.invalidSigningSessionDetails
        case .invalidUserData:
            return MSigningExceptionCode.invalidUserData
        case .pinCancelled:
            return MSigningExceptionCode.pinCancelled
        case .revoked:
            return MSigningExceptionCode.revoked
        case .signingFail:
            return MSigningExceptionCode.signingFail
        case .unsuccessfulAuthentication:
            return MSigningExceptionCode.unsuccessfulAuthentication
        }
    }
}
