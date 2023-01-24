package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import com.amazonaws.amplify.AtomicResult
import com.amplifyframework.core.Amplify
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject
import com.amplifyframework.pushnotifications.pinpoint.utils

/** AmplifyPushNotificationAndroidPlugin */
class AmplifyPushNotificationAndroidPlugin : FlutterPlugin, ActivityAware, MethodCallHandler,
    FirebaseMessagingService(), PluginRegistry.NewIntentListener {

    private lateinit var channel: MethodChannel
    private var mainActivity: Activity? = null
    private lateinit var context: Context
    private val LOG = Amplify.Logging.forNamespace("amplify:flutter:push_notification_plugin")
    private var isListeningToOnNewToken = false
    private var activityBinding: ActivityPluginBinding? = null

    companion object {
        @JvmStatic
        private val TAG = "AmplifyPushNotifPlugin"

        @JvmStatic
        val SHARED_PREFERENCES_KEY = "amplify_push_notification_plugin_cache"

        @JvmStatic
        val BG_USER_CALLBACK_HANDLE_KEY = "bg_user_callback_handle"

        @JvmStatic
        val APP_OPENING_USER_CALLBACK_HANDLE_KEY = "app_opening_callback_handle"

        @JvmStatic
        val CALLBACK_DISPATCHER_HANDLE_KEY = "callback_dispatch_handler"


        @JvmStatic
        private fun registerCallbackToCache(
            context: Context,
            args: ArrayList<*>?,
            callbackKey: String
        ) {
            Log.d(TAG, "Initializing PushNotificationService ${args!![0]}")
            val callbackHandle = args[0] as Long
            context.getSharedPreferences(SHARED_PREFERENCES_KEY, Context.MODE_PRIVATE)
                .edit()
                .putLong(callbackKey, callbackHandle)
                .apply()
        }

    }


    // Handle methods received via MethodChannel
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull _result: Result) {
        val result = AtomicResult(_result, call.method)

        when (call.method) {
            "registerForRemoteNotifications" -> {
                result.success("Not yet implemented")
            }
            "requestMessagingPermission" -> {
                LOG.info("Asking for permission ")
//        mainActivity!!.startActivity(Intent(context, PermissionActivity::class.java))

                result.success(null)
            }
            "getToken" -> {
                LOG.info("getting token ")
                PushNotificationsUtils
                FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        LOG.info("Fetching FCM registration token failed")
                        return@OnCompleteListener
                    }

                    // Get new FCM registration token
                    val token = task.result
                    result.success(token)

                })
            }
            "onNewToken" -> {
//                LOG.info("onNewToken native method ")
                isListeningToOnNewToken = true
            }
            "initializeService" -> {
                val args = call.arguments<ArrayList<*>>()
                // Simply stores the callback handle for the callback dispatcher
                registerCallbackToCache(context, args, CALLBACK_DISPATCHER_HANDLE_KEY)
                result.success(true)
            }
            "registerBGUserGivenCallback" -> {
                val args = call.arguments<ArrayList<*>>()
                registerCallbackToCache(context, args, BG_USER_CALLBACK_HANDLE_KEY)
            }
            "registerAppOpeningUserGivenCallback" -> {
                val args = call.arguments<ArrayList<*>>()
                registerCallbackToCache(context, args, APP_OPENING_USER_CALLBACK_HANDLE_KEY)
            }
            else -> result.notImplemented()
        }
    }

    private fun checkAppOpeningIntentAndEnqueueWork(appOpeningIntent: Intent): Boolean {
        return try {

            //        DEBUG: uncomment to debug app killed state use cases
            //      val spInstance = context.getSharedPreferences(SHARED_PREFERENCES_KEY, Context.MODE_PRIVATE)
            //      var counter = spInstance.getInt("notificationTappedCounter", 0)
            //      Log.d(TAG, "counter in onNewIntent $counter")
            //      val editor = spInstance.edit()
            //      editor.putInt("notificationTappedCounter", ++counter).apply()

            val appOpenedThroughTap = appOpeningIntent.getBooleanExtra("appOpenedThroughTap", false)
            Log.d(TAG, "appOpenedThroughTap $appOpenedThroughTap")

            if (appOpenedThroughTap) {
                val spInstance =
                    context.getSharedPreferences(SHARED_PREFERENCES_KEY, Context.MODE_PRIVATE)
                var counter = spInstance.getInt("notificationTappedCounter", 0)
                Log.d(TAG, "counter in onAttachedToActivity $counter")

                val editor = spInstance.edit()
                editor.putInt("notificationTappedCounter", ++counter).apply()
                PushNotificationBackgroundService.enqueueWork(context, appOpeningIntent)
//                    val remoteMessage = RemoteMessage(appOpeningIntent.extras)
//                    val remoteMessageBundle = getBundleFromRemoteMessage(remoteMessage)
//                    val notificationDataJson = convertBundleToJson(remoteMessageBundle)
//                    Log.d(TAG, "Send onNotificationOpened message received event: $notificationDataJson")
//
//                    PushNotificationEventManager.sendEvent(
//                        PushNotificationEventType.NOTIFICATION_OPENED_APP, notificationDataJson
//                    )

            }
            true
        } catch (e: java.lang.Exception) {
            Log.e(TAG, "Error enqueue work for app opening notification $e")
            false
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        Log.d(TAG, "onNewIntent in push plugin $intent")

        return checkAppOpeningIntentAndEnqueueWork(intent)
    }

    override fun onAttachedToEngine(
        @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {

        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "com.amazonaws.amplify/push_notification_plugin"
        )
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        PushNotificationEventManager.initializeWithMethodChannel(channel)

//      DEBUG: uncomment to debug app killed state use cases
//      val spInstance = context.getSharedPreferences(SHARED_PREFERENCES_KEY, Context.MODE_PRIVATE)
//      var counter = spInstance.getInt("notificationTappedCounter", -1)
//      Log.d(TAG, "notificationTappedCounter on app launch $counter")
    }

    /**
     * Called if the FCM registration token is updated. This may occur if the security of
     * the previous token had been compromised. Note that this is called when the
     * FCM registration token is initially generated so this is where you would retrieve the token.
     */
    override fun onNewToken(token: String) {
        LOG.info("Refreshed token: $token")
        if (isListeningToOnNewToken) {
            val tokenDataJson = JSONObject()
            tokenDataJson.apply {
                put("token", token)
            }
            PushNotificationEventManager.sendEvent(
                PushNotificationEventType.NEW_TOKEN,
                tokenDataJson
            )
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "attached to activity $binding")
        binding.addOnNewIntentListener(this)
        this.mainActivity = binding.activity

        val appOpeningIntent = binding.activity.intent
        checkAppOpeningIntentAndEnqueueWork(appOpeningIntent)

        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
//      activityBinding?.removeOnNewIntentListener(this)
//      activityBinding = null
        this.mainActivity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}
