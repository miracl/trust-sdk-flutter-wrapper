import MIRACLTrust

extension Error {
    var errorDebugDescription: String {
        return String(describing: self).components(separatedBy: "(").first ?? String(describing: self)
    }
}

extension ConfigurationError {
    var flutterExceptionCodeRepresentation: ConfigurationExceptionCode {
        switch self {
        case .configurationEmptyProjectId:
            return ConfigurationExceptionCode.emptyProjectId
        }
    }
}

extension VerificationError {
    var flutterExceptionCodeRepresentation: EmailVerificationExceptionCode {
        switch self {
        case .emptyUserId:
            return EmailVerificationExceptionCode.emptyUserId
        case .invalidSessionDetails:
            return EmailVerificationExceptionCode.invalidSessionDetails
        case .requestBackoff:
            return EmailVerificationExceptionCode.requestBackoff
        case .verificaitonFail:
            return EmailVerificationExceptionCode.verificaitonFail
        }
    }
}

extension ActivationTokenError {
    var flutterExceptionCodeRepresentation: ActivationTokenExceptionCode {
        switch self {
        case .emptyUserId:
            return ActivationTokenExceptionCode.emptyUserId
        case .emptyVerificationCode:
            return ActivationTokenExceptionCode.emptyVerificationCode
        case .getActivationTokenFail:
            return ActivationTokenExceptionCode.getActivationTokenFail
        case .unsuccessfulVerification:
            return ActivationTokenExceptionCode.unsuccessfulVerification
        }
    }
}

extension RegistrationError {
    var flutterExceptionCodeRepresentation: RegistrationExceptionCode {
        switch self {
        case .emptyActivationToken:
            return RegistrationExceptionCode.emptyActivationToken
        case .emptyUserId:
            return RegistrationExceptionCode.emptyUserId
        case .invalidActivationToken:
            return RegistrationExceptionCode.invalidActivationToken
        case .invalidPin:
            return RegistrationExceptionCode.invalidPin
        case .pinCancelled:
            return RegistrationExceptionCode.pinCancelled
        case .projectMismatch:
            return RegistrationExceptionCode.projectMismatch
        case .registrationFail:
            return RegistrationExceptionCode.registrationFail
        case .unsupportedEllipticCurve:
            return RegistrationExceptionCode.unsupportedEllipticCurve
        }
    }
}

extension AuthenticationError {
    var flutterExceptionCodeRepresentation: AuthenticationExceptionCode {
        switch self {
        case .invalidUserData:
            return AuthenticationExceptionCode.invalidUserData
        case .invalidQRCode:
            return AuthenticationExceptionCode.invalidQRCode
        case .invalidPushNotificationPayload:
            return AuthenticationExceptionCode.invalidPushNotificationPayload
        case .userNotFound:
            return AuthenticationExceptionCode.userNotFound
        case .invalidUniversalLink:
            return AuthenticationExceptionCode.invalidLink
        case .authenticationFail:
            return AuthenticationExceptionCode.authenticationFail
        case .revoked:
            return AuthenticationExceptionCode.revoked
        case .invalidAuthenticationSession:
            return AuthenticationExceptionCode.invalidAuthenticationSession
        case .unsuccessfulAuthentication:
            return AuthenticationExceptionCode.unsuccessfulAuthentication
        case .pinCancelled:
            return AuthenticationExceptionCode.pinCancelled
        case .invalidPin:
            return AuthenticationExceptionCode.invalidPin
        }
    }
}

extension QuickCodeError {
    var flutterExceptionCodeRepresentation: QuickCodeExceptionCode {
        switch self {
        case .generationFail:
            return QuickCodeExceptionCode.generationFail
        case .invalidPin:
            return QuickCodeExceptionCode.invalidPin
        case .limitedQuickCodeGeneration:
            return QuickCodeExceptionCode.limitedQuickCodeGeneration
        case .pinCancelled:
            return QuickCodeExceptionCode.pinCancelled
        case .revoked:
            return QuickCodeExceptionCode.revoked
        case .unsuccessfulAuthentication:
            return QuickCodeExceptionCode.unsuccessfulAuthentication
        }
    }
}

extension AuthenticationSessionError {
    var flutterExceptionCodeRepresentation: AuthenticationSessionDetailsExceptionCode {
        switch self {
        case .abortSessionFail:
            return AuthenticationSessionDetailsExceptionCode.abortSessionFail
        case .getAuthenticationSessionDetailsFail:
            return AuthenticationSessionDetailsExceptionCode.getAuthenticationSessionDetailsFail
        case .invalidAuthenticationSessionDetails:
            return AuthenticationSessionDetailsExceptionCode.invalidAuthenticationSessionDetails
        case .invalidPushNotificationPayload:
            return AuthenticationSessionDetailsExceptionCode.invalidNotificationPayload
        case .invalidQRCode:
            return AuthenticationSessionDetailsExceptionCode.invalidQRCode
        case .invalidUniversalLinkURL:
            return AuthenticationSessionDetailsExceptionCode.invalidLink
        }
    }
}

extension SigningSessionError {
    var flutterExceptionCodeRepresentation: SigningSessionDetailsExceptionCode {
        switch self {
        case .abortSigningSessionFail:
            return SigningSessionDetailsExceptionCode.abortSigningSessionFail
        case .getSigningSessionDetailsFail:
            return SigningSessionDetailsExceptionCode.getSigningSessionDetailsFail
        case .invalidQRCode:
            return SigningSessionDetailsExceptionCode.invalidQRCode
        case .invalidSigningSession:
            return SigningSessionDetailsExceptionCode.invalidSigningSession
        case .invalidSigningSessionDetails:
            return SigningSessionDetailsExceptionCode.invalidSigningSessionDetails
        case .invalidUniversalLinkURL:
            return SigningSessionDetailsExceptionCode.invalidLink
        }
    }
}

extension SigningError {
    var flutterExceptionCodeRepresentation: SigningExceptionCode {
        switch self {
        case .emptyMessageHash:
            return SigningExceptionCode.emptyMessageHash
        case .emptyPublicKey:
            return SigningExceptionCode.emptyPublicKey
        case .invalidPin:
            return SigningExceptionCode.invalidPin
        case .invalidSigningSession:
            return SigningExceptionCode.invalidSigningSession
        case .invalidSigningSessionDetails:
            return SigningExceptionCode.invalidSigningSessionDetails
        case .invalidUserData:
            return SigningExceptionCode.invalidUserData
        case .pinCancelled:
            return SigningExceptionCode.pinCancelled
        case .revoked:
            return SigningExceptionCode.revoked
        case .signingFail:
            return SigningExceptionCode.signingFail
        case .unsuccessfulAuthentication:
            return SigningExceptionCode.unsuccessfulAuthentication
        }
    }
}
