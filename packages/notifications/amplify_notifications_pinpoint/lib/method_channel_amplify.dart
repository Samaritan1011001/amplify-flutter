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

import '../amplify_notifications_pinpoint.dart';

const MethodChannel _channel =
    MethodChannel('com.amazonaws.amplify/analytics_pinpoint');

class AmplifyNotificationsPinpointMethodChannel extends AmplifyNotificaitonsPinpoint {
  AmplifyNotificationsPinpointMethodChannel() : super.protected();
  @override
  Future<void> addPlugin() async {
    try {
      return await _channel.invokeMethod('addPlugin');
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

  @override
  Future<void> registerForRemoteNotifications() async {
    await _channel.invokeMethod<bool>(
      'registerForRemoteNotifications'
    );
  }

  @override
  Future<void> promptUserPermission() async {
    await _channel.invokeMethod<bool>('promptUserPermission');
  }

  // @override
  // Future<Stream<String>> onNewToken() async {
  //   return await _channel.invokeMethod<bool>('promptUserPermission');
  // }

}
