// GENERATED CODE - DO NOT MODIFY BY HAND

part of amplify_push_notifications_pinpoint.pinpoint.model.method_not_allowed_exception;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MethodNotAllowedException extends MethodNotAllowedException {
  @override
  final String? message;
  @override
  final String? requestId;
  @override
  final Map<String, String>? headers;

  factory _$MethodNotAllowedException(
          [void Function(MethodNotAllowedExceptionBuilder)? updates]) =>
      (new MethodNotAllowedExceptionBuilder()..update(updates))._build();

  _$MethodNotAllowedException._({this.message, this.requestId, this.headers})
      : super._();

  @override
  MethodNotAllowedException rebuild(
          void Function(MethodNotAllowedExceptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MethodNotAllowedExceptionBuilder toBuilder() =>
      new MethodNotAllowedExceptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MethodNotAllowedException &&
        message == other.message &&
        requestId == other.requestId;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, message.hashCode), requestId.hashCode));
  }
}

class MethodNotAllowedExceptionBuilder
    implements
        Builder<MethodNotAllowedException, MethodNotAllowedExceptionBuilder> {
  _$MethodNotAllowedException? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(String? requestId) => _$this._requestId = requestId;

  Map<String, String>? _headers;
  Map<String, String>? get headers => _$this._headers;
  set headers(Map<String, String>? headers) => _$this._headers = headers;

  MethodNotAllowedExceptionBuilder() {
    MethodNotAllowedException._init(this);
  }

  MethodNotAllowedExceptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _requestId = $v.requestId;
      _headers = $v.headers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MethodNotAllowedException other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MethodNotAllowedException;
  }

  @override
  void update(void Function(MethodNotAllowedExceptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MethodNotAllowedException build() => _build();

  _$MethodNotAllowedException _build() {
    final _$result = _$v ??
        new _$MethodNotAllowedException._(
            message: message, requestId: requestId, headers: headers);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
