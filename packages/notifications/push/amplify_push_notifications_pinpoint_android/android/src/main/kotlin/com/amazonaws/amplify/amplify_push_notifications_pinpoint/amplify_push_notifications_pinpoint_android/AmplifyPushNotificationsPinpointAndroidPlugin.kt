


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
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
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

  // To invoke the bound service, first make sure that this value
  // is not null.
  private var mBoundService: MyFirebaseMessagingService? = null

  private val mConnection: ServiceConnection = object : ServiceConnection {
    override fun onServiceConnected(className: ComponentName?, service: IBinder) {
      // This is called when the connection with the service has been
      // established, giving us the service object we can use to
      // interact with the service.  Because we have bound to a explicit
      // service that we know is running in our own process, we can
      // cast its IBinder to a concrete class and directly access it.
      mBoundService = service.javaClass
      LOG.info("Connected to service")

      // Tell the user about this for our demo.

    }

    override fun onServiceDisconnected(className: ComponentName?) {
      // This is called when the connection with the service has been
      // unexpectedly disconnected -- that is, its process crashed.
      // Because it is running in our same process, we should never
      // see this happen.
      mBoundService = null

    }
  }

  private fun doBindService(context:Context) {
    // Attempts to establish a connection with the service.  We use an
    // explicit class name because we want a specific service
    // implementation that we know will be running in our own process
    // (and thus won't be supporting component replacement by other
    // applications).
    if (context.bindService(
        Intent(context, MyFirebaseMessagingService::class.java),
        mConnection, Context.BIND_AUTO_CREATE
      )
    ) {
      LOG.info("Attached to the service")
    } else {
      LOG.info("ERROR")
    }
  }

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
//        serviceIntent.putExtra("channel", channel);
        doBindService(context)
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
