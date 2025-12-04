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
import kotlin.coroutines.suspendCoroutine

/** FlutterMiraclSdkPlugin */
class FlutterMiraclSdkPlugin : FlutterPlugin, MiraclSdk {
    private lateinit var context: Context
    private var sdkHandler = SdkHandler();
    private lateinit var mLogger: MLogger

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        MiraclSdk.setUp(flutterPluginBinding.binaryMessenger, this)
        mLogger = MLogger(flutterPluginBinding.binaryMessenger)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        
    }

    override fun initSdk(
        configuration: MConfiguration, 
        callback: (kotlin.Result<Unit>) -> Unit
    ) {
        sdkHandler.initSdk(configuration, mLogger, context, callback)
    }

    override fun setProjectId(
        projectId: String,
        callback: (kotlin.Result<Unit>) -> Unit
    ) {
        sdkHandler.setProjectId(projectId, callback)
    }
    
    override fun updateProjectSettings(
        projectId: String, 
        projectUrl: String,
        callback: (kotlin.Result<Unit>) -> Unit
    ) {
        sdkHandler.updateProjectSettings(projectId, projectUrl, callback)
    }

    override fun sendVerificationEmail(
        userId: String,
        callback: (kotlin.Result<MEmailVerificationResponse>) -> Unit
    ) {
        sdkHandler.sendVerificationMail(userId, callback)
    }

    override fun getActivationTokenByURI(
        uri: String, 
        callback: (kotlin.Result<MActivationTokenResponse>) -> Unit
    ) {
        sdkHandler.getActivationToken(uri, callback)
    }

    override fun getActivationTokenByUserIdAndCode(
        userId: String, 
        code: String, 
        callback: (kotlin.Result<MActivationTokenResponse>) -> Unit
    ) {
        sdkHandler.getActivationToken(userId, code, callback)
    }

    override fun getUsers(
        callback: (kotlin.Result<List<MUser>>) -> Unit
    ) {
        sdkHandler.getUsers(callback)
    }

    override fun register(
        userId: String,
        activationToken: String, 
        pin: String, 
        pushToken: String?, 
        callback: (kotlin.Result<MUser>) -> Unit
    ) {
        sdkHandler.register(userId, activationToken, pin, pushToken, callback)
    }

    override fun authenticate(
        user: MUser,
        pin: String, 
        callback: (kotlin.Result<String>) -> Unit
    ) {
        sdkHandler.authenticate(user, pin, callback)
    }

    override fun delete(
        user: MUser, 
        callback: (kotlin.Result<Unit>) -> Unit
    ) {
        sdkHandler.delete(user.userId, callback)
    }
    
    override fun generateQuickCode(
        user: MUser,
        pin: String, 
        callback: (kotlin.Result<MQuickCode>) -> Unit
    ) {
        sdkHandler.generateQuickCode(user.userId, pin, callback)
    }

    override fun sign(
        user: MUser, 
        message: ByteArray, 
        pin: String,
        callback: (kotlin.Result<MSigningResult>) -> Unit
    ) {
        sdkHandler.sign(user.userId, pin, message, callback)
    }

    override fun authenticateWithQrCode(
        user: MUser, 
        qrCode: String,
        pin: String,
        callback: (kotlin.Result<Boolean>) -> Unit
    ) {
        sdkHandler.authenticateWithQrCode(user.userId, qrCode, pin, callback)
    }

    override fun authenticateWithLink(
        user: MUser,  
        link: String,
        pin: String, 
        callback: (kotlin.Result<Boolean>) -> Unit
    ) {
        sdkHandler.authenticateWithAppLink(user.userId, link, pin, callback)
    }

    override fun authenticateWithNotificationPayload(
        payload: Map<String, String>, 
        pin: String, callback: (kotlin.Result<Boolean>) -> Unit
    ) {
        sdkHandler.authenticateWithPayload(payload, pin, callback)
    }

    override fun getAuthenticationSessionDetailsFromQRCode(
        qrCode: String, 
        callback: (kotlin.Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        sdkHandler.getAuthenticationSessionDetailsFromQRCode(qrCode, callback)
    }

    override fun getAuthenticationSessionDetailsFromLink(
        link: String, 
        callback: (kotlin.Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        sdkHandler.getAuthenticationSessionDetailsFromLink(link, callback)
    }

    override fun getAuthenticationSessionDetailsFromPushNofitifactionPayload(
        payload: Map<String, String>, 
        callback: (kotlin.Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        sdkHandler.getAuthenticationSessionDetailsFromPayload(payload, callback)
    }


    override fun getSigningDetailsFromQRCode(
        qrCode: String, callback: (kotlin.Result<MSigningSessionDetails>) -> Unit
    ) {
        sdkHandler.getSigningSessionDetailsFromQRCode(qrCode, callback)
    }

    override fun getSigningSessionDetailsFromLink(
        link: String, 
        callback: (kotlin.Result<MSigningSessionDetails>) -> Unit
    ) {
        sdkHandler.getSigningSessionDetailsFromLink(link, callback)
    }

    override fun getUser(userId: String, callback: (kotlin.Result<MUser?>) -> Unit) {
        sdkHandler.getUser(userId, callback)
    }
  
}
