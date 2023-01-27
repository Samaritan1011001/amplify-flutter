// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:meta/meta.dart';

abstract class NotificationsPluginInterface extends AmplifyPluginInterface {
  @override
  @nonVirtual
  Category get category => Category.notifications;

  /// {@macro amplify_core.amplify_push_notifications_category.request_messaging_permission}
  Future<PushPermissionRequestStatus> requestMessagingPermission(
      {bool? alert = true, bool? badge = true, bool? sound = true}) {
    throw UnimplementedError(
        'requestMessagingPermission() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.on_new_token}
  Future<Stream<String>> onNewToken() {
    throw UnimplementedError('onNewToken() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.get_token}
  Future<String?> getToken() {
    throw UnimplementedError('getToken() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.on_foreground_message_received}
  Stream<RemotePushMessage> onForegroundNotificationReceived() {
    throw UnimplementedError(
        'requestMessagingPermission() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.on_background_message_received}
  void onBackgroundNotificationReceived(RemoteMessageCallback callback) {
    throw UnimplementedError(
        'onBackgroundNotificationReceived() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.on_notificaiton_opened_app}
  void onNotificationOpenedApp(RemoteMessageCallback callback) {
    throw UnimplementedError(
        'onNotificationOpenedApp() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.identify_user}
  Future<void> identifyUser({
    required String userId,
    required AnalyticsUserProfile userProfile,
  }) {
    throw UnimplementedError('identifyUser() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.get_badge_count}
  Future<int> getBadgeCount() {
    throw UnimplementedError('getBadgeCount() has not been implemented');
  }

  /// {@macro amplify_core.amplify_push_notifications_category.set_badge_count}
  Future<void> setBadgeCount(int badgeCount) {
    throw UnimplementedError('setBadgeCount() has not been implemented');
  }
}
