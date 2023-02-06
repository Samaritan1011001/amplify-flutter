package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.app.ActivityCompat.shouldShowRequestPermissionRationale
import com.amazonaws.amplify.AtomicResult
import com.amplifyframework.core.Amplify
import com.amplifyframework.pushnotifications.pinpoint.utils.PushNotificationsUtils
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
//import com.amplifyframework.pushnotifications.pinpoint.utils

/** AmplifyPushNotificationAndroidPlugin */
class AmplifyPushNotificationAndroidPlugin : FlutterPlugin, ActivityAware, MethodCallHandler, PluginRegistry.NewIntentListener, PluginRegistry.RequestPermissionsResultListener  {

    private lateinit var channel: MethodChannel
    private var mainActivity: Activity? = null
    private lateinit var context: Context
    private val LOG = Amplify.Logging.forNamespace("amplify:flutter:push_notification_plugin")
    private var activityBinding: ActivityPluginBinding? = null
    private var launchNotification: RemoteMessage? = null

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
                askNotificationPermission()
                result.success(null)
            }
            "getToken" -> {

                LOG.info("getting token ")
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
            "getLaunchNotification" -> {
                LOG.info("Fetching launch notification")
                askNotificationPermission()
                if(launchNotification !=null) {
                    val remoteMessageBundle = getBundleFromRemoteMessage(launchNotification!!)
                    val notificationDataJson = convertBundleToJson(remoteMessageBundle)
                    result.success(notificationDataJson.toString())
                    launchNotification = null
                }else{
                    result.success(null)
                }
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


    // Declare the launcher at the top of your Activity/Fragment:
//    private val requestPermissionLauncher = ActivityCompat.registerForActivityResult(
//        ActivityResultContracts.RequestPermission()
//    ) { isGranted: Boolean ->
//        if (isGranted) {
//            // FCM SDK (and your app) can post notifications.
//            LOG.info("App can post push notifications 2 ")
//        } else {
//            // TODO: Inform user that that your app will not show notifications.
//        }
//    }

    private fun askNotificationPermission() {
        mainActivity?.let {
            if (Build.VERSION.SDK_INT >= 33) {

//       This is only necessary for API level >= 33 (TIRAMISU)
                if (context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
                    PackageManager.PERMISSION_GRANTED
                ) {
                    // FCM SDK (and your app) can post notifications.
                    LOG.info("App can post push notifications 1 ")
                } else if (shouldShowRequestPermissionRationale(
                        it,
                        Manifest.permission.POST_NOTIFICATIONS
                    )
                ) {
                    // TODO: display an educational UI explaining to the user the features that will be enabled
                    //       by them granting the POST_NOTIFICATION permission. This UI should provide the user
                    //       "OK" and "No thanks" buttons. If the user selects "OK," directly request the permission.
                    //       If the user selects "No thanks," allow the user to continue without notifications.
                    LOG.info("App should prompt why we asking for permission")
//                    requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                    requestPermissions(it,
                        arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                        1)
                } else {
                    LOG.info("Prompt user with dialog ")
                    // Directly ask for the permission
//                    requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                    requestPermissions(it,
                        arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                        1)

                }
            }
        }
    }

    private fun checkAppOpeningIntentAndEnqueueWork(appOpeningIntent: Intent, fromKilledState: Boolean): Boolean {
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
//                PushNotificationBackgroundService.enqueueWork(context, appOpeningIntent)
                    val remoteMessage = RemoteMessage(appOpeningIntent.extras)
                    val remoteMessageBundle = getBundleFromRemoteMessage(remoteMessage)
                    val notificationDataJson = convertBundleToJson(remoteMessageBundle)
                    Log.d(TAG, "Send onNotificationOpened message received event: $notificationDataJson")
                if(fromKilledState){
                    launchNotification = remoteMessage
                }
                    PushNotificationEventManager.sendEvent(
                        PushNotificationEventType.NOTIFICATION_OPENED_APP, notificationDataJson
                    )
            }
            true
        } catch (e: java.lang.Exception) {
            Log.e(TAG, "Error enqueue work for app opening notification $e")
            false
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        Log.d(TAG, "onNewIntent in push plugin $intent")

        return checkAppOpeningIntentAndEnqueueWork(intent, false)
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


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "attached to activity $binding")
        binding.addOnNewIntentListener(this)
        this.mainActivity = binding.activity

        val appOpeningIntent = binding.activity.intent
        checkAppOpeningIntentAndEnqueueWork(appOpeningIntent, true)

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

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        when (requestCode) {
            1 -> {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.isNotEmpty() &&
                            grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    // Permission is granted. Continue the action or workflow
                    // in your app.
                    LOG.info("Permissions granted ")
                } else {
                    // Explain to the user that the feature is unavailable because
                    // the feature requires a permission that the user has denied.
                    // At the same time, respect the user's decision. Don't link to
                    // system settings in an effort to convince the user to change
                    // their decision.
                    LOG.info("Permissions denied ")

                }
                return true
            }

        }
        return false
    }

}
