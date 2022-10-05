


/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

package com.amazonaws.amplify.amplify_push_notifications_pinpoint.amplify_push_notifications_pinpoint_android

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.amazonaws.amplify.amplify_core.AtomicResult
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


public class AmplifyPushNotificationsPinpointAndroidPlugin : FlutterPlugin, ActivityAware, MethodCallHandler{

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
      "requestMessagingPermission" -> {
        LOG.info("Asking for permission ")
        mainActivity!!.startActivity(Intent(context,PermissionActivity::class.java))

//        askNotificationPermission()
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
        val serviceIntent = Intent(context,MyFirebaseMessagingService::class.java)
        context.startService(serviceIntent)
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
