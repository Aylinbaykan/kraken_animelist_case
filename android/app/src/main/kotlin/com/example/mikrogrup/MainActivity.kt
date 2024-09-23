package com.example.mikrogrup

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.method_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "animeListFetched") {
                // Flutter tarafından gelen bilgiyi alıyoruz.
                val message = call.arguments as String
                println("I was notified on the native side: $message")
                result.success("Notification received from the native side.")
            } else {
                result.notImplemented()
            }
        }
    }
}


