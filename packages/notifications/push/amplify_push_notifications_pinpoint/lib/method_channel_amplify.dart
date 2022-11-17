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

import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_push_notifications_pinpoint/endpoint_client.dart';
import 'package:amplify_push_notifications_pinpoint/src/impl/device_info_context_provider.dart';
import 'package:amplify_push_notifications_pinpoint/src/sdk/pinpoint.dart';
import 'package:flutter/services.dart';
import 'package:amplify_secure_storage/amplify_secure_storage.dart';

import '../amplify_push_notifications_pinpoint.dart';
// import 'package:amplify_push_notifications_pinpoint/lib/sdk/pinpoint.dart';

const MethodChannel _methodChannel =
    MethodChannel('com.amazonaws.amplify/notifications_pinpoint');

const EventChannel _eventChannel =
    EventChannel('com.amazonaws.amplify/event_channel/notifications_pinpoint');

class AmplifyNotificationsPinpointMethodChannel
    extends AmplifyPushNotificaitonsPinpoint {
  AmplifyNotificationsPinpointMethodChannel() : super.protected();

  static Stream<String>? _newTokenStream;

  EndpointClient? __endpointClient;
  static final AmplifyLogger _logger =
      AmplifyLogger.category(Category.notifications)
          .createChild('AmplifyNotificationsPinpointMethodChannel');

    final StreamController<RemotePushMessage> _foregroundEventStreamController = StreamController<RemotePushMessage>();
        final StreamController<RemotePushMessage> _backgroundEventStreamController = StreamController<RemotePushMessage>();


  // TODO: map using the push token from the event not the entire event
  static Stream<String> get newTokenStream => _newTokenStream ??=
      _eventChannel.receiveBroadcastStream().map((event) => event.toString());

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    print('Native call!');
    switch (methodCall.method) {
      case "onForegroundNotificationReceived":
        print("onForegroundNotificationReceived");
        _foregroundEventStreamController.add(RemotePushMessage());
        break;
      case "onBackgroundNotificationReceived":
        print("onBackgroundNotificationReceived");
        _backgroundEventStreamController.add(RemotePushMessage());
        break;
      default:
        return "Nothing";
    }
  }

  // @override
  // Future<void> addPlugin({
  //   required AmplifyAuthProviderRepository authProviderRepo,
  // }) async {
  //   await super.addPlugin(authProviderRepo: authProviderRepo);
  //   _logger.info("authProviderRepo -> $authProviderRepo");

  //   _logger.info("addPlugin works!");

  //   try {
  //     // await configureCustom(authProviderRepo);
  //     _methodChannel.setMethodCallHandler(nativeMethodCallHandler);

  //     // TODO: Add the call to native layer to add the plugin
  //     // return Future.delayed(const Duration(milliseconds: 10));
  //     return await _methodChannel.invokeMethod('addPlugin');
  //   } on PlatformException catch (e) {
  //     if (e.code == 'AmplifyAlreadyConfiguredException') {
  //       throw const AmplifyAlreadyConfiguredException(
  //         AmplifyExceptionMessages.alreadyConfiguredDefaultMessage,
  //         recoverySuggestion:
  //             AmplifyExceptionMessages.missingRecoverySuggestion,
  //       );
  //     } else {
  //       throw AmplifyException.fromMap((e.details as Map).cast());
  //     }
  //   }
  // }

  @override
  Future<void> configure({
    AmplifyConfig? config,
    required AmplifyAuthProviderRepository authProviderRepo,
  }) async {
    // Register native listeners for token generation and notification handling
    _methodChannel.setMethodCallHandler(nativeMethodCallHandler);

    _logger.info("Configure works!");

    // Parse config values from amplifyconfiguration.json
    if (config == null ||
        config.analytics == null ||
        config.analytics?.awsPlugin == null) {
      throw const AnalyticsException('No Pinpoint plugin config available');
    }

    final pinpointConfig = config.analytics!.awsPlugin!;
    final appId = pinpointConfig.pinpointAnalytics.appId;
    final region = pinpointConfig.pinpointAnalytics.region;

    final authProvider = authProviderRepo
        .getAuthProvider(APIAuthorizationType.iam.authProviderToken);
    if (authProvider == null) {
      throw const AnalyticsException(
        'No AWSIamAmplifyAuthProvider available. Is Auth category added and configured?',
      );
    }

    // Initialize Pinpoint Client
    final pinpointClient = PinpointClient(
      region: region,
      credentialsProvider: authProvider,
    );
    final keyValueStore = AmplifySecureStorage(
      config: AmplifySecureStorageConfig(
        scope: 'analyticsPinpoint',
      ),
    );

    // Register FCM and APNS if auto-registeration is enabled
    await _registerForRemoteNotifications();


    // Get device token once
    String deviceToken = await getToken();

    // Initialize Endpoint Client
    __endpointClient = await EndpointClient.getInstance(
      appId,
      keyValueStore,
      pinpointClient,
      deviceToken,
    );

    await __endpointClient?.updateEndpoint();
  }

  Future<void> _registerForRemoteNotifications() async {
    _logger.info("registerForRemoteNotifications");
    await _methodChannel.invokeMethod<String>('registerForRemoteNotifications');
  }

  @override
  Future<PushNotificationSettings> requestMessagingPermission(
      {PushNotificationSettings? pushNotificationSettings}) async {
    pushNotificationSettings ??= PushNotificationSettings();

    bool? granted = await _methodChannel.invokeMethod<bool>('requestMessagingPermission');

    if(granted!=null){
    pushNotificationSettings.authorizationStatus =
        granted?AuthorizationStatus.authorized:AuthorizationStatus.denied;
    }
     _logger.info(
        "pushNotificationSettings -> ${pushNotificationSettings.authorizationStatus}");
    return pushNotificationSettings;
  }

  @override
  Future<void> identifyUser({
    required String userId,
    required NotificationsUserProfile userProfile,
  }) async {
    print("userId -> $userId");
    print("userProfile -> $userProfile");

    // await _methodChannel.invokeMethod<bool>('identifyUser');
  }

  @override
  Future<Stream<String>> onNewToken() async {
    await _methodChannel.invokeMethod('onNewToken');
    return newTokenStream;
  }

  @override
  Future<String> getToken() async {
    String? token = await _methodChannel.invokeMethod<String>('getToken');
    print("Token -> $token");

    return token!;
  }

  @override
  Future<Stream<RemotePushMessage>> onForegroundNotificationReceived() async => _foregroundEventStreamController.stream;
  

  @override
  Future<Stream<RemotePushMessage>> onBackgroundNotificationReceived() async => _backgroundEventStreamController.stream;

  @override
  Future<Stream<RemotePushMessage>> onNotificationOpenedApp() async {
    return Stream.empty();
  }

  @override
  Future<RemotePushMessage> getInitialNotification() async {
    return RemotePushMessage();
  }

  @override
  Future<int> getBadgeCount() async {
    return 0;
  }

  @override
  Future<void> setBadgeCount(int badgeCount) async {}
}
