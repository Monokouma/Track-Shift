package com.despaircorp.trackshift

import android.os.Build

class AndroidPlatform : Platform {
    override val name: String = "Android LALALALA ${Build.VERSION.SDK_INT}"
}

actual fun getPlatform(): Platform = AndroidPlatform()