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

  Future<void> registerForRemoteNotifications() {
    throw UnimplementedError(
        'registerForRemoteNotifications() has not been implemented');
  }

  Future<void> promptUserPermission() {
    throw UnimplementedError('promptUserPermission() has not been implemented');
  }

   Future<Stream<String>> onNewToken() {
    throw UnimplementedError(
      'onNewToken() has not been implemented',
    );
  }


  Future<void> onConfigure() async {}
}
