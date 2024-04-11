package com.gradleplayground

import android.app.Application
import android.util.Log

class MyApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        Log.d("RESULT", "first -> ${com.first.getResult()}")
        Log.d("RESULT", "second -> ${com.second.getResult()}")
        Log.d("RESULT", "build config -> ${BuildConfig.DESC}")
    }
}