// Generated with smithy-dart 0.5.2. DO NOT MODIFY.

library amplify_push_notifications_pinpoint.pinpoint.model.internal_server_error_exception;

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i2;

part 'internal_server_error_exception.g.dart';

/// Provides information about an API request or response.
abstract class InternalServerErrorException
    with
        _i1.AWSEquatable<InternalServerErrorException>
    implements
        Built<InternalServerErrorException,
            InternalServerErrorExceptionBuilder>,
        _i2.SmithyHttpException {
  /// Provides information about an API request or response.
  factory InternalServerErrorException({String? message, String? requestId}) {
    return _$InternalServerErrorException._(
        message: message, requestId: requestId);
  }

  /// Provides information about an API request or response.
  factory InternalServerErrorException.build(
          [void Function(InternalServerErrorExceptionBuilder) updates]) =
      _$InternalServerErrorException;

  const InternalServerErrorException._();

  /// Constructs a [InternalServerErrorException] from a [payload] and [response].
  factory InternalServerErrorException.fromResponse(
          InternalServerErrorException payload,
          _i1.AWSBaseHttpResponse response) =>
      payload.rebuild((b) {
        b.headers = response.headers;
      });

  static const List<_i2.SmithySerializer> serializers = [
    _InternalServerErrorExceptionRestJson1Serializer()
  ];

  @BuiltValueHook(initializeBuilder: true)
  static void _init(InternalServerErrorExceptionBuilder b) {}

  /// The message that's returned from the API.
  @override
  String? get message;

  /// The unique identifier for the request or response.
  String? get requestId;
  @override
  _i2.ShapeId get shapeId => const _i2.ShapeId(
      namespace: 'com.amazonaws.pinpoint',
      shape: 'InternalServerErrorException');
  @override
  _i2.RetryConfig? get retryConfig => null;
  @override
  @BuiltValueField(compare: false)
  int get statusCode => 500;
  @override
  @BuiltValueField(compare: false)
  Map<String, String>? get headers;
  @override
  Exception? get underlyingException => null;
  @override
  List<Object?> get props => [message, requestId];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('InternalServerErrorException');
    helper.add('message', message);
    helper.add('requestId', requestId);
    return helper.toString();
  }
}

class _InternalServerErrorExceptionRestJson1Serializer
    extends _i2.StructuredSmithySerializer<InternalServerErrorException> {
  const _InternalServerErrorExceptionRestJson1Serializer()
      : super('InternalServerErrorException');

  @override
  Iterable<Type> get types =>
      const [InternalServerErrorException, _$InternalServerErrorException];
  @override
  Iterable<_i2.ShapeId> get supportedProtocols =>
      const [_i2.ShapeId(namespace: 'aws.protocols', shape: 'restJson1')];
  @override
  InternalServerErrorException deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = InternalServerErrorExceptionBuilder();
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
        case 'RequestID':
          if (value != null) {
            result.requestId = (serializers.deserialize(value,
                specifiedType: const FullType(String)) as String);
          }
          break;
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(Serializers serializers, Object? object,
      {FullType specifiedType = FullType.unspecified}) {
    final payload = (object as InternalServerErrorException);
    final result = <Object?>[];
    if (payload.message != null) {
      result
        ..add('Message')
        ..add(serializers.serialize(payload.message!,
            specifiedType: const FullType(String)));
    }
    if (payload.requestId != null) {
      result
        ..add('RequestID')
        ..add(serializers.serialize(payload.requestId!,
            specifiedType: const FullType(String)));
    }
    return result;
  }
}
