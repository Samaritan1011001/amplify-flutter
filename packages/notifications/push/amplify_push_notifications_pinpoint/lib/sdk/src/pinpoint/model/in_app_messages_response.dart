// Generated with smithy-dart 0.5.2. DO NOT MODIFY.

library amplify_push_notifications_pinpoint.pinpoint.model.in_app_messages_response;

import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/in_app_message_campaign.dart'
    as _i3;
import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_collection/built_collection.dart' as _i2;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i4;

part 'in_app_messages_response.g.dart';

/// Get in-app messages response object.
abstract class InAppMessagesResponse
    with _i1.AWSEquatable<InAppMessagesResponse>
    implements Built<InAppMessagesResponse, InAppMessagesResponseBuilder> {
  /// Get in-app messages response object.
  factory InAppMessagesResponse(
      {_i2.BuiltList<_i3.InAppMessageCampaign>? inAppMessageCampaigns}) {
    return _$InAppMessagesResponse._(
        inAppMessageCampaigns: inAppMessageCampaigns);
  }

  /// Get in-app messages response object.
  factory InAppMessagesResponse.build(
          [void Function(InAppMessagesResponseBuilder) updates]) =
      _$InAppMessagesResponse;

  const InAppMessagesResponse._();

  static const List<_i4.SmithySerializer> serializers = [
    _InAppMessagesResponseRestJson1Serializer()
  ];

  @BuiltValueHook(initializeBuilder: true)
  static void _init(InAppMessagesResponseBuilder b) {}

  /// List of targeted in-app message campaigns.
  _i2.BuiltList<_i3.InAppMessageCampaign>? get inAppMessageCampaigns;
  @override
  List<Object?> get props => [inAppMessageCampaigns];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('InAppMessagesResponse');
    helper.add('inAppMessageCampaigns', inAppMessageCampaigns);
    return helper.toString();
  }
}

class _InAppMessagesResponseRestJson1Serializer
    extends _i4.StructuredSmithySerializer<InAppMessagesResponse> {
  const _InAppMessagesResponseRestJson1Serializer()
      : super('InAppMessagesResponse');

  @override
  Iterable<Type> get types =>
      const [InAppMessagesResponse, _$InAppMessagesResponse];
  @override
  Iterable<_i4.ShapeId> get supportedProtocols =>
      const [_i4.ShapeId(namespace: 'aws.protocols', shape: 'restJson1')];
  @override
  InAppMessagesResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = InAppMessagesResponseBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      switch (key) {
        case 'InAppMessageCampaigns':
          if (value != null) {
            result.inAppMessageCampaigns.replace((serializers.deserialize(value,
                    specifiedType: const FullType(
                        _i2.BuiltList, [FullType(_i3.InAppMessageCampaign)]))
                as _i2.BuiltList<_i3.InAppMessageCampaign>));
          }
          break;
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(Serializers serializers, Object? object,
      {FullType specifiedType = FullType.unspecified}) {
    final payload = (object as InAppMessagesResponse);
    final result = <Object?>[];
    if (payload.inAppMessageCampaigns != null) {
      result
        ..add('InAppMessageCampaigns')
        ..add(serializers.serialize(payload.inAppMessageCampaigns!,
            specifiedType: const FullType(
                _i2.BuiltList, [FullType(_i3.InAppMessageCampaign)])));
    }
    return result;
  }
}
