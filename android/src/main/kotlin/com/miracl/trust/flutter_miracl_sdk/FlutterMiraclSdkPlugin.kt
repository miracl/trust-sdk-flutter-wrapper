package com.miracl.trust.flutter_miracl_sdk

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.miracl.trust.MIRACLError
import com.miracl.trust.MIRACLSuccess

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.runBlocking
import kotlin.coroutines.suspendCoroutine

/** FlutterMiraclSdkPlugin */
class FlutterMiraclSdkPlugin : FlutterPlugin, MiraclSdk {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var sdkHandler = SdkHandler();

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        MiraclSdk.setUp(flutterPluginBinding.binaryMessenger, this)
        context = flutterPluginBinding.applicationContext
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    override fun initSdk(configuration: MConfiguration, callback: (kotlin.Result<Unit>) -> Unit) {
        sdkHandler.initSdk(configuration, context, callback)
    }

    override fun sendVerificationEmail(userId: String, callback: (kotlin.Result<Boolean>) -> Unit) {
        sdkHandler.sendVerificationMail(userId, callback)
    }

    override fun getActivationToken(
        uri: String,
        callback: (kotlin.Result<MActivationTokenResponse>) -> Unit
    ) {
        sdkHandler.getActivationToken(uri, callback);
    }

    override fun getUsers(): List<MUser> {
       return sdkHandler.getUsers();
    }


    override fun register(
        userId: String,
        activationToken: String,
        pin: String,
        pushToken: String?,
        callback: (kotlin.Result<MUser>) -> Unit
    ) {
        sdkHandler.register(userId, activationToken, pin, pushToken, callback);
    }

    override fun authenticate(user: MUser, pin: String, callback: (kotlin.Result<String>) -> Unit) {
        sdkHandler.authenticate(user, pin, callback);
    }

    override fun getAuthenticationSessionDetailsFromQRCode(
        qrCode: String,
        callback: (kotlin.Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        sdkHandler.getAuthenticationSessionDetailsFromQRCode(qrCode, callback)
    }

    override fun delete(userId: String, callback: (kotlin.Result<Unit>) -> Unit) {
        sdkHandler.delete(userId, callback)
    }



    override fun generateQuickCode(
        userId: String,
        pin: String,
        callback: (kotlin.Result<MQuickCode>) -> Unit
    ) {
        sdkHandler.generateQuickCode(userId, pin, callback)
    }

    override fun signingRegister(
        userId: String,
        pin: String,
        callback: (kotlin.Result<MUser>) -> Unit
    ) {
        sdkHandler.signingRegister(userId,pin,callback);
    }

    override fun sign(
        userId: String,
        pin: String,
        message: ByteArray,
        date: Long,
        callback: (kotlin.Result<MSignature>) -> Unit
    ) {
        sdkHandler.sign(userId, pin, message, date, callback)
    }

    override fun authenticateWithQrCode(
        userId: String,
        pin: String,
        qrCode: String,
        callback: (kotlin.Result<Boolean>) -> Unit
    ) {
        sdkHandler.authenticateWithQrCode(userId, qrCode, pin, callback)
    }

    override fun getAuthenticationIdentity(
        userId: String,
        callback: (kotlin.Result<MIdentity>) -> Unit
    ) {
        sdkHandler.getAuthenticationIdentity(userId, callback)
    }

    override fun authenticateWithNotificationPayload(
        payload: Map<String, String>,
        pin: String,
        callback: (kotlin.Result<Unit>) -> Unit
    ) {
        sdkHandler.authenticateWithNotificationPayload(payload, pin, callback)
    }


}
