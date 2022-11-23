package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.amplifyframework.core.Amplify

/**
 * The Amazon Pinpoint push notification receiver.
 */
class AmplifyPushNotificationBroadcastReceiver : BroadcastReceiver() {
    private val LOG = Amplify.Logging.forNamespace("amplify:flutter:AmplifyPushNotificationBroadcastReceiver")

    override fun onReceive(context: Context, intent: Intent) {
        LOG.info("Intent received in broadcast")

    }
}