// Generated with smithy-dart 0.5.2. DO NOT MODIFY.

library amplify_push_notifications_pinpoint.pinpoint.model.public_endpoint;

import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/channel_type.dart'
    as _i3;
import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/endpoint_demographic.dart'
    as _i4;
import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/endpoint_location.dart'
    as _i5;
import 'package:amplify_push_notifications_pinpoint/lib/sdk/src/pinpoint/model/endpoint_user.dart'
    as _i6;
import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_collection/built_collection.dart' as _i2;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i7;

part 'public_endpoint.g.dart';

/// Specifies the properties and attributes of an endpoint that's associated with an event.
abstract class PublicEndpoint
    with _i1.AWSEquatable<PublicEndpoint>
    implements Built<PublicEndpoint, PublicEndpointBuilder> {
  /// Specifies the properties and attributes of an endpoint that's associated with an event.
  factory PublicEndpoint(
      {String? address,
      _i2.BuiltListMultimap<String, String>? attributes,
      _i3.ChannelType? channelType,
      _i4.EndpointDemographic? demographic,
      String? effectiveDate,
      String? endpointStatus,
      _i5.EndpointLocation? location,
      _i2.BuiltMap<String, double>? metrics,
      String? optOut,
      String? requestId,
      _i6.EndpointUser? user}) {
    return _$PublicEndpoint._(
        address: address,
        attributes: attributes,
        channelType: channelType,
        demographic: demographic,
        effectiveDate: effectiveDate,
        endpointStatus: endpointStatus,
        location: location,
        metrics: metrics,
        optOut: optOut,
        requestId: requestId,
        user: user);
  }

  /// Specifies the properties and attributes of an endpoint that's associated with an event.
  factory PublicEndpoint.build([void Function(PublicEndpointBuilder) updates]) =
      _$PublicEndpoint;

  const PublicEndpoint._();

  static const List<_i7.SmithySerializer> serializers = [
    _PublicEndpointRestJson1Serializer()
  ];

  @BuiltValueHook(initializeBuilder: true)
  static void _init(PublicEndpointBuilder b) {}

  /// The unique identifier for the recipient, such as a device token, email address, or mobile phone number.
  String? get address;

  /// One or more custom attributes that describe the endpoint by associating a name with an array of values. You can use these attributes as filter criteria when you create segments.
  _i2.BuiltListMultimap<String, String>? get attributes;

  /// The channel that's used when sending messages or push notifications to the endpoint.
  _i3.ChannelType? get channelType;

  /// The demographic information for the endpoint, such as the time zone and platform.
  _i4.EndpointDemographic? get demographic;

  /// The date and time, in ISO 8601 format, when the endpoint was last updated.
  String? get effectiveDate;

  /// Specifies whether to send messages or push notifications to the endpoint. Valid values are: ACTIVE, messages are sent to the endpoint; and, INACTIVE, messages aren’t sent to the endpoint.
  ///
  /// Amazon Pinpoint automatically sets this value to ACTIVE when you create an endpoint or update an existing endpoint. Amazon Pinpoint automatically sets this value to INACTIVE if you update another endpoint that has the same address specified by the Address property.
  String? get endpointStatus;

  /// The geographic information for the endpoint.
  _i5.EndpointLocation? get location;

  /// One or more custom metrics that your app reports to Amazon Pinpoint for the endpoint.
  _i2.BuiltMap<String, double>? get metrics;

  /// Specifies whether the user who's associated with the endpoint has opted out of receiving messages and push notifications from you. Possible values are: ALL, the user has opted out and doesn't want to receive any messages or push notifications; and, NONE, the user hasn't opted out and wants to receive all messages and push notifications.
  String? get optOut;

  /// A unique identifier that's generated each time the endpoint is updated.
  String? get requestId;

  /// One or more custom user attributes that your app reports to Amazon Pinpoint for the user who's associated with the endpoint.
  _i6.EndpointUser? get user;
  @override
  List<Object?> get props => [
        address,
        attributes,
        channelType,
        demographic,
        effectiveDate,
        endpointStatus,
        location,
        metrics,
        optOut,
        requestId,
        user
      ];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('PublicEndpoint');
    helper.add('address', address);
    helper.add('attributes', attributes);
    helper.add('channelType', channelType);
    helper.add('demographic', demographic);
    helper.add('effectiveDate', effectiveDate);
    helper.add('endpointStatus', endpointStatus);
    helper.add('location', location);
    helper.add('metrics', metrics);
    helper.add('optOut', optOut);
    helper.add('requestId', requestId);
    helper.add('user', user);
    return helper.toString();
  }
}

