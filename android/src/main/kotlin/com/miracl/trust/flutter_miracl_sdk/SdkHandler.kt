package com.miracl.trust.flutter_miracl_sdk

import android.content.Context
import android.net.Uri
import com.miracl.trust.MIRACLError
import com.miracl.trust.MIRACLSuccess
import com.miracl.trust.MIRACLTrust
import com.miracl.trust.configuration.Configuration
import com.miracl.trust.model.User
import com.miracl.trust.util.log.Logger
import com.miracl.trust.registration.ActivationTokenErrorResponse
import com.miracl.trust.registration.ActivationTokenException
import com.miracl.trust.registration.VerificationException
import com.miracl.trust.signing.SigningException
import com.miracl.trust.session.SigningSessionException
import com.miracl.trust.authentication.AuthenticationException
import com.miracl.trust.registration.QuickCodeException
import com.miracl.trust.session.AuthenticationSessionException
import com.miracl.trust.registration.RegistrationException
import com.miracl.trust.configuration.ConfigurationException
import com.miracl.trust.flutter_miracl_sdk.FlutterLogger
import com.miracl.trust.flutter_miracl_sdk.MLogger

import java.util.*

class SdkHandler {
    fun initSdk(
        config: MConfiguration,
        mLogger: MLogger, 
        context: Context, 
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            val configurationBuilder = if (config.projectUrl!= null) {
                Configuration.Builder(config.projectId, config.projectUrl)
            } else {
                Configuration.Builder(config.projectId)
            }

            configurationBuilder
                .applicationInfo(config.applicationInfo)
                .logger(FlutterLogger(mLogger))
            
            val configuration = configurationBuilder.build()
    
            MIRACLTrust.configure(context, configuration)
            callback(Result.success(Unit))
        } catch (exception: ConfigurationException) {
            val details = mutableMapOf<String, Any?>()
            details["exceptionCode"] = exception.flutterExceptionCodeRepresentation

            callback(
                Result.failure(
                    mapExceptionToFlutter(exception, details)
                )
            )
        }      
    }

    fun setProjectId(
        projectId: String,
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            MIRACLTrust.getInstance().setProjectId(projectId)
            callback(Result.success(Unit))
        } catch (exception: ConfigurationException) {
            val details = mutableMapOf<String, Any?>()
            details["exceptionCode"] = exception.flutterExceptionCodeRepresentation

            callback(
                Result.failure(
                    mapExceptionToFlutter(exception, details)
                )
            )
        }        
    }

    fun updateProjectSettings(
        projectId: String, 
        projectUrl: String, 
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            MIRACLTrust.getInstance().updateProjectSettings(projectId, projectUrl)
            callback(Result.success(Unit))
        } catch (exception: ConfigurationException) {
            val details = mutableMapOf<String, Any?>()
            details["exceptionCode"] = exception.flutterExceptionCodeRepresentation

            callback(
                Result.failure(
                    mapExceptionToFlutter(exception, details)
                )
            )
        }        
    }

    fun sendVerificationMail(
        userId: String, callback: (Result<MEmailVerificationResponse>) -> Unit
    ) {
        MIRACLTrust.getInstance().sendVerificationEmail(userId) {
            if (it is MIRACLSuccess) {
                val response = it.value
                val mEmailVerificationResponse = MEmailVerificationResponse(
                    response.backoff,
                    MEmailVerificationMethod.ofRaw(response.method.ordinal) ?: MEmailVerificationMethod.LINK,
                )
                callback(Result.success(mEmailVerificationResponse))
            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()
                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation

                    if (error is VerificationException.RequestBackoff) {
                        details["backoff"] = error.backoff
                    }

                    if (error is VerificationException.VerificationFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        }
    }

    fun getActivationToken(
        verificationUri: String, callback: (Result<MActivationTokenResponse>) -> Unit
    ) {
        MIRACLTrust.getInstance().getActivationToken(Uri.parse(verificationUri)) {
            if (it is MIRACLSuccess) {
                callback(
                    Result.success(
                        MActivationTokenResponse(
                            it.value.projectId,
                            it.value.accessId,
                            it.value.userId,
                            it.value.activationToken,
                        ),
                    ),
                )

            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()

                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                    if (error is ActivationTokenException.UnsuccessfulVerification) {
                        val activationTokenErrorResponse = error.activationTokenErrorResponse
                        if (activationTokenErrorResponse != null) {
                            val mActivationTokenErrorResponse = MActivationTokenErrorResponse(
                                activationTokenErrorResponse.projectId,
                                activationTokenErrorResponse.accessId,
                                activationTokenErrorResponse.userId
                            )
                            details["activationTokenErrorResponse"] = mActivationTokenErrorResponse
                        }
                    }

                    if (error is ActivationTokenException.GetActivationTokenFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        }
    }

    fun getActivationToken(
        userId: String,
        code: String,
        callback: (Result<MActivationTokenResponse>) -> Unit
    ) {
        MIRACLTrust.getInstance().getActivationToken(userId = userId, code = code) {
            if (it is MIRACLSuccess) {
                callback(
                    Result.success(
                        MActivationTokenResponse(
                            it.value.projectId,
                            it.value.accessId,
                            it.value.userId,
                            it.value.activationToken,
                        ),
                    ),
                )

            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()
                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation

                    if (error is ActivationTokenException.UnsuccessfulVerification) {
                        val activationTokenErrorResponse = error.activationTokenErrorResponse
                        if (activationTokenErrorResponse != null) {
                            val mActivationTokenErrorResponse = MActivationTokenErrorResponse(
                                activationTokenErrorResponse.projectId,
                                activationTokenErrorResponse.accessId,
                                activationTokenErrorResponse.userId
                            )
                            details["activationTokenErrorResponse"] = mActivationTokenErrorResponse
                        }
                    }

                    if (error is ActivationTokenException.GetActivationTokenFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        }
    }

    fun register(
        userId: String,
        activationToken: String,
        pin: String,
        pushToken: String?,
        callback: (Result<MUser>) -> Unit
    ) {
        MIRACLTrust.getInstance().register(userId, activationToken, pinProvider = {
            it.consume(pin)
        }, pushToken, {
            if (it is MIRACLSuccess) {
                callback(Result.success(userToMUser(it.value)))
            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()
                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation

                    if (error is RegistrationException.RegistrationFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        });
    }

    fun authenticate(user: MUser, pin: String, callback: (Result<String>) -> Unit) {
        MIRACLTrust.getInstance().getUser(user.userId) { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUser
            }

            val user = (result as MIRACLSuccess).value!!
            
            MIRACLTrust.getInstance().authenticate(user, {
                it.consume(pin)
            }, {
                if (it is MIRACLSuccess) {
                    callback(Result.success(it.value))
                } else {
                    if (it is MIRACLError) {
                        val error = it.value
                        val details = mutableMapOf<String, Any?>()

                        details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                        if (error is AuthenticationException.AuthenticationFail && error.cause != null) {
                            details["error"] = error.cause.toString()
                        }

                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value, details)
                            )
                        )
                    }
                }
            });
        }
    }

    fun generateQuickCode(
        userId: String,
        pin: String,
        callback: (Result<MQuickCode>) -> Unit
    ) {
        MIRACLTrust.getInstance().getUser(userId) { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUser
            }

            val user = (result as MIRACLSuccess).value
            user?.let { currentUser ->
                MIRACLTrust.getInstance().generateQuickCode(currentUser, { it.consume(pin); }) {
                    if (it is MIRACLSuccess) {
                        callback(
                            Result.success(
                                MQuickCode(
                                    it.value.code,
                                    it.value.expireTime,
                                    it.value.ttlSeconds.toLong(),
                                )
                            )
                        )
                    } else if (it is MIRACLError) {
                        val error = it.value
                        val details = mutableMapOf<String, Any?>()

                        details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                        if (error is QuickCodeException.GenerationFail && error.cause != null) {
                            details["error"] = error.cause.toString()
                        }

                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value, details)
                            )
                        )
                    }
                }
            }
        }
    }

    fun getAuthenticationSessionDetailsFromLink(
        link: String, 
        callback: (Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromAppLink(Uri.parse(link)) {
            if (it is MIRACLSuccess) {
                callback(
                    Result.success(
                        MAuthenticationSessionDetails(
                            it.value.userId,
                            it.value.projectName,
                            it.value.projectLogoUrl,
                            it.value.projectId,
                            it.value.pinLength.toLong(),
                            MVerificationMethod.ofRaw(it.value.verificationMethod.ordinal) ?: MVerificationMethod.STANDARD_EMAIL,
                            it.value.verificationUrl,
                            it.value.verificationCustomText,
                            it.value.identityTypeLabel,
                            it.value.quickCodeEnabled,
                            it.value.limitQuickCodeRegistration,
                            MIdentityType.ofRaw(it.value.identityType.ordinal) ?: MIdentityType.EMAIL,
                            it.value.accessId
                        )
                    )
                )
            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()

                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                    if (error is AuthenticationSessionException.GetAuthenticationSessionDetailsFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }
    
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        }
    }

    fun getAuthenticationSessionDetailsFromPayload(
        payload: Map<String, String>, 
        callback: (Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromNotificationPayload(payload) {
            if (it is MIRACLSuccess) {
                callback(
                    Result.success(
                        MAuthenticationSessionDetails(
                            it.value.userId,
                            it.value.projectName,
                            it.value.projectLogoUrl,
                            it.value.projectId,
                            it.value.pinLength.toLong(),
                            MVerificationMethod.ofRaw(it.value.verificationMethod.ordinal) ?: MVerificationMethod.STANDARD_EMAIL,
                            it.value.verificationUrl,
                            it.value.verificationCustomText,
                            it.value.identityTypeLabel,
                            it.value.quickCodeEnabled,
                            it.value.limitQuickCodeRegistration,
                            MIdentityType.ofRaw(it.value.identityType.ordinal) ?: MIdentityType.EMAIL,
                            it.value.accessId
                        )
                    )
                )
            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()

                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                    if (error is AuthenticationSessionException.GetAuthenticationSessionDetailsFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        }
    }

    fun getAuthenticationSessionDetailsFromQRCode(
        qrCode: String, 
        callback: (Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromQRCode(qrCode) {
            if (it is MIRACLSuccess) {
                callback(
                    Result.success(
                        MAuthenticationSessionDetails(
                            it.value.userId,
                            it.value.projectName,
                            it.value.projectLogoUrl,
                            it.value.projectId,
                            it.value.pinLength.toLong(),
                            MVerificationMethod.ofRaw(it.value.verificationMethod.ordinal) ?: MVerificationMethod.STANDARD_EMAIL,
                            it.value.verificationUrl,
                            it.value.verificationCustomText,
                            it.value.identityTypeLabel,
                            it.value.quickCodeEnabled,
                            it.value.limitQuickCodeRegistration,
                            MIdentityType.ofRaw(it.value.identityType.ordinal) ?: MIdentityType.EMAIL,
                            it.value.accessId
                        )
                    )
                )
            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()

                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                    if (error is AuthenticationSessionException.GetAuthenticationSessionDetailsFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        }
    }

    fun authenticateWithQrCode(
        userId: String,
        qrCode: String,
        pin: String,
        callback: (Result<Boolean>) -> Unit
    ) {
        MIRACLTrust.getInstance().getUser(userId) { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUser
            }

            val user = (result as MIRACLSuccess).value
            user?.let {
                MIRACLTrust.getInstance().authenticateWithQRCode(user, qrCode, {
                    it.consume(pin)
                }) {
                    if (it is MIRACLSuccess) {
                        callback(Result.success(true));
                    } else if (it is MIRACLError) {
                        val error = it.value
                        val details = mutableMapOf<String, Any?>()

                        details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                        if (error is AuthenticationException.AuthenticationFail && error.cause != null) {
                            details["error"] = error.cause.toString()
                        }

                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value, details)
                            )
                        )
                    }
                }
            }
        }
    }

    fun authenticateWithAppLink(
        userId: String,
        link: String,
        pin: String,
        callback: (Result<Boolean>) -> Unit
    ) {
        MIRACLTrust.getInstance().getUser(userId) { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUser
            }

            val user = (result as MIRACLSuccess).value
            user?.let {
                MIRACLTrust.getInstance().authenticateWithAppLink(user, Uri.parse(link), {
                    it.consume(pin)
                }) {
                    if (it is MIRACLSuccess) {
                        callback(Result.success(true));
                    } else if (it is MIRACLError) {
                        val error = it.value
                        val details = mutableMapOf<String, Any?>()

                        details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                        if (error is AuthenticationException.AuthenticationFail && error.cause != null) {
                            details["error"] = error.cause.toString()
                        }

                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value, details)
                            )
                        )
                    }
                }
            }
        }
    }

    fun authenticateWithPayload(
        payload: Map<String, String>,
        pin: String,
        callback: (Result<Boolean>) -> Unit
    ) {
        MIRACLTrust.getInstance().authenticateWithNotificationPayload(payload, {
            it.consume(pin)
        }) {
            if (it is MIRACLSuccess) {
                callback(Result.success(true));
            } else if (it is MIRACLError) {
                val error = it.value
                val details = mutableMapOf<String, Any?>()

                details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                if (error is AuthenticationException.AuthenticationFail && error.cause != null) {
                    details["error"] = error.cause.toString()
                }

                callback(
                    Result.failure(
                        mapExceptionToFlutter(it.value, details)
                    )
                )
            }
        }
    }

    fun getSigningSessionDetailsFromQRCode(
        qrCode: String,
        callback: (Result<MSigningSessionDetails>) -> Unit
    ) {
        MIRACLTrust.getInstance().getSigningSessionDetailsFromQRCode(qrCode) {
            if (it is MIRACLSuccess) {
                callback(
                    Result.success(
                        MSigningSessionDetails(
                            it.value.userId,
                            it.value.projectName,
                            it.value.projectLogoUrl,
                            it.value.projectId,
                            it.value.pinLength.toLong(),
                            MVerificationMethod.ofRaw(it.value.verificationMethod.ordinal) ?: MVerificationMethod.STANDARD_EMAIL,
                            it.value.verificationUrl,
                            it.value.verificationCustomText,
                            it.value.identityTypeLabel,
                            it.value.quickCodeEnabled,
                            it.value.limitQuickCodeRegistration,
                            MIdentityType.ofRaw(it.value.identityType.ordinal) ?: MIdentityType.EMAIL,
                            it.value.sessionId,
                            it.value.signingHash,
                            it.value.signingDescription,
                            MSigningSessionStatus.ofRaw(it.value.status.ordinal) ?: MSigningSessionStatus.ACTIVE,
                            it.value.expireTime
                        )
                    )
                )
            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()

                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                    if (error is SigningSessionException.GetSigningSessionDetailsFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    )
                }
            }
        }
    }

    fun getSigningSessionDetailsFromLink(
        link: String,
        callback: (Result<MSigningSessionDetails>) -> Unit
    ) {
        MIRACLTrust.getInstance().getSigningSessionDetailsFromAppLink(Uri.parse(link)) {
            if (it is MIRACLSuccess) {
                callback(
                    Result.success(
                        MSigningSessionDetails(
                            it.value.userId,
                            it.value.projectName,
                            it.value.projectLogoUrl,
                            it.value.projectId,
                            it.value.pinLength.toLong(),
                            MVerificationMethod.ofRaw(it.value.verificationMethod.ordinal) ?: MVerificationMethod.STANDARD_EMAIL,
                            it.value.verificationUrl,
                            it.value.verificationCustomText,
                            it.value.identityTypeLabel,
                            it.value.quickCodeEnabled,
                            it.value.limitQuickCodeRegistration,
                            MIdentityType.ofRaw(it.value.identityType.ordinal) ?: MIdentityType.EMAIL,
                            it.value.sessionId,
                            it.value.signingHash,
                            it.value.signingDescription,
                            MSigningSessionStatus.ofRaw(it.value.status.ordinal) ?: MSigningSessionStatus.ACTIVE,
                            it.value.expireTime
                        )
                    )
                )
            } else {
                if (it is MIRACLError) {
                    val error = it.value
                    val details = mutableMapOf<String, Any?>()

                    details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                    if (error is SigningSessionException.GetSigningSessionDetailsFail && error.cause != null) {
                        details["error"] = error.cause.toString()
                    }

                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value, details)
                        )
                    );
                }
            }
        }
    }

    fun sign(
        userId: String,
        pin: String,
        message: ByteArray,
        callback: (Result<MSigningResult>) -> Unit
    ) {
        MIRACLTrust.getInstance().getUser(userId) { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUser
            }

            val user = (result as MIRACLSuccess).value
            user?.let {
                MIRACLTrust.getInstance().sign(message, user, {
                    it.consume(pin)
                }) {
                    if (it is MIRACLSuccess) {
                        val signature = MSignature(
                            it.value.signature.U,
                            it.value.signature.V, 
                            it.value.signature.dtas, 
                            it.value.signature.mpinId, 
                            it.value.signature.hash, 
                            it.value.signature.publicKey
                        )
                        val signingResult = MSigningResult(signature, it.value.timestamp.secondsSince1970)
                        callback(
                            Result.success(signingResult)
                        )
                    } else if (it is MIRACLError) {
                        val error = it.value
                        val details = mutableMapOf<String, Any?>()

                        details["exceptionCode"] = error.flutterExceptionCodeRepresentation
                        if (error is SigningException.SigningFail && error.cause != null) {
                            details["error"] = error.cause.toString()
                        }

                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value, details)
                            )
                        );
                    }
                }
            }
        }
    }

    fun delete(userId: String, callback: (Result<Unit>) -> Unit) {
        MIRACLTrust.getInstance().getUser(userId) { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUser
            }

            val user = (result as MIRACLSuccess).value
            user?.let {
                MIRACLTrust.getInstance().delete(it) { result -> 
                    if (result is MIRACLError) {
                        callback(
                            Result.failure(
                                mapExceptionToFlutter(result.value)
                            )
                        )
                        return@delete
                    }
                    
                    callback(Result.success(Unit))
                }
            }
        }
    }

    fun getUsers(callback: (Result<List<MUser>>) -> Unit) {
        MIRACLTrust.getInstance().getUsers() { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUsers
            }

            val users = (result as MIRACLSuccess).value
            callback(
                Result.success(
                    users.map { user -> userToMUser(user) }
                )
            )
        }
    }

    fun getUser(userId: String, callback: (Result<MUser?>) -> Unit) {
        MIRACLTrust.getInstance().getUser(userId) { result -> 
            if (result is MIRACLError) {
                callback(
                    Result.failure(
                        mapExceptionToFlutter(result.value)
                    )
                )
                return@getUser
            }
            
            (result as MIRACLSuccess).value?.let { user ->
                callback(
                    Result.success(userToMUser(user))
                )
            } ?: run {
                callback(Result.success(null))
            }
        }
    } 

    private fun userToMUser(user: User) = MUser(
        projectId = user.projectId,
        revoked = user.revoked,
        userId = user.userId,
        pinLength = user.pinLength.toLong(),
        hashedMpinId = user.hashedMpinId
    )

    private fun mapExceptionToFlutter(error: Exception, details: Map<String, Any?>? = null): FlutterError {
        return FlutterError(
            code = error::class.simpleName ?: "" ,
            details = details,
        )
    }
}