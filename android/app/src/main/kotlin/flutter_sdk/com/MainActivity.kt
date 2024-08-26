package flutter_sdk.com

import android.graphics.Bitmap
import android.os.Environment
import eu.bolt.screenshotty.Screenshot
import eu.bolt.screenshotty.ScreenshotActionOrder
import eu.bolt.screenshotty.ScreenshotBitmap
import eu.bolt.screenshotty.ScreenshotManager
import eu.bolt.screenshotty.ScreenshotManagerBuilder
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "screenshot"
    private lateinit var screenshotManager: ScreenshotManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "captureScreenshot" -> {
                    captureScreenshot { screenshot ->
                        // Handle screenshot result
                        result.success(screenshot)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun captureScreenshot(callback: (String?) -> Unit) {
        screenshotManager =
            ScreenshotManagerBuilder(this).withCustomActionOrder(ScreenshotActionOrder.pixelCopyFirst())
                .withPermissionRequestCode(111).build()

        val screenshotResult = screenshotManager.makeScreenshot()
        screenshotResult.observe(onSuccess = { screenshot ->
            callback(saveScreenshotToFile(screenshot))
        }, onError = {
            callback(null)
        })
    }

    private fun saveScreenshotToFile(screenshot: Screenshot): String? {
        if (screenshot is ScreenshotBitmap) {
            val bitmap = screenshot.bitmap
            val file = File(
                getExternalFilesDir(Environment.DIRECTORY_PICTURES),
                "screenshot_${System.currentTimeMillis()}.png"
            )
            try {
                FileOutputStream(file).use { out ->
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
                    out.flush()
                }
                return file.absolutePath
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
        return null
    }
}
