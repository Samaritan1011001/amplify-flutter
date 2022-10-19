package com.amazonaws.amplify.amplify_push_notifications_pinpoint.amplify_push_notifications_pinpoint_android


import android.content.Intent
import android.os.Binder
import android.os.IBinder
import com.amazonaws.amplify.amplify_core.AtomicResult
import com.amplifyframework.core.Amplify
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {
    private val LOG = Amplify.Logging.forNamespace("amplify:flutter:notifications_pinpoint:MyFirebaseMessagingService")
    lateinit var resultEmitter:AtomicResult;
    /**
     * Class for clients to access.  Because we know this service always
     * runs in the same process as its clients, we don't need to deal with
     * IPC.
     */
    inner class LocalBinder : Binder() {
        val getService: MyFirebaseMessagingService
            get() = this@MyFirebaseMessagingService
    }

//    override fun onBind(intent: Intent?): IBinder? {
//        return mBinder
//    }


    //        override fun onCreate() {
//        super.onCreate()
//        LOG.info("onCreate of service called")
//    }
    // [START receive_message]
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        // TODO(developer): Handle FCM messages here.
        // Not getting messages here? See why this may be: https://goo.gl/39bRNJ
        LOG.info("From: ${remoteMessage.from}")

        // Check if message contains a data payload.
        if (remoteMessage.data.isNotEmpty()) {
            LOG.info("Message data payload: ${remoteMessage.data}")

//            if (/* Check if data needs to be processed by long running job */ true) {
//                // For long-running tasks (10 seconds or more) use WorkManager.
//                scheduleJob()
//            } else {
//                // Handle message within 10 seconds
//                handleNow()
//            }
        }

        // Check if message contains a notification payload.
        remoteMessage.notification?.let {
            LOG.info("Message Notification Body: ${it.body}")
        }

        // Also if you intend on generating your own notifications as a result of a received FCM
        // message, here is where that should be initiated. See sendNotification method below.
    }
    // [END receive_message]

    // [START on_new_token]
    /**
     * Called if the FCM registration token is updated. This may occur if the security of
     * the previous token had been compromised. Note that this is called when the
     * FCM registration token is initially generated so this is where you would retrieve the token.
     */
    override fun onNewToken(token: String) {
        LOG.info("Refreshed token: $token")


    }
    // [END on_new_token]


}