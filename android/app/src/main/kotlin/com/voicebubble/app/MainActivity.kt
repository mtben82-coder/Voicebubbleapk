package com.voicebubble.app

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "voicebubble/overlay"
    private val TAG = "MainActivity"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register custom overlay plugin
        flutterEngine.plugins.add(OverlayPlugin())
        
        // Setup method channel for overlay control
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "showFlutterOverlay" -> {
                    Log.d(TAG, "Showing Flutter overlay window")
                    // The flutter_overlay_window plugin handles this
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }
    
    private fun handleIntent(intent: Intent?) {
        if (intent?.action == "SHOW_OVERLAY") {
            Log.d(TAG, "SHOW_OVERLAY action received, triggering Flutter overlay")
            // Notify Flutter to show the overlay
            flutterEngine?.let { engine ->
                MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod(
                    "triggerOverlay",
                    null
                )
            }
            // Close MainActivity immediately so we stay in the current app
            finish()
        }
    }
}
