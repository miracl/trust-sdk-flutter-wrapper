package com.miracl.trust.flutter_miracl_sdk

import android.content.Context
import android.net.Uri
import com.miracl.trust.MIRACLError
import com.miracl.trust.MIRACLException
import com.miracl.trust.MIRACLSuccess
import com.miracl.trust.MIRACLTrust
import com.miracl.trust.configuration.Configuration
import com.miracl.trust.model.User
import com.miracl.trust.util.log.Logger
import java.util.*


class SdkHandler {
    fun initSdk(config: MConfiguration, context: Context, callback: (Result<Unit>) -> Unit) {
        val configuration = Configuration.Builder(
            config.projectId, config.clientId, config.redirectUri
        ).loggingLevel(Logger.LoggingLevel.DEBUG).build()

        MIRACLTrust.configure(context, configuration)
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


    private fun userToMUser(user: User): MUser {
        return MUser(
            user.authenticationIdentityId.toString(),
            user.projectId,
            user.revoked,
            user.authenticationIdentityId.toString(),
            user.userId,
        );
    }

    private fun mUserToUser(mUser: MUser): User {
        val user = MIRACLTrust.getInstance().getUser(mUser.userId)
        return user!!
    }

    fun authenticate(user: MUser, pin: String, callback: (Result<String>) -> Unit) {
        MIRACLTrust.getInstance().authenticate(mUserToUser(user), {
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


    fun delete(userId: String, callback: (Result<Unit>) -> Unit) {
        val user = MIRACLTrust.getInstance().getUser(userId)
        user?.let {
            MIRACLTrust.getInstance().delete(it)
            callback(Result.success(Unit))
        }
    }

    fun authenticateWithQrCode(
        userId: String,
        qrCode: String,
        pin: String,
        callback: (Result<Boolean>) -> Unit
    ) {
        val user = MIRACLTrust.getInstance().getUser(userId)
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


    fun getAuthenticationSessionDetailsFromQRCode(
        qrCode: String, callback: (Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        MIRACLTrust.getInstance().getAuthenticationSessionDetailsFromQRCode(qrCode) {
            if (it is MIRACLSuccess) {
                println(it.value.toString());

                callback(
                    Result.success(
                        MAuthenticationSessionDetails(
                            it.value.userId
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

    fun generateQuickCode(
        userId: String,
        pin: String,
        callback: (Result<MQuickCode>) -> Unit
    ) {
        val user = MIRACLTrust.getInstance().getUser(userId)
        user?.let { currentUser ->
            MIRACLTrust.getInstance().generateQuickCode(currentUser, { it.consume(pin); }) {
                if (it is MIRACLSuccess) {
                    callback(
                        Result.success(
                            MQuickCode(
                                it.value.code,
                                it.value.expireTime,
                                it.value.nowTime,
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

    fun signingRegister(userId: String, pin: String, callback: (Result<MUser>) -> Unit) {
        val user = MIRACLTrust.getInstance().getUser(userId)
        user?.let {
            MIRACLTrust.getInstance()
                .signingRegister(user,
                    { it.consume(pin) },
                    { it.consume(pin) }
                ) {
                    if (it is MIRACLSuccess) {
                        callback(
                            Result.success(
                                userToMUser(it.value)
                            )
                        )
                    } else if (it is MIRACLError) {
                        callback(Result.failure(mapExceptionToFlutter(it.value)))
                    }
                }

        }
    }

    fun sign(
        userId: String,
        pin: String,
        message: ByteArray,
        date: Long,
        callback: (Result<MSignature>) -> Unit
    ) {
        val user = MIRACLTrust.getInstance().getUser(userId)

        user?.let {
            MIRACLTrust.getInstance().sign(message, Date(date * 1000), user, {
                it.consume(pin)
            }) {
                if (it is MIRACLSuccess) {
                    callback(
                        Result.success(
                            MSignature(
                                it.value.U,
                                it.value.V,
                                it.value.dtas,
                                it.value.mpinId,
                                it.value.hash,
                                it.value.publicKey
                            ),
                        )
                    )
                } else if (it is MIRACLError) {
                    callback(Result.failure(mapExceptionToFlutter(it.value)))
                }
            }
        }


    }

    private fun mapExceptionToFlutter(error: MIRACLException): FlutterError {
        return FlutterError(
            code = error.errorCode.toString(),
            message = error.message,
            details = error.stackTraceToString(),
        )
    }

    fun getAuthenticationIdentity(userId: String, callback: (Result<MIdentity>) -> Unit) {


        val user = MIRACLTrust.getInstance().getUser(userId);
        user?.let {
            val authId = user.getAuthenticationIdentity()
            authId?.let { auth ->
                callback(
                    Result.success(
                        MIdentity(
                            dtas = auth.dtas,
                            id = auth.id.toString(),
                            hashedMpinId = auth.hashedMpinId,
                            mpinId = auth.mpinId,
                            pinLength = auth.pinLength.toLong(),
                            publicKey = auth.publicKey,
                            token = auth.token,
                        )
                    )
                );
            } ?: {
                callback(
                    Result.failure(
                        FlutterError(
                            code = "NO_AUTH_ID",
                            message = "NO_AUTH_ID",
                            details = "NO_AUTH_ID",
                        )
                    )
                )
            }

        }

    }

    fun getUsers(): List<MUser> {
        return MIRACLTrust.getInstance().users.map { user -> userToMUser(user) }
    }

    fun authenticateWithNotificationPayload(
        payload: Map<String, String>,
        pin: String,
        callback: (Result<Unit>) -> Unit
    ) {
        MIRACLTrust.getInstance().authenticateWithNotificationPayload(payload, {
            it.consume(pin)
        }) {
            if (it is MIRACLSuccess) {
                callback(Result.success(Unit))
            } else if (it is MIRACLError) {
                callback(Result.failure(mapExceptionToFlutter(it.value)))
            }
        }
    }

}