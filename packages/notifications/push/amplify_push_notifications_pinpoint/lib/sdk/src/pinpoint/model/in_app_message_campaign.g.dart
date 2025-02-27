// GENERATED CODE - DO NOT MODIFY BY HAND

part of amplify_push_notifications_pinpoint.pinpoint.model.in_app_message_campaign;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InAppMessageCampaign extends InAppMessageCampaign {
  @override
  final String? campaignId;
  @override
  final int? dailyCap;
  @override
  final _i2.InAppMessage? inAppMessage;
  @override
  final int? priority;
  @override
  final _i3.InAppCampaignSchedule? schedule;
  @override
  final int? sessionCap;
  @override
  final int? totalCap;
  @override
  final String? treatmentId;

  factory _$InAppMessageCampaign(
          [void Function(InAppMessageCampaignBuilder)? updates]) =>
      (new InAppMessageCampaignBuilder()..update(updates))._build();

  _$InAppMessageCampaign._(
      {this.campaignId,
      this.dailyCap,
      this.inAppMessage,
      this.priority,
      this.schedule,
      this.sessionCap,
      this.totalCap,
      this.treatmentId})
      : super._();

  @override
  InAppMessageCampaign rebuild(
          void Function(InAppMessageCampaignBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InAppMessageCampaignBuilder toBuilder() =>
      new InAppMessageCampaignBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InAppMessageCampaign &&
        campaignId == other.campaignId &&
        dailyCap == other.dailyCap &&
        inAppMessage == other.inAppMessage &&
        priority == other.priority &&
        schedule == other.schedule &&
        sessionCap == other.sessionCap &&
        totalCap == other.totalCap &&
        treatmentId == other.treatmentId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, campaignId.hashCode), dailyCap.hashCode),
                            inAppMessage.hashCode),
                        priority.hashCode),
                    schedule.hashCode),
                sessionCap.hashCode),
            totalCap.hashCode),
        treatmentId.hashCode));
  }
}

class InAppMessageCampaignBuilder
    implements Builder<InAppMessageCampaign, InAppMessageCampaignBuilder> {
  _$InAppMessageCampaign? _$v;

  String? _campaignId;
  String? get campaignId => _$this._campaignId;
  set campaignId(String? campaignId) => _$this._campaignId = campaignId;

  int? _dailyCap;
  int? get dailyCap => _$this._dailyCap;
  set dailyCap(int? dailyCap) => _$this._dailyCap = dailyCap;

  _i2.InAppMessageBuilder? _inAppMessage;
  _i2.InAppMessageBuilder get inAppMessage =>
      _$this._inAppMessage ??= new _i2.InAppMessageBuilder();
  set inAppMessage(_i2.InAppMessageBuilder? inAppMessage) =>
      _$this._inAppMessage = inAppMessage;

  int? _priority;
  int? get priority => _$this._priority;
  set priority(int? priority) => _$this._priority = priority;

  _i3.InAppCampaignScheduleBuilder? _schedule;
  _i3.InAppCampaignScheduleBuilder get schedule =>
      _$this._schedule ??= new _i3.InAppCampaignScheduleBuilder();
  set schedule(_i3.InAppCampaignScheduleBuilder? schedule) =>
      _$this._schedule = schedule;

  int? _sessionCap;
  int? get sessionCap => _$this._sessionCap;
  set sessionCap(int? sessionCap) => _$this._sessionCap = sessionCap;

  int? _totalCap;
  int? get totalCap => _$this._totalCap;
  set totalCap(int? totalCap) => _$this._totalCap = totalCap;

  String? _treatmentId;
  String? get treatmentId => _$this._treatmentId;
  set treatmentId(String? treatmentId) => _$this._treatmentId = treatmentId;

  InAppMessageCampaignBuilder() {
    InAppMessageCampaign._init(this);
  }

  InAppMessageCampaignBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _campaignId = $v.campaignId;
      _dailyCap = $v.dailyCap;
      _inAppMessage = $v.inAppMessage?.toBuilder();
      _priority = $v.priority;
      _schedule = $v.schedule?.toBuilder();
      _sessionCap = $v.sessionCap;
      _totalCap = $v.totalCap;
      _treatmentId = $v.treatmentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InAppMessageCampaign other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InAppMessageCampaign;
  }

  @override
  void update(void Function(InAppMessageCampaignBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InAppMessageCampaign build() => _build();

  _$InAppMessageCampaign _build() {
    _$InAppMessageCampaign _$result;
    try {
      _$result = _$v ??
          new _$InAppMessageCampaign._(
              campaignId: campaignId,
              dailyCap: dailyCap,
              inAppMessage: _inAppMessage?.build(),
              priority: priority,
              schedule: _schedule?.build(),
              sessionCap: sessionCap,
              totalCap: totalCap,
              treatmentId: treatmentId);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'inAppMessage';
        _inAppMessage?.build();

        _$failedField = 'schedule';
        _schedule?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'InAppMessageCampaign', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
