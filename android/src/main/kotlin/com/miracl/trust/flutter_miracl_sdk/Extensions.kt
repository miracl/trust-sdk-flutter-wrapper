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

internal val ConfigurationException.flutterExceptionCodeRepresentation: MConfigurationExceptionCode
    get() = when (this) {
        ConfigurationException.EmptyProjectId -> MConfigurationExceptionCode.EMPTY_PROJECT_ID
        ConfigurationException.InvalidProjectUrl -> MConfigurationExceptionCode.INVALID_PROJECT_URL
    }

internal val VerificationException.flutterExceptionCodeRepresentation: MEmailVerificationExceptionCode
    get() = when (this) {
        VerificationException.EmptyUserId -> MEmailVerificationExceptionCode.EMPTY_USER_ID
        VerificationException.InvalidSessionDetails -> MEmailVerificationExceptionCode.INVALID_SESSION_DETAILS
        is VerificationException.RequestBackoff -> MEmailVerificationExceptionCode.REQUEST_BACKOFF
        is VerificationException.VerificationFail -> MEmailVerificationExceptionCode.VERIFICAITON_FAIL
    }

internal val ActivationTokenException.flutterExceptionCodeRepresentation: MActivationTokenExceptionCode
    get() = when (this) {
        ActivationTokenException.EmptyUserId -> MActivationTokenExceptionCode.EMPTY_USER_ID
        ActivationTokenException.EmptyVerificationCode -> MActivationTokenExceptionCode.EMPTY_VERIFICATION_CODE
        is ActivationTokenException.GetActivationTokenFail -> MActivationTokenExceptionCode.GET_ACTIVATION_TOKEN_FAIL
        is ActivationTokenException.UnsuccessfulVerification -> MActivationTokenExceptionCode.UNSUCCESSFUL_VERIFICATION
    }

internal val RegistrationException.flutterExceptionCodeRepresentation: MRegistrationExceptionCode
    get() = when (this) {
        RegistrationException.EmptyActivationToken -> MRegistrationExceptionCode.EMPTY_ACTIVATION_TOKEN
        RegistrationException.EmptyUserId -> MRegistrationExceptionCode.EMPTY_USER_ID
        RegistrationException.InvalidActivationToken -> MRegistrationExceptionCode.INVALID_ACTIVATION_TOKEN
        RegistrationException.InvalidPin -> MRegistrationExceptionCode.INVALID_PIN
        RegistrationException.PinCancelled -> MRegistrationExceptionCode.PIN_CANCELLED
        RegistrationException.ProjectMismatch -> MRegistrationExceptionCode.PROJECT_MISMATCH
        is RegistrationException.RegistrationFail -> MRegistrationExceptionCode.REGISTRATION_FAIL
        RegistrationException.UnsupportedEllipticCurve -> MRegistrationExceptionCode.UNSUPPORTED_ELLIPTIC_CURVE
    }

internal val AuthenticationException.flutterExceptionCodeRepresentation: MAuthenticationExceptionCode
    get() = when (this) {
        is AuthenticationException.AuthenticationFail -> MAuthenticationExceptionCode.AUTHENTICATION_FAIL
        AuthenticationException.InvalidAppLink -> MAuthenticationExceptionCode.INVALID_LINK
        AuthenticationException.InvalidAuthenticationSession -> MAuthenticationExceptionCode.INVALID_AUTHENTICATION_SESSION
        AuthenticationException.InvalidPin -> MAuthenticationExceptionCode.INVALID_PIN
        AuthenticationException.InvalidPushNotificationPayload -> MAuthenticationExceptionCode.INVALID_PUSH_NOTIFICATION_PAYLOAD
        AuthenticationException.InvalidQRCode -> MAuthenticationExceptionCode.INVALID_QRCODE
        AuthenticationException.InvalidUserData -> MAuthenticationExceptionCode.INVALID_USER_DATA
        AuthenticationException.PinCancelled -> MAuthenticationExceptionCode.PIN_CANCELLED
        AuthenticationException.Revoked -> MAuthenticationExceptionCode.REVOKED
        AuthenticationException.UnsuccessfulAuthentication -> MAuthenticationExceptionCode.UNSUCCESSFUL_AUTHENTICATION
        AuthenticationException.UserNotFound -> MAuthenticationExceptionCode.USER_NOT_FOUND
        AuthenticationException.InvalidCrossDeviceSession -> MAuthenticationExceptionCode.INVALID_CROSS_DEVICE_SESSION
    }

