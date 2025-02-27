// GENERATED CODE - DO NOT MODIFY BY HAND

part of amplify_push_notifications_pinpoint.pinpoint.model.item_response;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemResponse extends ItemResponse {
  @override
  final _i2.EndpointItemResponse? endpointItemResponse;
  @override
  final _i3.BuiltMap<String, _i4.EventItemResponse>? eventsItemResponse;

  factory _$ItemResponse([void Function(ItemResponseBuilder)? updates]) =>
      (new ItemResponseBuilder()..update(updates))._build();

  _$ItemResponse._({this.endpointItemResponse, this.eventsItemResponse})
      : super._();

  @override
  ItemResponse rebuild(void Function(ItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemResponseBuilder toBuilder() => new ItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemResponse &&
        endpointItemResponse == other.endpointItemResponse &&
        eventsItemResponse == other.eventsItemResponse;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(0, endpointItemResponse.hashCode), eventsItemResponse.hashCode));
  }
}

class ItemResponseBuilder
    implements Builder<ItemResponse, ItemResponseBuilder> {
  _$ItemResponse? _$v;

  _i2.EndpointItemResponseBuilder? _endpointItemResponse;
  _i2.EndpointItemResponseBuilder get endpointItemResponse =>
      _$this._endpointItemResponse ??= new _i2.EndpointItemResponseBuilder();
  set endpointItemResponse(
          _i2.EndpointItemResponseBuilder? endpointItemResponse) =>
      _$this._endpointItemResponse = endpointItemResponse;

  _i3.MapBuilder<String, _i4.EventItemResponse>? _eventsItemResponse;
  _i3.MapBuilder<String, _i4.EventItemResponse> get eventsItemResponse =>
      _$this._eventsItemResponse ??=
          new _i3.MapBuilder<String, _i4.EventItemResponse>();
  set eventsItemResponse(
          _i3.MapBuilder<String, _i4.EventItemResponse>? eventsItemResponse) =>
      _$this._eventsItemResponse = eventsItemResponse;

  ItemResponseBuilder() {
    ItemResponse._init(this);
  }

  ItemResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _endpointItemResponse = $v.endpointItemResponse?.toBuilder();
      _eventsItemResponse = $v.eventsItemResponse?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ItemResponse;
  }

  @override
  void update(void Function(ItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemResponse build() => _build();

  _$ItemResponse _build() {
    _$ItemResponse _$result;
    try {
      _$result = _$v ??
          new _$ItemResponse._(
              endpointItemResponse: _endpointItemResponse?.build(),
              eventsItemResponse: _eventsItemResponse?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'endpointItemResponse';
        _endpointItemResponse?.build();
        _$failedField = 'eventsItemResponse';
        _eventsItemResponse?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
