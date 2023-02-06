package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android


import android.app.ActivityManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat.getSystemService
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ProcessLifecycleOwner
import com.amplifyframework.pushnotifications.pinpoint.utils.NotificationPayload
import com.amplifyframework.pushnotifications.pinpoint.utils.PushNotificationsUtils
import com.google.firebase.messaging.RemoteMessage
import io.flutter.view.FlutterMain
import kotlinx.coroutines.*
import java.net.HttpURLConnection
import java.net.URL


class PushNotificationReceiver : BroadcastReceiver() {
    private val scope = CoroutineScope(SupervisorJob())
    companion object {
        private val TAG = "PushNotifReceiver"
        private const val CHANNEL_ID = "com.amplifyframework.pushnotifications"
        private const val CHANNEL_NAME = "General"
    }

    override fun onReceive(context: Context, intent: Intent?) {
        intent?.let {
            if (isPushNotificationIntent(it)) {
                val remoteMessage = RemoteMessage(it.extras)
                val remoteMessageBundle = getBundleFromRemoteMessage(remoteMessage)
                if (isAppInForeground(context)) {
                    // TODO: Convert bundle to object and send back to dart
                    val notificationDataJson = convertBundleToJson(remoteMessageBundle)
                    Log.d(TAG, "Send foreground message received event: $notificationDataJson")

                    PushNotificationEventManager.sendEvent(
                        PushNotificationEventType.FOREGROUND_MESSAGE_RECEIVED, notificationDataJson
                    )
                } else {
                    Log.d(TAG, "App is in background, start background service and enqueue work")
                    try {
                        val pendingResult: PendingResult = goAsync()

//                        PushNotificationsUtils(context,"testChannelId").showNotification(NotificationPayload("test", "bodyyyy",null,"https://9to5mac.com/wp-content/uploads/sites/6/2022/06/7411.WWDC_2022_Light-1024w-1366h@2xipad.jpeg?quality=82&strip=all"),
//                            AmplifyPushNotificationAndroidPlugin::class.java)
                        displayNotification(context, remoteMessage, pendingResult)
//                    val notificationDataJson = convertBundleToJson(remoteMessageBundle)
//                    PushNotificationEventManager.sendEvent(
//                        PushNotificationEventType.BACKGROUND_MESSAGE_RECEIVED, notificationDataJson
//                    )
//
                        // TODO: Start a background headless service
//                        FlutterMain.startInitialization(context)
//                        FlutterMain.ensureInitializationComplete(context, null)
//                        PushNotificationBackgroundService.enqueueWork(context, it)

                    } catch (exception: Exception) {
                        Log.e(TAG, "Something went wrong while starting headless task $exception")
                    }
                }
            }
        }
    }


    private fun displayNotification(
        context: Context,
        remoteMessage: RemoteMessage,
        pendingResult: PendingResult
    ) {
        val remoteMessageBundle = getBundleFromRemoteMessage(remoteMessage)

        val notificationManager: NotificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // If body is absent, treat as silent notification and display nothing
        val body = remoteMessage.notification?.body
            ?: remoteMessage.data["message"]
            ?: remoteMessage.data["pinpoint.notification.body"]
            ?: return
        val imageUrl = remoteMessage.notification?.imageUrl?.toString()
            ?: remoteMessage.data["imageUrl"]
            ?: remoteMessage.data["pinpoint.notification.imageUrl"]
        val title = remoteMessage.notification?.title
            ?: remoteMessage.data["title"]
            ?: remoteMessage.data["pinpoint.notification.title"]
        scope.launch(Dispatchers.Default) {
            var largeImageIcon: Bitmap? = null
            try {
                if (imageUrl != null) {
                    withContext(Dispatchers.IO) {
                        val connection = URL(imageUrl).openConnection() as HttpURLConnection
                        connection.doInput = true
                        connection.connect()
                        val responseCode = connection.responseCode
                        if (responseCode == HttpURLConnection.HTTP_OK) {
                            val inputStream = connection.inputStream
                            largeImageIcon = BitmapFactory.decodeStream(inputStream)
                            inputStream.close()
                        }
                    }
                }
            } catch (exception: Exception) {
                Log.e(
                    TAG,
                    "Something went wrong while fetching image at $imageUrl: ${exception.message}"
                )
            } finally {
                val launchIntent = Intent(context,
                    getLaunchActivityClass(context)
                ).putExtras(remoteMessageBundle)
                launchIntent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
                launchIntent.putExtra("appOpenedThroughTap", true)
                val notificationId = remoteMessage.messageId.hashCode()
                val contentIntent = PendingIntent.getActivity(
                    context, notificationId, launchIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
//                Can I somehow setAsInitialNotification as I build it?
                val builder = NotificationCompat.Builder(context, CHANNEL_ID)
                    .setAutoCancel(true)
                    .setContentIntent(contentIntent)
                    .setContentTitle(title)
                    .setContentText(body)
//                    .setLargeIcon(largeImageIcon)
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setSmallIcon(R.drawable.common_google_signin_btn_icon_light)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Log.i(TAG, "inside if statment")
                // Create the NotificationChannel
                val name = "default_channel"
                val descriptionText = "default description"
                val importance = NotificationManager.IMPORTANCE_HIGH
                val mChannel = NotificationChannel(CHANNEL_ID, name, importance)
                mChannel.description = descriptionText
                // Register the channel with the system; you can't change the importance
                // or other notification behaviors after this
                notificationManager.createNotificationChannel(mChannel)
            }
            createNotificationChannel(context)
            with(NotificationManagerCompat.from(context)) {
                notify(notificationId, builder.build())
            }

                pendingResult.finish()
            }
        }
    }

    private fun createNotificationChannel(context: Context) {
        // Create the NotificationChannel, but only on API 26+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, importance)
            // Register the channel with the system
            val notificationManager = getSystemService(context, NotificationManager::class.java)
            notificationManager?.createNotificationChannel(channel)
        }
    }


    private fun isAppInForeground(context: Context): Boolean {
        // Gets a list of running processes.
        val processes =
            (context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager).runningAppProcesses

        // On some versions of android the first item in the list is what runs in the foreground, but this is not true
        // on all versions. Check the process importance to see if the app is in the foreground.
        val packageName = context.applicationContext.packageName
        for (appProcess in processes) {
            val processName = appProcess.processName
            if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND && processName == packageName) {
                return true
            }
        }
        return false
    }

    private fun getLaunchActivityClass(context: Context): Class<*>? {
        val packageName = context.packageName
        val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
        launchIntent?.component?.className?.let {
            try {
                return Class.forName(it)
            } catch (e: Exception) {
                Log.e(
                    TAG,
                    "Unable to find launch activity class"
                )
            }
        }
        return null
    }
}