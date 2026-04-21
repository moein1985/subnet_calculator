package com.example.subnet_calculator

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(
			flutterEngine.dartExecutor.binaryMessenger,
			"subnet_calculator/share"
		).setMethodCallHandler { call, result ->
			if (call.method == "shareText") {
				val text = call.argument<String>("text") ?: ""
				val subject = call.argument<String>("subject") ?: "Subnet Calculator"

				if (text.isBlank()) {
					result.error("EMPTY_TEXT", "Cannot share empty text", null)
					return@setMethodCallHandler
				}

				val sendIntent = Intent(Intent.ACTION_SEND).apply {
					type = "text/plain"
					putExtra(Intent.EXTRA_SUBJECT, subject)
					putExtra(Intent.EXTRA_TEXT, text)
				}

				val chooser = Intent.createChooser(sendIntent, subject)
				startActivity(chooser)
				result.success(true)
			} else {
				result.notImplemented()
			}
		}
	}
}
