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
import 'package:meta/meta.dart';

abstract class NotificationsPluginInterface extends AmplifyPluginInterface {
  @override
  @nonVirtual
  Category get category => Category.notifications;

  Future<void> onConfigure() async {}

  /// Configuration APIs
  Future<void> registerForRemoteNotifications() {
    throw UnimplementedError(
        'registerForRemoteNotifications() has not been implemented');
  }

  Future<PushNotificationSettings> requestMessagingPermission({PushNotificationSettings? permissionOptions}) {
    throw UnimplementedError('requestMessagingPermission() has not been implemented');
  }

  Future<void> identifyUser({
    required String userId,
    required AnalyticsUserProfile userProfile,
  }) {
    throw UnimplementedError('identifyUser() has not been implemented');
  }

  /// Token Managment APIs
  Future<Stream<String>> onNewToken() {
    throw UnimplementedError(
      'onNewToken() has not been implemented',
    );
  }

  Future<String> getToken() {
    throw UnimplementedError('getToken() has not been implemented');
  }

  /// Notification Hadling APIs
  Future<Stream<RemoteMessage>> onForegroundNotificationReceived() {
    throw UnimplementedError(
      'onForegroundNotificationReceived() has not been implemented',
    );
  }

  Future<Stream<RemoteMessage>> onBackgroundNotificationReceived() {
    throw UnimplementedError(
      'onBackgroundNotificationReceived() has not been implemented',
    );
  }

  Future<Stream<RemoteMessage>> onNotificationOpenedApp() {
    throw UnimplementedError(
      'onNotificationOpenedApp() has not been implemented',
    );
  }

  Future<RemoteMessage> getInitialNotification() {
    throw UnimplementedError('getInitialNotification() has not been implemented');
  }

  Future<int> getBadgeCount() {
    throw UnimplementedError('getBadgeCount() has not been implemented');
  }

  Future<void> setBadgeCount() {
    throw UnimplementedError('setBadgeCount() has not been implemented');
  }

}
