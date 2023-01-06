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

class RemotePushMessage {
  String? messageId;
  String? senderId;
  DateTime? sentTime;
  String? collapseKey;

  PushNotificationMessageContent? content;
  Map<String, dynamic>? data;
  Map<String, dynamic>? metadata;

  RemotePushMessage({
    this.messageId,
    this.senderId,
    this.sentTime,
    this.collapseKey,
    this.content,
    this.data,
    this.metadata,
  });

  // TODO: Find common and required fields
  RemotePushMessage.fromJson(Map<String, dynamic> json) {
    messageId = cast<String>(json['messageId']);
    senderId = cast<String>(json['senderId']);
    sentTime = cast<DateTime>(json['sentTime']);
    collapseKey = cast<String>(json['collapseKey']);
    data = cast<Map<String, dynamic>>(json['data']);

    if (json.containsKey('aps')) {
      Map<String, dynamic> alert = json['aps']['alert'] as Map<String, dynamic>;
      content = PushNotificationMessageContent<ApnsPlatformOptions>(
        title: alert['title'] as String,
        body: alert['body'] as String,
        platformOptions: ApnsPlatformOptions(
          contentAvailable: json['aps']['content-available'] as int,
        ),
      );
    } else if (data != null) {
      print('data in -> $data');
      content = PushNotificationMessageContent<FcmPlatformOptions>(
        title: data!['pinpoint.notification.title'] as String,
        body: data!['pinpoint.notification.body'] as String,
        platformOptions: FcmPlatformOptions(),
      );
    }

    metadata = cast<Map<String, Object>>(json['metadata']);
  }

  U? cast<U>(dynamic x) => x is U ? x : null;
}

class PushNotificationMessageContent<T> {
  String? title;
  String? body;
  String? imageUrl;
  T? platformOptions;
  PushNotificationMessageContent({
    this.title,
    this.body,
    this.imageUrl,
    this.platformOptions,
  });
  @override
  String toString() {
    return 'title : $title';
  }
}

class FcmPlatformOptions {
  String? channelId;
  String? color;
  String? smallIcon;
  String? tag;
  String? sound;
  FcmPlatformOptions({
    this.channelId,
    this.color,
    this.smallIcon,
    this.sound,
    this.tag,
  });
}

class ApnsPlatformOptions {
  String? subtitle;
  int? contentAvailable;
  int? mutableContent;
  String? category;
  String? threadId;

  ApnsPlatformOptions({
    this.subtitle,
    this.contentAvailable,
    this.mutableContent,
    this.category,
    this.threadId,
  });
}
