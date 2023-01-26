package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android


import com.amplifyframework.core.Amplify
import com.google.firebase.messaging.FirebaseMessagingService
import org.json.JSONObject

class PushNotificationFirebaseMessagingService : FirebaseMessagingService() {
    private val LOG = Amplify.Logging.forNamespace("amplify:flutter:notifications_pinpoint:MyFirebaseMessagingService")


    // [START on_new_token]
    /**
     * Called if the FCM registration token is updated. This may occur if the security of
     * the previous token had been compromised. Note that this is called when the
     * FCM registration token is initially generated so this is where you would retrieve the token.
     */
    override fun onNewToken(token: String) {
        LOG.info("Refreshed token: $token")
        val tokenDataJson = JSONObject()
        tokenDataJson.apply {
            put("token", token)
        }
//        PushNotificationEventManager.sendEvent(
//            PushNotificationEventType.NEW_TOKEN,
//            tokenDataJson
//        )

    }
    // [END on_new_token]


}