package com.example.belmiad

import android.content.ContentResolver
import android.content.Intent
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Hosts the Flutter UI and the "belmiad/sounds" channel used by the
 * reminder sound setting: picking a ringtone from the phone and previewing
 * sounds.
 */
class MainActivity : FlutterActivity() {
    private var pendingPick: MethodChannel.Result? = null
    private var preview: Ringtone? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pick" -> pick(call.argument<String>("current"), call.argument<String>("title"), result)
                    "play" -> {
                        play(call.argument<String>("kind"), call.argument<String>("value"))
                        result.success(null)
                    }
                    "stop" -> {
                        stopPreview()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /** Opens the system sound picker (ringtones, notification and alarm sounds). */
    private fun pick(current: String?, title: String?, result: MethodChannel.Result) {
        if (pendingPick != null) {
            result.error("busy", "A sound picker is already open", null)
            return
        }
        stopPreview()
        val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply {
            putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_ALL)
            putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, false)
            putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, false)
            if (title != null) putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, title)
            if (current != null) {
                putExtra(RingtoneManager.EXTRA_RINGTONE_EXISTING_URI, Uri.parse(current))
            }
        }
        try {
            pendingPick = result
            startActivityForResult(intent, PICK_REQUEST)
        } catch (error: Exception) {
            pendingPick = null
            result.error("unavailable", error.message, null)
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != PICK_REQUEST) return
        val result = pendingPick ?: return
        pendingPick = null
        val uri: Uri? = if (resultCode == RESULT_OK && data != null) {
            if (Build.VERSION.SDK_INT >= 33) {
                data.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI, Uri::class.java)
            } else {
                @Suppress("DEPRECATION")
                data.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
            }
        } else {
            null
        }
        if (uri == null) {
            result.success(null)
            return
        }
        val name = try {
            RingtoneManager.getRingtone(this, uri)?.getTitle(this)
        } catch (_: Exception) {
            null
        }
        result.success(mapOf("uri" to uri.toString(), "title" to name))
    }

    /** Plays a short preview of a reminder sound. */
    private fun play(kind: String?, value: String?) {
        stopPreview()
        val uri = when (kind) {
            "builtIn" -> Uri.Builder()
                .scheme(ContentResolver.SCHEME_ANDROID_RESOURCE)
                .authority(packageName)
                .appendPath("raw")
                .appendPath(value ?: return)
                .build()
            "device" -> Uri.parse(value ?: return)
            "systemDefault" -> RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            else -> return
        }
        preview = RingtoneManager.getRingtone(this, uri)?.apply {
            audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()
            play()
        }
    }

    private fun stopPreview() {
        preview?.stop()
        preview = null
    }

    override fun onDestroy() {
        stopPreview()
        super.onDestroy()
    }

    private companion object {
        const val CHANNEL = "belmiad/sounds"
        const val PICK_REQUEST = 7401
    }
}
