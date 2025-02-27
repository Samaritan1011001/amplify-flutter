// Generated with smithy-dart 0.5.2. DO NOT MODIFY.

library amplify_push_notifications_pinpoint.pinpoint.model.endpoint_item_response;

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i2;

part 'endpoint_item_response.g.dart';

/// Provides the status code and message that result from processing data for an endpoint.
abstract class EndpointItemResponse
    with _i1.AWSEquatable<EndpointItemResponse>
    implements Built<EndpointItemResponse, EndpointItemResponseBuilder> {
  /// Provides the status code and message that result from processing data for an endpoint.
  factory EndpointItemResponse({String? message, int? statusCode}) {
    return _$EndpointItemResponse._(message: message, statusCode: statusCode);
  }

  /// Provides the status code and message that result from processing data for an endpoint.
  factory EndpointItemResponse.build(
          [void Function(EndpointItemResponseBuilder) updates]) =
      _$EndpointItemResponse;

  const EndpointItemResponse._();

  static const List<_i2.SmithySerializer> serializers = [
    _EndpointItemResponseRestJson1Serializer()
  ];

  @BuiltValueHook(initializeBuilder: true)
  static void _init(EndpointItemResponseBuilder b) {}

  /// The custom message that's returned in the response as a result of processing the endpoint data.
  String? get message;

  /// The status code that's returned in the response as a result of processing the endpoint data.
  int? get statusCode;
  @override
  List<Object?> get props => [message, statusCode];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('EndpointItemResponse');
    helper.add('message', message);
    helper.add('statusCode', statusCode);
    return helper.toString();
  }
}

class _EndpointItemResponseRestJson1Serializer
    extends _i2.StructuredSmithySerializer<EndpointItemResponse> {
  const _EndpointItemResponseRestJson1Serializer()
      : super('EndpointItemResponse');

  @override
  Iterable<Type> get types =>
      const [EndpointItemResponse, _$EndpointItemResponse];
  @override
  Iterable<_i2.ShapeId> get supportedProtocols =>
      const [_i2.ShapeId(namespace: 'aws.protocols', shape: 'restJson1')];
  @override
  EndpointItemResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = EndpointItemResponseBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      switch (key) {
        case 'Message':
          if (value != null) {
            result.message = (serializers.deserialize(value,
                specifiedType: const FullType(String)) as String);
          }
          break;
        case 'StatusCode':
          if (value != null) {
            result.statusCode = (serializers.deserialize(value,
                specifiedType: const FullType(int)) as int);
          }
          break;
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(Serializers serializers, Object? object,
      {FullType specifiedType = FullType.unspecified}) {
    final payload = (object as EndpointItemResponse);
    final result = <Object?>[];
    if (payload.message != null) {
      result
        ..add('Message')
        ..add(serializers.serialize(payload.message!,
            specifiedType: const FullType(String)));
    }
    if (payload.statusCode != null) {
      result
        ..add('StatusCode')
        ..add(serializers.serialize(payload.statusCode!,
            specifiedType: const FullType(int)));
    }
    return result;
  }
}
