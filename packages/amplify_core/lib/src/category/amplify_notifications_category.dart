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

  Future<void> registerForRemoteNotifications() {
    return plugins.length == 1
        ? plugins[0].registerForRemoteNotifications()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<PushNotificationSettings> requestMessagingPermission({PushNotificationSettings? permissionOptions}) {
    return plugins.length == 1
        ? plugins[0].requestMessagingPermission(permissionOptions: permissionOptions)
        : throw _pluginNotAddedException('Notifications');
  }

  Future<void> identifyUser(
      {required String userId,
      required AnalyticsUserProfile userProfile}) async {
    return plugins.length == 1
        ? plugins[0].identifyUser(userId: userId, userProfile: userProfile)
        : throw _pluginNotAddedException('Analytics');
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

  Future<Stream<RemoteMessage>> onForegroundNotificationReceived() {
    return plugins.length == 1
        ? plugins[0].onForegroundNotificationReceived()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<Stream<RemoteMessage>> onBackgroundNotificationReceived() {
    return plugins.length == 1
        ? plugins[0].onBackgroundNotificationReceived()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<Stream<RemoteMessage>> onNotificationOpenedApp() {
    return plugins.length == 1
        ? plugins[0].onNotificationOpenedApp()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<RemoteMessage> getInitialNotification() {
    return plugins.length == 1
        ? plugins[0].getInitialNotification()
        : throw _pluginNotAddedException('Notifications');
  }

  Future<int> getBadgeCount() {
    return plugins.length == 1
        ? plugins[0].getBadgeCount()
        : throw _pluginNotAddedException('Notifications');
  }
  
  Future<void> setBadgeCount() {
    return plugins.length == 1
        ? plugins[0].setBadgeCount()
        : throw _pluginNotAddedException('Notifications');
  }
  
}
