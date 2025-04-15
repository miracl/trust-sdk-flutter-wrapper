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

    override fun initSdk(
        configuration: MConfiguration, 
        callback: (Result<Unit>) -> Unit
    ) {
        sdkHandler.initSdk(configuration, context, callback)
    }

    override fun setProjectId(
        projectId: String, 
        callback: (Result<Unit>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun sendVerificationEmail(
        userId: String,
        authenticationSessionDetails: MAuthenticationSessionDetails?, 
        callback: (Result<Boolean>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun getActivationTokenByURI(
        uri: String, 
        callback: (Result<MActivationTokenResponse>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }
    override fun getActivationTokenByUserIdAndCode(
        userId: String, 
        code: String, 
        callback: (Result<MActivationTokenResponse>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun getUsers(
        callback: (Result<List<MUser>>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun register(
        userId: String,
        activationToken: String, 
        pin: String, pushToken: String?, 
        callback: (Result<MUser>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun authenticate(
        user: MUser,
        pin: String, 
        callback: (Result<String>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun delete(
        userId: String, 
        callback: (Result<Unit>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }
    
    override fun generateQuickCode(
        userId: String,
        pin: String, 
        callback: (Result<MQuickCode>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun sign(
        userId: String, 
        pin: String,
        message: ByteArray, 
        callback: (Result<MSigningResult>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }
    override fun authenticateWithQrCode(
        userId: String, 
        pin: String, 
        qrCode: String, 
        callback: (Result<Boolean>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun authenticateWithLink(
        userId: String, 
        pin: String, 
        link: String, 
        callback: (Result<Boolean>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun authenticateWithNotificationPayload(
        payload: Map<String, String>, 
        pin: String, callback: (Result<Boolean>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun getAuthenticationSessionDetailsFromQRCode(
        qrCode: String, 
        callback: (Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun getAuthenticationSessionDetailsFromLink(
        link: String, 
        callback: (Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun getAuthenticationSessionDetailsFromPushNofitifactionPayload(
        payload: Map<String, String>, 
        callback: (Result<MAuthenticationSessionDetails>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }


    override fun getSigningDetailsFromQRCode(
        qrCode: String, callback: (Result<MSigningSessionDetails>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }

    override fun getSigningSessionDetailsFromLink(
        link: String, 
        callback: (Result<MSigningSessionDetails>) -> Unit
    ) {
        throw NotImplementedError("This function is not yet implemented")
    }
  
}
