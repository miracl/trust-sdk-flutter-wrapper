package com.miracl.trust.flutter_miracl_sdk

import android.content.Context
import android.net.Uri
import com.miracl.trust.MIRACLError
import com.miracl.trust.MIRACLSuccess
import com.miracl.trust.MIRACLTrust
import com.miracl.trust.configuration.Configuration
import com.miracl.trust.model.User
import com.miracl.trust.util.log.Logger
import java.util.*


class SdkHandler {
    fun initSdk(config: MConfiguration, context: Context, callback: (Result<Unit>) -> Unit) {
        val configuration = Configuration.Builder(
            config.projectId
        ).build()

        MIRACLTrust.configure(context, configuration)
        callback(Result.success(Unit))
    }

    fun setProjectId(projectId: String, callback: (Result<Unit>) -> Unit) {
        MIRACLTrust.getInstance().setProjectId(projectId)
        callback(Result.success(Unit))
    }

    fun sendVerificationMail(
        userId: String, callback: (Result<Boolean>) -> Unit
    ) {
        MIRACLTrust.getInstance().sendVerificationEmail(userId) {
            if (it is MIRACLSuccess) {
                callback(Result.success(true));
            } else {
                if (it is MIRACLError) {
                    callback(Result.failure(mapExceptionToFlutter(it.value)))
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
                        )
                    )
                }
            }
        });
    }

    suspend fun authenticate(user: MUser, pin: String, callback: (Result<String>) -> Unit) {
        MIRACLTrust.getInstance().getUser(user.userId) { result -> 
            if (result is MIRACLError) {
                println(result.value.stackTraceToString())
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
                    print("this is auth code: ${it.value}")
                    callback(Result.success(it.value))
                } else {
                    if (it is MIRACLError) {
                        println(it.value.stackTraceToString())
                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value)
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
                println(result.value.stackTraceToString())
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
                        callback(Result.failure(mapExceptionToFlutter(it.value)))
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
                println(it.value.toString());
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
                        )
                    );
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
                println(it.value.toString());
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
                        )
                    );
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
                println(it.value.toString());
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
                        )
                    );
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
                println(result.value.stackTraceToString())
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
                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value)
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
                println(result.value.stackTraceToString())
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
                        callback(
                            Result.failure(
                                mapExceptionToFlutter(it.value)
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
                callback(
                    Result.failure(
                        mapExceptionToFlutter(it.value)
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
                println(it.value.toString());
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
                        )
                    );
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
                println(it.value.toString());
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
                    println(it.value.stackTraceToString())
                    callback(
                        Result.failure(
                            mapExceptionToFlutter(it.value)
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
                println(result.value.stackTraceToString())
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
                        val signingResult = MSigningResult(signature, it.value.timestamp.time)
                        callback(
                            Result.success(signingResult)
                        )
                    } else if (it is MIRACLError) {
                        callback(Result.failure(mapExceptionToFlutter(it.value)))
                    }
                }
            }
        }
    }

    fun delete(userId: String, callback: (Result<Unit>) -> Unit) {
        MIRACLTrust.getInstance().getUser(userId) { result -> 
            if (result is MIRACLError) {
                println(result.value.stackTraceToString())
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
                        println(result.value.stackTraceToString())
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
                println(result.value.stackTraceToString())
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

    private fun userToMUser(user: User): MUser {
        return MUser(projectId = user.projectId, revoked = user.revoked, userId = user.userId, hashedMpinId = user.hashedMpinId);
    }

    private fun mapExceptionToFlutter(error: Exception): FlutterError {
        return FlutterError(
            code = error.toString(),
            message = error.message,
            details = error.stackTraceToString(),
        )
    }
}