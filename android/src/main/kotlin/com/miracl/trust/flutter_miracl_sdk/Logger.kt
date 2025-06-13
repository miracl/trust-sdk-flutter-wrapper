package com.miracl.trust.flutter_miracl_sdk
import android.util.Log
import android.os.Handler
import android.os.Looper
import com.miracl.trust.util.log.Logger

class FlutterLogger (
    val mLogger: MLogger
) : Logger {

    override fun error(logTag: String, message: String) {
        Handler(Looper.getMainLooper()).post {
            mLogger.error(logTag, message) {  }
        }
    }

    override fun warning(logTag: String, message: String) {
        Handler(Looper.getMainLooper()).post {
            mLogger.warning(logTag, message) {  }
        }
    }

    override fun info(logTag: String, message: String) {
        Handler(Looper.getMainLooper()).post {  
            mLogger.info(logTag, message) {  }
        }
    }

    override fun debug(logTag: String, message: String) {
        Handler(Looper.getMainLooper()).post {  
            mLogger.debug(logTag, message) {  }
        }
    }
}