class _PublicEndpointRestJson1Serializer
    extends _i7.StructuredSmithySerializer<PublicEndpoint> {
  const _PublicEndpointRestJson1Serializer() : super('PublicEndpoint');

  @override
  Iterable<Type> get types => const [PublicEndpoint, _$PublicEndpoint];
  @override
  Iterable<_i7.ShapeId> get supportedProtocols =>
      const [_i7.ShapeId(namespace: 'aws.protocols', shape: 'restJson1')];
  @override
  PublicEndpoint deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PublicEndpointBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      switch (key) {
        case 'Address':
          if (value != null) {
            result.address = (serializers.deserialize(value,
                specifiedType: const FullType(String)) as String);
          }
          break;
        case 'Attributes':
          if (value != null) {
            result.attributes.replace((serializers.deserialize(value,
                specifiedType: const FullType(_i2.BuiltListMultimap, [
                  FullType(String),
                  FullType(String)
                ])) as _i2.BuiltListMultimap<String, String>));
          }
          break;
        case 'ChannelType':
          if (value != null) {
            result.channelType = (serializers.deserialize(value,
                    specifiedType: const FullType(_i3.ChannelType))
                as _i3.ChannelType);
          }
          break;
        case 'Demographic':
          if (value != null) {
            result.demographic.replace((serializers.deserialize(value,
                    specifiedType: const FullType(_i4.EndpointDemographic))
                as _i4.EndpointDemographic));
          }
          break;
        case 'EffectiveDate':
          if (value != null) {
            result.effectiveDate = (serializers.deserialize(value,
                specifiedType: const FullType(String)) as String);
          }
          break;
        case 'EndpointStatus':
          if (value != null) {
            result.endpointStatus = (serializers.deserialize(value,
                specifiedType: const FullType(String)) as String);
          }
          break;
        case 'Location':
          if (value != null) {
            result.location.replace((serializers.deserialize(value,
                    specifiedType: const FullType(_i5.EndpointLocation))
                as _i5.EndpointLocation));
          }
          break;
        case 'Metrics':
          if (value != null) {
            result.metrics.replace((serializers.deserialize(value,
                    specifiedType: const FullType(
                        _i2.BuiltMap, [FullType(String), FullType(double)]))
                as _i2.BuiltMap<String, double>));
          }
          break;
        case 'OptOut':
          if (value != null) {
            result.optOut = (serializers.deserialize(value,
                specifiedType: const FullType(String)) as String);
          }
          break;
        case 'RequestId':
          if (value != null) {
            result.requestId = (serializers.deserialize(value,
                specifiedType: const FullType(String)) as String);
          }
          break;
        case 'User':
          if (value != null) {
            result.user.replace((serializers.deserialize(value,
                    specifiedType: const FullType(_i6.EndpointUser))
                as _i6.EndpointUser));
          }
          break;
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(Serializers serializers, Object? object,
      {FullType specifiedType = FullType.unspecified}) {
    final payload = (object as PublicEndpoint);
    final result = <Object?>[];
    if (payload.address != null) {
      result
        ..add('Address')
        ..add(serializers.serialize(payload.address!,
            specifiedType: const FullType(String)));
    }
    if (payload.attributes != null) {
      result
        ..add('Attributes')
        ..add(serializers.serialize(payload.attributes!,
            specifiedType: const FullType(
                _i2.BuiltListMultimap, [FullType(String), FullType(String)])));
    }
    if (payload.channelType != null) {
      result
        ..add('ChannelType')
        ..add(serializers.serialize(payload.channelType!,
            specifiedType: const FullType(_i3.ChannelType)));
    }
    if (payload.demographic != null) {
      result
        ..add('Demographic')
        ..add(serializers.serialize(payload.demographic!,
            specifiedType: const FullType(_i4.EndpointDemographic)));
    }
    if (payload.effectiveDate != null) {
      result
        ..add('EffectiveDate')
        ..add(serializers.serialize(payload.effectiveDate!,
            specifiedType: const FullType(String)));
    }
    if (payload.endpointStatus != null) {
      result
        ..add('EndpointStatus')
        ..add(serializers.serialize(payload.endpointStatus!,
            specifiedType: const FullType(String)));
    }
    if (payload.location != null) {
      result
        ..add('Location')
        ..add(serializers.serialize(payload.location!,
            specifiedType: const FullType(_i5.EndpointLocation)));
    }
    if (payload.metrics != null) {
      result
        ..add('Metrics')
        ..add(serializers.serialize(payload.metrics!,
            specifiedType: const FullType(
                _i2.BuiltMap, [FullType(String), FullType(double)])));
    }
    if (payload.optOut != null) {
      result
        ..add('OptOut')
        ..add(serializers.serialize(payload.optOut!,
            specifiedType: const FullType(String)));
    }
    if (payload.requestId != null) {
      result
        ..add('RequestId')
        ..add(serializers.serialize(payload.requestId!,
            specifiedType: const FullType(String)));
    }
    if (payload.user != null) {
      result
        ..add('User')
        ..add(serializers.serialize(payload.user!,
            specifiedType: const FullType(_i6.EndpointUser)));
    }
    return result;
  }
}
