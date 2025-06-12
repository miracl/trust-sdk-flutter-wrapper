package com.miracl.trust.flutter_miracl_sdk

import com.miracl.trust.authentication.AuthenticationException
import com.miracl.trust.configuration.ConfigurationException
import com.miracl.trust.registration.ActivationTokenException
import com.miracl.trust.registration.VerificationException
import com.miracl.trust.registration.QuickCodeException
import com.miracl.trust.registration.RegistrationException
import com.miracl.trust.session.AuthenticationSessionException
import com.miracl.trust.session.SigningSessionException
import com.miracl.trust.signing.SigningException

internal val ConfigurationException.flutterExceptionCodeRepresentation: ConfigurationExceptionCode
    get() = when (this) {
        ConfigurationException.EmptyProjectId -> ConfigurationExceptionCode.EMPTY_PROJECT_ID
    }

internal val VerificationException.flutterExceptionCodeRepresentation: EmailVerificationExceptionCode
    get() = when (this) {
        VerificationException.EmptyUserId -> EmailVerificationExceptionCode.EMPTY_USER_ID
        VerificationException.InvalidSessionDetails -> EmailVerificationExceptionCode.INVALID_SESSION_DETAILS
        is VerificationException.RequestBackoff -> EmailVerificationExceptionCode.REQUEST_BACKOFF
        is VerificationException.VerificationFail -> EmailVerificationExceptionCode.VERIFICAITON_FAIL
    }

internal val ActivationTokenException.flutterExceptionCodeRepresentation: ActivationTokenExceptionCode
    get() = when (this) {
        ActivationTokenException.EmptyUserId -> ActivationTokenExceptionCode.EMPTY_USER_ID
        ActivationTokenException.EmptyVerificationCode -> ActivationTokenExceptionCode.EMPTY_VERIFICATION_CODE
        is ActivationTokenException.GetActivationTokenFail -> ActivationTokenExceptionCode.GET_ACTIVATION_TOKEN_FAIL
        is ActivationTokenException.UnsuccessfulVerification -> ActivationTokenExceptionCode.UNSUCCESSFUL_VERIFICATION
    }

internal val RegistrationException.flutterExceptionCodeRepresentation: RegistrationExceptionCode
    get() = when (this) {
        RegistrationException.EmptyActivationToken -> RegistrationExceptionCode.EMPTY_ACTIVATION_TOKEN
        RegistrationException.EmptyUserId -> RegistrationExceptionCode.EMPTY_USER_ID
        RegistrationException.InvalidActivationToken -> RegistrationExceptionCode.INVALID_ACTIVATION_TOKEN
        RegistrationException.InvalidPin -> RegistrationExceptionCode.INVALID_PIN
        RegistrationException.PinCancelled -> RegistrationExceptionCode.PIN_CANCELLED
        RegistrationException.ProjectMismatch -> RegistrationExceptionCode.PROJECT_MISMATCH
        is RegistrationException.RegistrationFail -> RegistrationExceptionCode.REGISTRATION_FAIL
        RegistrationException.UnsupportedEllipticCurve -> RegistrationExceptionCode.UNSUPPORTED_ELLIPTIC_CURVE
    }

internal val AuthenticationException.flutterExceptionCodeRepresentation: AuthenticationExceptionCode
    get() = when (this) {
        is AuthenticationException.AuthenticationFail -> AuthenticationExceptionCode.AUTHENTICATION_FAIL
        AuthenticationException.InvalidAppLink -> AuthenticationExceptionCode.INVALID_LINK
        AuthenticationException.InvalidAuthenticationSession -> AuthenticationExceptionCode.INVALID_AUTHENTICATION_SESSION
        AuthenticationException.InvalidPin -> AuthenticationExceptionCode.INVALID_PIN
        AuthenticationException.InvalidPushNotificationPayload -> AuthenticationExceptionCode.INVALID_PUSH_NOTIFICATION_PAYLOAD
        AuthenticationException.InvalidQRCode -> AuthenticationExceptionCode.INVALID_QRCODE
        AuthenticationException.InvalidUserData -> AuthenticationExceptionCode.INVALID_USER_DATA
        AuthenticationException.PinCancelled -> AuthenticationExceptionCode.PIN_CANCELLED
        AuthenticationException.Revoked -> AuthenticationExceptionCode.REVOKED
        AuthenticationException.UnsuccessfulAuthentication -> AuthenticationExceptionCode.UNSUCCESSFUL_AUTHENTICATION
        AuthenticationException.UserNotFound -> AuthenticationExceptionCode.USER_NOT_FOUND
    }

