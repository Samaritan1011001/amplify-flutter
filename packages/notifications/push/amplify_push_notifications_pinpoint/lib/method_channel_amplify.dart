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

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/services.dart';

import '../amplify_push_notifications_pinpoint.dart';
// import 'package:amplify_push_notifications_pinpoint/lib/sdk/pinpoint.dart';

const MethodChannel _methodChannel = MethodChannel(
    'com.amazonaws.amplify/notifications_pinpoint');

const EventChannel _eventChannel =
    EventChannel('com.amazonaws.amplify/event_channel/notifications_pinpoint');

class AmplifyNotificationsPinpointMethodChannel
    extends AmplifyPushNotificaitonsPinpoint {
  AmplifyNotificationsPinpointMethodChannel() : super.protected();

  static Stream<String>? _newTokenStream;

  // TODO: map using the push token from the event not the entire event
  static Stream<String> get newTokenStream => _newTokenStream ??=
      _eventChannel.receiveBroadcastStream().map((event) => event.toString());

  @override
  Future<void> addPlugin() async {
    try {
      _methodChannel.setMethodCallHandler(nativeMethodCallHandler);

      // TODO: Add the call to native layer to add the plugin
      return Future.delayed(const Duration(milliseconds: 10));
      // return await _methodChannel.invokeMethod('addPlugin');
    } on PlatformException catch (e) {
      if (e.code == 'AmplifyAlreadyConfiguredException') {
        throw const AmplifyAlreadyConfiguredException(
          AmplifyExceptionMessages.alreadyConfiguredDefaultMessage,
          recoverySuggestion:
              AmplifyExceptionMessages.missingRecoverySuggestion,
        );
      } else {
        throw AmplifyException.fromMap((e.details as Map).cast());
      }
    }
  }

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    print('Native call!');
    switch (methodCall.method) {
      case "getToken" :
        print("Received device token");
        break;
      default:
        return "Nothing";
        break;
    }
  }

  @override
  Future<void> registerForRemoteNotifications() async {
    await _methodChannel.invokeMethod<bool>('registerForRemoteNotifications');
  }

  @override
  Future<PushNotificationSettings> requestMessagingPermission(
      {PushNotificationSettings? permissionOptions}) async {
    permissionOptions ??= PushNotificationSettings();

    await _methodChannel.invokeMethod<bool>('requestMessagingPermission');

    permissionOptions.authorizationStatus = AuthorizationStatus.authorized;
    print("permissionOptions -> ${permissionOptions.authorizationStatus}");
    return permissionOptions;
  }

  @override
  Future<void> identifyUser({
    required String userId,
    required AnalyticsUserProfile userProfile,
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

    return '';
  }

  @override
  Future<Stream<RemoteMessage>> onForegroundNotificationReceived() async {
    return Stream.empty();
  }

  @override
  Future<Stream<RemoteMessage>> onBackgroundNotificationReceived() async {
    return Stream.empty();
  }

  @override
  Future<Stream<RemoteMessage>> onNotificationOpenedApp() async {
    return Stream.empty();
  }

  @override
  Future<RemoteMessage> getInitialNotification() async {
    return RemoteMessage();
  }

  @override
  Future<int> getBadgeCount() async {
    return 0;
  }

  @override
  Future<void> setBadgeCount() async {}

  //   /// Create an EndpointRequest object from a local Endpoint instance
  // EndpointRequest _endpointToRequest(PublicEndpoint publicEndpoint) {
  //   return EndpointRequest(
  //     address: publicEndpoint.address,
  //     attributes: publicEndpoint.attributes,
  //     channelType: publicEndpoint.channelType,
  //     demographic: publicEndpoint.demographic,
  //     effectiveDate: publicEndpoint.effectiveDate,
  //     endpointStatus: publicEndpoint.endpointStatus,
  //     location: publicEndpoint.location,
  //     metrics: publicEndpoint.metrics,
  //     optOut: publicEndpoint.optOut,
  //     requestId: publicEndpoint.requestId,
  //     user: publicEndpoint.user,
  //   );
  // }
}
