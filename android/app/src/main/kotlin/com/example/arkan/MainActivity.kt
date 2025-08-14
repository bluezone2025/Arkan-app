package com.example.arkan // غيرها لاسم الباكدج

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            Log.e("FATOORAH_NATIVE_ERROR", "Thread: ${thread.name}", throwable)
        }
    }
}