internal val QuickCodeException.flutterExceptionCodeRepresentation: QuickCodeExceptionCode
    get() = when (this) {
        is QuickCodeException.GenerationFail -> QuickCodeExceptionCode.GENERATION_FAIL
        QuickCodeException.InvalidPin -> QuickCodeExceptionCode.INVALID_PIN
        QuickCodeException.LimitedQuickCodeGeneration -> QuickCodeExceptionCode.LIMITED_QUICK_CODE_GENERATION
        QuickCodeException.PinCancelled -> QuickCodeExceptionCode.PIN_CANCELLED
        QuickCodeException.Revoked -> QuickCodeExceptionCode.REVOKED
        QuickCodeException.UnsuccessfulAuthentication -> QuickCodeExceptionCode.UNSUCCESSFUL_AUTHENTICATION
    }

internal val AuthenticationSessionException.flutterExceptionCodeRepresentation: AuthenticationSessionDetailsExceptionCode
    get() = when (this) {
        is AuthenticationSessionException.AbortSessionFail -> AuthenticationSessionDetailsExceptionCode.ABORT_SESSION_FAIL
        is AuthenticationSessionException.GetAuthenticationSessionDetailsFail -> AuthenticationSessionDetailsExceptionCode.GET_AUTHENTICATION_SESSION_DETAILS_FAIL
        AuthenticationSessionException.InvalidAppLink -> AuthenticationSessionDetailsExceptionCode.INVALID_LINK
        AuthenticationSessionException.InvalidNotificationPayload -> AuthenticationSessionDetailsExceptionCode.INVALID_NOTIFICATION_PAYLOAD
        AuthenticationSessionException.InvalidQRCode -> AuthenticationSessionDetailsExceptionCode.INVALID_QRCODE
        AuthenticationSessionException.InvalidSessionDetails -> AuthenticationSessionDetailsExceptionCode.INVALID_AUTHENTICATION_SESSION_DETAILS
    }

internal val SigningSessionException.flutterExceptionCodeRepresentation: SigningSessionDetailsExceptionCode
    get() = when (this) {
        is SigningSessionException.AbortSigningSessionFail -> SigningSessionDetailsExceptionCode.ABORT_SIGNING_SESSION_FAIL
        is SigningSessionException.CompleteSigningSessionFail -> SigningSessionDetailsExceptionCode.COMPLETE_SIGNING_SESSION_FAIL
        is SigningSessionException.GetSigningSessionDetailsFail -> SigningSessionDetailsExceptionCode.GET_SIGNING_SESSION_DETAILS_FAIL
        SigningSessionException.InvalidAppLink -> SigningSessionDetailsExceptionCode.INVALID_LINK
        SigningSessionException.InvalidQRCode -> SigningSessionDetailsExceptionCode.INVALID_QRCODE
        SigningSessionException.InvalidSigningSession -> SigningSessionDetailsExceptionCode.INVALID_SIGNING_SESSION
        SigningSessionException.InvalidSigningSessionDetails -> SigningSessionDetailsExceptionCode.INVALID_SIGNING_SESSION_DETAILS
    }

internal val SigningException.flutterExceptionCodeRepresentation: SigningExceptionCode
    get() = when (this) {
        SigningException.EmptyMessageHash -> SigningExceptionCode.EMPTY_MESSAGE_HASH
        SigningException.EmptyPublicKey -> SigningExceptionCode.EMPTY_PUBLIC_KEY
        SigningException.InvalidPin -> SigningExceptionCode.INVALID_PIN
        SigningException.InvalidSigningSession -> SigningExceptionCode.INVALID_SIGNING_SESSION
        SigningException.InvalidSigningSessionDetails -> SigningExceptionCode.INVALID_SIGNING_SESSION_DETAILS
        SigningException.InvalidUserData -> SigningExceptionCode.INVALID_USER_DATA
        SigningException.PinCancelled -> SigningExceptionCode.PIN_CANCELLED
        SigningException.Revoked -> SigningExceptionCode.REVOKED
        is SigningException.SigningFail -> SigningExceptionCode.SIGNING_FAIL
        SigningException.UnsuccessfulAuthentication -> SigningExceptionCode.UNSUCCESSFUL_AUTHENTICATION
    }