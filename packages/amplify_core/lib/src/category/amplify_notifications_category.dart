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

part of amplify_interface;

class NotificationsCategory
    extends AmplifyCategory<NotificationsPluginInterface> {
  @override
  @nonVirtual
  Category get category => Category.notifications;

  // Future<void> registerForRemoteNotifications() {
  //   return plugins.length == 1
  //       ? plugins[0].registerForRemoteNotifications()
  //       : throw _pluginNotAddedException('Notifications');
  // }

  Future<PushPermissionRequestStatus> requestMessagingPermission(
      {bool? alert = true, bool? badge = true, bool? sound = true}) {
    return plugins.length == 1
        ? plugins[0].requestMessagingPermission(
            alert: alert, badge: badge, sound: sound)
        : throw _pluginNotAddedException('Notifications');
  }

  Future<Stream<String>> onNewToken() {
    return plugins.length == 1
        ? plugins[0].onNewToken()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<String> getToken() {
    return plugins.length == 1
        ? plugins[0].getToken()
        : throw _pluginNotAddedException('Notifications');
  }

  Stream<RemotePushMessage> onForegroundNotificationReceived() {
    return plugins.length == 1
        ? plugins[0].onForegroundNotificationReceived()
        : throw _pluginNotAddedException('Notifications');
  }

  void onBackgroundNotificationReceived(RemoteMessageCallback callback) {
    return plugins.length == 1
        ? plugins[0].onBackgroundNotificationReceived(callback)
        : throw _pluginNotAddedException('Notifications');
  }

  void onNotificationOpenedApp(RemoteMessageCallback callback) {
    return plugins.length == 1
        ? plugins[0].onNotificationOpenedApp(callback)
        : throw _pluginNotAddedException('Notifications');
  }

  Future<RemotePushMessage> getInitialNotification() {
    return plugins.length == 1
        ? plugins[0].getInitialNotification()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<void> identifyUser({
    required String userId,
    required NotificationsUserProfile userProfile,
  }) async {
    return plugins.length == 1
        ? plugins[0].identifyUser(userId: userId, userProfile: userProfile)
        : throw _pluginNotAddedException('Analytics');
  }

  Future<void> unregisterForRemoteNotifications() {
    return plugins.length == 1
        ? plugins[0].unregisterForRemoteNotifications()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<int> getBadgeCount() {
    return plugins.length == 1
        ? plugins[0].getBadgeCount()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<void> setBadgeCount(int badgeCount) {
    return plugins.length == 1
        ? plugins[0].setBadgeCount(badgeCount)
        : throw _pluginNotAddedException('Notifications');
  }
}
