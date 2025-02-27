// GENERATED CODE - DO NOT MODIFY BY HAND

part of amplify_push_notifications_pinpoint.pinpoint.model.update_endpoints_batch_response;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateEndpointsBatchResponse extends UpdateEndpointsBatchResponse {
  @override
  final _i3.MessageBody messageBody;

  factory _$UpdateEndpointsBatchResponse(
          [void Function(UpdateEndpointsBatchResponseBuilder)? updates]) =>
      (new UpdateEndpointsBatchResponseBuilder()..update(updates))._build();

  _$UpdateEndpointsBatchResponse._({required this.messageBody}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        messageBody, r'UpdateEndpointsBatchResponse', 'messageBody');
  }

  @override
  UpdateEndpointsBatchResponse rebuild(
          void Function(UpdateEndpointsBatchResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateEndpointsBatchResponseBuilder toBuilder() =>
      new UpdateEndpointsBatchResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateEndpointsBatchResponse &&
        messageBody == other.messageBody;
  }

  @override
  int get hashCode {
    return $jf($jc(0, messageBody.hashCode));
  }
}

class UpdateEndpointsBatchResponseBuilder
    implements
        Builder<UpdateEndpointsBatchResponse,
            UpdateEndpointsBatchResponseBuilder> {
  _$UpdateEndpointsBatchResponse? _$v;

  _i3.MessageBodyBuilder? _messageBody;
  _i3.MessageBodyBuilder get messageBody =>
      _$this._messageBody ??= new _i3.MessageBodyBuilder();
  set messageBody(_i3.MessageBodyBuilder? messageBody) =>
      _$this._messageBody = messageBody;

  UpdateEndpointsBatchResponseBuilder() {
    UpdateEndpointsBatchResponse._init(this);
  }

  UpdateEndpointsBatchResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageBody = $v.messageBody.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateEndpointsBatchResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateEndpointsBatchResponse;
  }

  @override
  void update(void Function(UpdateEndpointsBatchResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateEndpointsBatchResponse build() => _build();

  _$UpdateEndpointsBatchResponse _build() {
    _$UpdateEndpointsBatchResponse _$result;
    try {
      _$result = _$v ??
          new _$UpdateEndpointsBatchResponse._(
              messageBody: messageBody.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messageBody';
        messageBody.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateEndpointsBatchResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
