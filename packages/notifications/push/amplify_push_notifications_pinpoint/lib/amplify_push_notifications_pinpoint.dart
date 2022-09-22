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

library amplify_push_notifications_pinpoint;

import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:meta/meta.dart';

import 'method_channel_amplify.dart';


/// {@template amplify_analytics_pinpoint.amplify_analytics_pinpoint}
/// The AWS Pinpoint implementation of the Amplify Analytics category.
/// {@endtemplate}
abstract class AmplifyPushNotificaitonsPinpoint extends NotificationsPluginInterface {
  /// {@macro amplify_analytics_pinpoint.amplify_analytics_pinpoint}
  factory AmplifyPushNotificaitonsPinpoint() {
    if (zIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      throw UnsupportedError('This platform is not supported yet');
    }
    return AmplifyNotificationsPinpointMethodChannel();
  }

  /// Protected constructor for subclasses.
  @protected
  AmplifyPushNotificaitonsPinpoint.protected();
}
