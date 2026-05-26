package com.example.projeto_integrador_jogo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val mapsChannel = "projeto_integrador_jogo/maps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mapsChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "isMapsApiKeyConfigured" -> result.success(isMapsApiKeyConfigured())
                else -> result.notImplemented()
            }
        }
    }

    private fun isMapsApiKeyConfigured(): Boolean {
        val applicationInfo = packageManager.getApplicationInfo(
            packageName,
            android.content.pm.PackageManager.GET_META_DATA
        )
        val apiKey = applicationInfo.metaData?.getString("com.google.android.geo.API_KEY")
        return !apiKey.isNullOrBlank() && apiKey != "YOUR_ANDROID_MAPS_API_KEY"
    }
}
