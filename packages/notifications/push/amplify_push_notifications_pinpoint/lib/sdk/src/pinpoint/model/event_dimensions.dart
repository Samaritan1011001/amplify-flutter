// Generated with smithy-dart 0.5.2. DO NOT MODIFY.

library amplify_push_notifications_pinpoint.pinpoint.model.event_dimensions;

import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/attribute_dimension.dart'
    as _i3;
import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/metric_dimension.dart'
    as _i5;
import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/set_dimension.dart'
    as _i4;
import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_collection/built_collection.dart' as _i2;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i6;

part 'event_dimensions.g.dart';

/// Specifies the dimensions for an event filter that determines when a campaign is sent or a journey activity is performed.
abstract class EventDimensions
    with _i1.AWSEquatable<EventDimensions>
    implements Built<EventDimensions, EventDimensionsBuilder> {
  /// Specifies the dimensions for an event filter that determines when a campaign is sent or a journey activity is performed.
  factory EventDimensions(
      {_i2.BuiltMap<String, _i3.AttributeDimension>? attributes,
      _i4.SetDimension? eventType,
      _i2.BuiltMap<String, _i5.MetricDimension>? metrics}) {
    return _$EventDimensions._(
        attributes: attributes, eventType: eventType, metrics: metrics);
  }

  /// Specifies the dimensions for an event filter that determines when a campaign is sent or a journey activity is performed.
  factory EventDimensions.build(
      [void Function(EventDimensionsBuilder) updates]) = _$EventDimensions;

  const EventDimensions._();

  static const List<_i6.SmithySerializer> serializers = [
    _EventDimensionsRestJson1Serializer()
  ];

  @BuiltValueHook(initializeBuilder: true)
  static void _init(EventDimensionsBuilder b) {}

  /// One or more custom attributes that your application reports to Amazon Pinpoint. You can use these attributes as selection criteria when you create an event filter.
  _i2.BuiltMap<String, _i3.AttributeDimension>? get attributes;

  /// The name of the event that causes the campaign to be sent or the journey activity to be performed. This can be a standard event that Amazon Pinpoint generates, such as _email.delivered. For campaigns, this can also be a custom event that's specific to your application. For information about standard events, see [Streaming Amazon Pinpoint Events](https://docs.aws.amazon.com/pinpoint/latest/developerguide/event-streams.html) in the _Amazon Pinpoint Developer Guide_.
  _i4.SetDimension? get eventType;

  /// One or more custom metrics that your application reports to Amazon Pinpoint. You can use these metrics as selection criteria when you create an event filter.
  _i2.BuiltMap<String, _i5.MetricDimension>? get metrics;
  @override
  List<Object?> get props => [attributes, eventType, metrics];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('EventDimensions');
    helper.add('attributes', attributes);
    helper.add('eventType', eventType);
    helper.add('metrics', metrics);
    return helper.toString();
  }
}

class _EventDimensionsRestJson1Serializer
    extends _i6.StructuredSmithySerializer<EventDimensions> {
  const _EventDimensionsRestJson1Serializer() : super('EventDimensions');

  @override
  Iterable<Type> get types => const [EventDimensions, _$EventDimensions];
  @override
  Iterable<_i6.ShapeId> get supportedProtocols =>
      const [_i6.ShapeId(namespace: 'aws.protocols', shape: 'restJson1')];
  @override
  EventDimensions deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = EventDimensionsBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      switch (key) {
        case 'Attributes':
          if (value != null) {
            result.attributes.replace((serializers.deserialize(value,
                specifiedType: const FullType(_i2.BuiltMap, [
                  FullType(String),
                  FullType(_i3.AttributeDimension)
                ])) as _i2.BuiltMap<String, _i3.AttributeDimension>));
          }
          break;
        case 'EventType':
          if (value != null) {
            result.eventType.replace((serializers.deserialize(value,
                    specifiedType: const FullType(_i4.SetDimension))
                as _i4.SetDimension));
          }
          break;
        case 'Metrics':
          if (value != null) {
            result.metrics.replace((serializers.deserialize(value,
                specifiedType: const FullType(_i2.BuiltMap, [
                  FullType(String),
                  FullType(_i5.MetricDimension)
                ])) as _i2.BuiltMap<String, _i5.MetricDimension>));
          }
          break;
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(Serializers serializers, Object? object,
      {FullType specifiedType = FullType.unspecified}) {
    final payload = (object as EventDimensions);
    final result = <Object?>[];
    if (payload.attributes != null) {
      result
        ..add('Attributes')
        ..add(serializers.serialize(payload.attributes!,
            specifiedType: const FullType(_i2.BuiltMap,
                [FullType(String), FullType(_i3.AttributeDimension)])));
    }
    if (payload.eventType != null) {
      result
        ..add('EventType')
        ..add(serializers.serialize(payload.eventType!,
            specifiedType: const FullType(_i4.SetDimension)));
    }
    if (payload.metrics != null) {
      result
        ..add('Metrics')
        ..add(serializers.serialize(payload.metrics!,
            specifiedType: const FullType(_i2.BuiltMap,
                [FullType(String), FullType(_i5.MetricDimension)])));
    }
    return result;
  }
}
