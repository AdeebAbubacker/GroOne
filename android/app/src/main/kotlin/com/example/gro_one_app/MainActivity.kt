package com.gro.oneapp

import io.flutter.embedding.android.FlutterFragmentActivity
import android.app.Activity
import android.app.Activity.RESULT_OK
import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


//class MainActivity: FlutterFragmentActivity() {
//    // ...
//}

class MainActivity: FlutterActivity() {
    private val CHANNEL = "custom_ringtone_picker"
    private val REQUEST_CODE_PICK_RINGTONE = 101
    private var resultCallback: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "pickRingtone") {
                resultCallback = result
                val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER)
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_NOTIFICATION)
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, "Select Notification Tone")
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, false)
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
                startActivityForResult(intent, REQUEST_CODE_PICK_RINGTONE)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_PICK_RINGTONE && resultCode == Activity.RESULT_OK) {
            val uri: Uri? = data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
            if (uri != null) {
                resultCallback?.success(uri.toString())
            } else {
                resultCallback?.success(null)
            }
        }
    }
}
