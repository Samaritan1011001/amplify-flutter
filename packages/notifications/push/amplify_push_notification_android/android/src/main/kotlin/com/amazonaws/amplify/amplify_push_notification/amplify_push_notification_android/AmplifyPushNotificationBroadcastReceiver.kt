package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android


import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ProcessLifecycleOwner
import com.google.firebase.messaging.RemoteMessage
import io.flutter.view.FlutterMain


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
                    displayNotification(context, remoteMessage, remoteMessageBundle )
//                    val notificationDataJson = convertBundleToJson(remoteMessageBundle)
//                    PushNotificationEventManager.sendEvent(
//                        PushNotificationEventType.BACKGROUND_MESSAGE_RECEIVED, notificationDataJson
//                    )
//
//                    // TODO: Start a background headless service
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

    private fun displayNotification(
        context: Context,
        remoteMessage: RemoteMessage,
        remoteMessageBundle: Bundle,
//        pendingResult: PendingResult
    ) {
                    val notificationManager: NotificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    val CHANNEL_ID = "my_channel_01";

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
//        scope.launch(Dispatchers.Default) {
//            var largeImageIcon: Bitmap? = null
//            try {
//                if (imageUrl != null) {
//                    withContext(Dispatchers.IO) {
//                        val connection = URL(imageUrl).openConnection() as HttpURLConnection
//                        connection.doInput = true
//                        connection.connect()
//                        val responseCode = connection.responseCode
//                        if (responseCode == HttpURLConnection.HTTP_OK) {
//                            val inputStream = connection.inputStream
//                            largeImageIcon = BitmapFactory.decodeStream(inputStream)
//                            inputStream.close()
//                        }
//                    }
//                }
//            } catch (exception: Exception) {
//                Log.e(
//                    TAG,
//                    "Something went wrong while fetching image at $imageUrl: ${exception.message}"
//                )
//            } finally {
                val launchIntent = Intent(context,
                    getLaunchActivityClass(context)
                )
                    .putExtras(remoteMessageBundle)
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

        // notificationId is a unique int for each notification that you must define
                notificationManager.notify(notificationId, builder.build())

//                pendingResult.finish()
//            }
//        }
    }

//    fun sendToNotificationCentre(bundle: Bundle, context: Context) {
//        try {
//            val CHANNEL_ID = "my_channel_01";
//            val NOTIFICATION_ID = 1
//            val notificationManager: NotificationManager =
//                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
//                .setContentTitle("hard coded title")
//                .setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
//                .setPriority(NotificationCompat.PRIORITY_HIGH)
//                .setContentText("hard coded body")
//                .setSmallIcon(R.drawable.common_google_signin_btn_icon_light)
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                Log.i(TAG, "inside if statment")
//                // Create the NotificationChannel
//                val name = "default_channel"
//                val descriptionText = "default description"
//                val importance = NotificationManager.IMPORTANCE_HIGH
//                val mChannel = NotificationChannel(CHANNEL_ID, name, importance)
//                mChannel.description = descriptionText
//                // Register the channel with the system; you can't change the importance
//                // or other notification behaviors after this
//                notificationManager.createNotificationChannel(mChannel)
//            }
//                        val intent = Intent(
//                context,
//                PushNotificationReceiver::class.java
//            )
//            intent.putExtra("notification", bundle)
//            intent.putExtra("appOpenedThroughTap", true)
//
//            Log.i(TAG, "sendNotification: $intent")
//
//
//
//            val pendingIntent: PendingIntent = PendingIntent.getBroadcast(
//                context, NOTIFICATION_ID, intent,
//                PendingIntent.FLAG_UPDATE_CURRENT
//            )
//            notification.setContentIntent(pendingIntent)
//
//            val info: Notification = notification.build()
////            info.defaults = info.defaults or Notification.DEFAULT_LIGHTS
//            notificationManager.notify(NOTIFICATION_ID, info)
//
////
////            var msg = bundle.getString("message")
////            if (msg == null) {
////                msg = bundle.getString("pinpoint.notification.body");
////                if (msg == null) {
////                    // this happens when a 'data' notification is received - we do not synthesize a local notification in this case
////                    Log.d(TAG,
////                        "Cannot send to notification centre because there is no 'message' field in: $bundle"
////                    );
////                    return;
////                }
////            }
////            var notificationIdString: String? = bundle.getString("id")
////            if (notificationIdString == null) {
////                notificationIdString = bundle.getString("pinpoint.campaign.campaign_id")
////                if (notificationIdString == null) {
////                    Log.e(TAG, "No notification ID specified for the notification")
////                    return
////                }
////            }
////
////            val packageName: String = context.packageName
////            var title: String? = bundle.getString("title")
////            if (title == null) {
////                title = bundle.getString("pinpoint.notification.title")
////                if (title == null) {
////                    val appInfo: ApplicationInfo = context.applicationInfo
////                    title = context.packageManager.getApplicationLabel(appInfo).toString()
////                }
////            }
////
////            val notificationManager: NotificationManager =
////                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
////            val notification = NotificationCompat.Builder(context)
////                .setContentTitle("hard coded title")
////                .setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
////                .setPriority(NotificationCompat.PRIORITY_HIGH)
////                .setContentText("hard coded body")
////            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
////                notification.setChannelId(packageName)
////            }
////
////            val intent = Intent(
////                context,
////                PushNotificationReceiver::class.java
////            )
////            intent.putExtra("notification", bundle)
////            intent.putExtra("appOpenedThroughTap", true)
////
////            Log.i(TAG, "sendNotification: $intent")
////
////            val notificationID = notificationIdString.toInt()
////
////            // PendingIntent pendingIntent = PendingIntent.getActivity(context, notificationID, intent,
////            //         PendingIntent.FLAG_UPDATE_CURRENT);
//////            val pendingIntent: PendingIntent = PendingIntent.getBroadcast(
//////                context, notificationID, intent,
//////                PendingIntent.FLAG_UPDATE_CURRENT
//////            )
//////            notification.setContentIntent(pendingIntent)
////
////            val info: Notification = notification.build()
//////            info.defaults = info.defaults or Notification.DEFAULT_LIGHTS
////            notificationManager.notify(notificationID, info)
//
//        } catch (e: java.lang.Exception) {
//            Log.e(TAG, "failed to send push notification", e)
//        }
//    }
}