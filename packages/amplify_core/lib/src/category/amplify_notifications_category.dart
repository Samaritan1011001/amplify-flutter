// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
part of amplify_interface;

class NotificationsCategory
    extends AmplifyCategory<NotificationsPluginInterface> {
  @override
  @nonVirtual
  Category get category => Category.notifications;

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

  Future<String?> getToken() {
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

  Future<void> identifyUser({
    required String userId,
    required AnalyticsUserProfile userProfile,
  }) async {
    return plugins.length == 1
        ? plugins[0].identifyUser(userId: userId, userProfile: userProfile)
        : throw _pluginNotAddedException('Analytics');
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
