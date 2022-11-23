package com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.amazonaws.amplify.AtomicResult
import com.amazonaws.amplify.amplify_push_notification.amplify_push_notification_android.PermissionActivity
import com.amplifyframework.core.Amplify
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AmplifyPushNotificationAndroidPlugin */
class AmplifyPushNotificationAndroidPlugin: FlutterPlugin, ActivityAware, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private var mainActivity: Activity? = null
  private lateinit var context: Context
  private val LOG = Amplify.Logging.forNamespace("amplify:flutter:notifications_pinpoint")

  override fun onAttachedToEngine(
    @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  ) {

    channel = MethodChannel(
      flutterPluginBinding.binaryMessenger,
      "com.amazonaws.amplify/notifications_pinpoint"
    )
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }


  // Handle methods received via MethodChannel
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull _result: Result) {
    val result = AtomicResult(_result, call.method)

    when (call.method) {
      "registerForRemoteNotifications" -> {
//        val serviceIntent = Intent(context,MyFirebaseMessagingService::class.java)
//        context.startService(serviceIntent);
        result.success("Not yet implemented");
      }
      "requestMessagingPermission" -> {
        LOG.info("Asking for permission ")
        mainActivity!!.startActivity(Intent(context, PermissionActivity::class.java))

        result.success(null)
      }
      "getToken" -> {
        LOG.info("getting token ")
        FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
          if (!task.isSuccessful) {
            LOG.info( "Fetching FCM registration token failed")
            return@OnCompleteListener
          }

          // Get new FCM registration token
          val token = task.result
          result.success(token)

        })
      }
      "onNewToken" -> {
        LOG.info("onNewToken native method ")
//        val serviceIntent = Intent(context,MyFirebaseMessagingService::class.java)
////        serviceIntent.putExtra("channel", channel);
//        doBindService(context)
      }
      else -> result.notImplemented()
    }
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.mainActivity = binding.activity
  }

  override fun onDetachedFromActivity() {
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
