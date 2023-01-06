package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ProcessLifecycleOwner
import com.google.firebase.messaging.RemoteMessage
import io.flutter.view.FlutterMain
import org.json.JSONObject

class PushNotificationReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        if (isPushNotificationIntent(intent)) {
            val remoteMessage = RemoteMessage(intent!!.extras)
            val remoteMessageBundle = getBundleFromRemoteMessage(remoteMessage)
            val lifecycle = ProcessLifecycleOwner.get().lifecycle
            if (lifecycle.currentState.isAtLeast(Lifecycle.State.STARTED)) {
                // TODO: Convert bundle to object and send back to dart
                val notificationDataJson = convertBundleToJson(remoteMessageBundle)
                Log.d(TAG, "Send foreground message received event: $notificationDataJson")

                PushNotificationEventManager.sendEvent(
                    PushNotificationEventType.FOREGROUND_MESSAGE_RECEIVED, notificationDataJson
                )
            }else {
                Log.d(TAG, "App is in background, start headless service")
                try {
                    val notificationDataJson = convertBundleToJson(remoteMessageBundle)
                    PushNotificationEventManager.sendEvent(
                        PushNotificationEventType.BACKGROUND_MESSAGE_RECEIVED, notificationDataJson
                    )

                    // TODO: Start a background headless service
                    FlutterMain.startInitialization(context)
                    FlutterMain.ensureInitializationComplete(context, null)
                    PushNotificationBackgroundService.enqueueWork(context, intent)

                } catch (exception: Exception) {
                    Log.e(TAG, "Something went wrong while starting headless task")
                }
            }
        }
    }

    companion object {
        private val TAG = "PushNotifReceiver"
    }
}