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
            config.projectId
        ).build()

        MIRACLTrust.configure(context, configuration)
        callback(Result.success(Unit))
    }
}