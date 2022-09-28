


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

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.amazonaws.amplify.amplify_core.AtomicResult
import com.amplifyframework.core.Amplify
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


public class AmplifyPushNotificationsPinpointAndroidPlugin : FlutterPlugin, ActivityAware, MethodCallHandler, AppCompatActivity() {

  private lateinit var channel: MethodChannel
  private var mainActivity: Activity? = null
  private lateinit var context: Context

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

  companion object {
    val LOG = Amplify.Logging.forNamespace("amplify:flutter:notifications_pinpoint")
  }

  // Handle methods received via MethodChannel
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull _result: Result) {
    val result = AtomicResult(_result, call.method)

    when (call.method) {
      "requestMessagingPermission" -> {
        askNotificationPermission()
        result.success(null)
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

  // Declare the launcher at the top of your Activity/Fragment:
  private val requestPermissionLauncher = registerForActivityResult(
    ActivityResultContracts.RequestPermission()
  ) { isGranted: Boolean ->
    if (isGranted) {
      // FCM SDK (and your app) can post notifications.
      LOG.debug("App can post push notifications 2 ")
    } else {
      // TODO: Inform user that that your app will not show notifications.
    }
  }

  private fun askNotificationPermission() {
    if (Build.VERSION.SDK_INT >= 33) {

//       This is only necessary for API level >= 33 (TIRAMISU)
      if (ContextCompat.checkSelfPermission(context,Manifest.permission.POST_NOTIFICATIONS) ==
        PackageManager.PERMISSION_GRANTED
      ) {
        // FCM SDK (and your app) can post notifications.
        LOG.debug("App can post push notifications 1 ")
      }
      else if (mainActivity!!.shouldShowRequestPermissionRationale(Manifest.permission.POST_NOTIFICATIONS)) {
        // TODO: display an educational UI explaining to the user the features that will be enabled
        //       by them granting the POST_NOTIFICATION permission. This UI should provide the user
        //       "OK" and "No thanks" buttons. If the user selects "OK," directly request the permission.
        //       If the user selects "No thanks," allow the user to continue without notifications.
        LOG.debug("App should ask for permissions")
      }
      else {
        // Directly ask for the permission
//        requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
        mainActivity!!.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 0)

      }
    }
  }

  override fun onRequestPermissionsResult(requestCode: Int,
                                          permissions: Array<String>, grantResults: IntArray) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    when (requestCode) {
      0 -> {
        // If request is cancelled, the result arrays are empty.
        if ((grantResults.isNotEmpty() &&
                  grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
          // Permission is granted. Continue the action or workflow
          // in your app.
          LOG.debug("Permission is granted.")

        } else {
          // Explain to the user that the feature is unavailable because
          // the features requires a permission that the user has denied.
          // At the same time, respect the user's decision. Don't link to
          // system settings in an effort to convince the user to change
          // their decision.

          LOG.debug("Permission is denied.")

        }
        return
      }

      // Add other 'when' lines to check for other
      // permissions this app might request.
      else -> {
        // Ignore all other requests.
      }
    }
  }

}