internal val QuickCodeException.flutterExceptionCodeRepresentation: MQuickCodeExceptionCode
    get() = when (this) {
        is QuickCodeException.GenerationFail -> MQuickCodeExceptionCode.GENERATION_FAIL
        QuickCodeException.InvalidPin -> MQuickCodeExceptionCode.INVALID_PIN
        QuickCodeException.PinCancelled -> MQuickCodeExceptionCode.PIN_CANCELLED
        QuickCodeException.Revoked -> MQuickCodeExceptionCode.REVOKED
        QuickCodeException.UnsuccessfulAuthentication -> MQuickCodeExceptionCode.UNSUCCESSFUL_AUTHENTICATION
    }

internal val AuthenticationSessionException.flutterExceptionCodeRepresentation: MAuthenticationSessionDetailsExceptionCode
    get() = when (this) {
        is AuthenticationSessionException.AbortSessionFail -> MAuthenticationSessionDetailsExceptionCode.ABORT_SESSION_FAIL
        is AuthenticationSessionException.GetAuthenticationSessionDetailsFail -> MAuthenticationSessionDetailsExceptionCode.GET_AUTHENTICATION_SESSION_DETAILS_FAIL
        AuthenticationSessionException.InvalidAppLink -> MAuthenticationSessionDetailsExceptionCode.INVALID_LINK
        AuthenticationSessionException.InvalidNotificationPayload -> MAuthenticationSessionDetailsExceptionCode.INVALID_NOTIFICATION_PAYLOAD
        AuthenticationSessionException.InvalidQRCode -> MAuthenticationSessionDetailsExceptionCode.INVALID_QRCODE
        AuthenticationSessionException.InvalidSessionDetails -> MAuthenticationSessionDetailsExceptionCode.INVALID_AUTHENTICATION_SESSION_DETAILS
    }

internal val SigningSessionException.flutterExceptionCodeRepresentation: MSigningSessionDetailsExceptionCode
    get() = when (this) {
        is SigningSessionException.AbortSigningSessionFail -> MSigningSessionDetailsExceptionCode.ABORT_SIGNING_SESSION_FAIL
        is SigningSessionException.CompleteSigningSessionFail -> MSigningSessionDetailsExceptionCode.COMPLETE_SIGNING_SESSION_FAIL
        is SigningSessionException.GetSigningSessionDetailsFail -> MSigningSessionDetailsExceptionCode.GET_SIGNING_SESSION_DETAILS_FAIL
        SigningSessionException.InvalidAppLink -> MSigningSessionDetailsExceptionCode.INVALID_LINK
        SigningSessionException.InvalidQRCode -> MSigningSessionDetailsExceptionCode.INVALID_QRCODE
        SigningSessionException.InvalidSigningSession -> MSigningSessionDetailsExceptionCode.INVALID_SIGNING_SESSION
        SigningSessionException.InvalidSigningSessionDetails -> MSigningSessionDetailsExceptionCode.INVALID_SIGNING_SESSION_DETAILS
    }

internal val SigningException.flutterExceptionCodeRepresentation: MSigningExceptionCode
    get() = when (this) {
        SigningException.EmptyMessageHash -> MSigningExceptionCode.EMPTY_MESSAGE_HASH
        SigningException.EmptyPublicKey -> MSigningExceptionCode.EMPTY_PUBLIC_KEY
        SigningException.InvalidPin -> MSigningExceptionCode.INVALID_PIN
        SigningException.InvalidSigningSession -> MSigningExceptionCode.INVALID_SIGNING_SESSION
        SigningException.InvalidSigningSessionDetails -> MSigningExceptionCode.INVALID_SIGNING_SESSION_DETAILS
        SigningException.InvalidUserData -> MSigningExceptionCode.INVALID_USER_DATA
        SigningException.PinCancelled -> MSigningExceptionCode.PIN_CANCELLED
        SigningException.Revoked -> MSigningExceptionCode.REVOKED
        is SigningException.SigningFail -> MSigningExceptionCode.SIGNING_FAIL
        SigningException.UnsuccessfulAuthentication -> MSigningExceptionCode.UNSUCCESSFUL_AUTHENTICATION
    }