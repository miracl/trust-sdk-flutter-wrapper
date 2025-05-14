package com.miracl.trust.flutter_miracl_sdk

import java.util.Date

internal val Date.secondsSince1970
    get() = this.time / 1000