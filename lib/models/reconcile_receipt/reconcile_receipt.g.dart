// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconcile_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReconciliationReciept _$$_ReconciliationRecieptFromJson(Map json) =>
    _$_ReconciliationReciept(
      id: json['id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      is_balanced: LabelField<bool>.fromJson(
          Map<String, dynamic>.from(json['is_balanced'] as Map)),
      details: ReconciliationDetails.fromJson(
          Map<String, dynamic>.from(json['details'] as Map)),
      schemes: (json['schemes'] as List<dynamic>)
          .map((e) => ReconciliationSchemes.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      currency: LocalizationField.fromJson(
          Map<String, dynamic>.from(json['currency'] as Map)),
      qr_code: json['qr_code'] as String,
      merchant:
          Merchant.fromJson(Map<String, dynamic>.from(json['merchant'] as Map)),
      tid: json['card_acceptor_terminal_id'] as String?,
      system_trace_audit_number: json['system_trace_audit_number'] as String,
      pos_software_version_number:
          json['pos_software_version_number'] as String,
    );

Map<String, dynamic> _$$_ReconciliationRecieptToJson(
        _$_ReconciliationReciept instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'time': instance.time,
      'is_balanced': instance.is_balanced.toJson(),
      'details': instance.details.toJson(),
      'schemes': instance.schemes.map((e) => e.toJson()).toList(),
      'currency': instance.currency.toJson(),
      'qr_code': instance.qr_code,
      'merchant': instance.merchant.toJson(),
      'card_acceptor_terminal_id': instance.tid,
      'system_trace_audit_number': instance.system_trace_audit_number,
      'pos_software_version_number': instance.pos_software_version_number,
    };

_$_ReconciliationDetails _$$_ReconciliationDetailsFromJson(Map json) =>
    _$_ReconciliationDetails(
      purchase: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['purchase'] as Map)),
      refund: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['refund'] as Map)),
      purchase_reversal: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['purchase_reversal'] as Map)),
      refund_reversal: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['refund_reversal'] as Map)),
      total: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['total'] as Map)),
    );

Map<String, dynamic> _$$_ReconciliationDetailsToJson(
        _$_ReconciliationDetails instance) =>
    <String, dynamic>{
      'purchase': instance.purchase.toJson(),
      'refund': instance.refund.toJson(),
      'purchase_reversal': instance.purchase_reversal.toJson(),
      'refund_reversal': instance.refund_reversal.toJson(),
      'total': instance.total.toJson(),
    };

_$_ReconciliationSchemes _$$_ReconciliationSchemesFromJson(Map json) =>
    _$_ReconciliationSchemes(
      name: LabelField<String>.fromJson(
          Map<String, dynamic>.from(json['name'] as Map)),
      pos: ReconciliationSchemesDetails.fromJson(
          Map<String, dynamic>.from(json['pos'] as Map)),
      host: ReconciliationSchemesDetails.fromJson(
          Map<String, dynamic>.from(json['host'] as Map)),
    );

Map<String, dynamic> _$$_ReconciliationSchemesToJson(
        _$_ReconciliationSchemes instance) =>
    <String, dynamic>{
      'name': instance.name.toJson(),
      'pos': instance.pos.toJson(),
      'host': instance.host.toJson(),
    };

_$_ReconciliationSchemesDetails _$$_ReconciliationSchemesDetailsFromJson(
        Map json) =>
    _$_ReconciliationSchemesDetails(
      debit: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['debit'] as Map)),
      credit: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['credit'] as Map)),
      total: ReconciliationLabelField.fromJson(
          Map<String, dynamic>.from(json['total'] as Map)),
    );

Map<String, dynamic> _$$_ReconciliationSchemesDetailsToJson(
        _$_ReconciliationSchemesDetails instance) =>
    <String, dynamic>{
      'debit': instance.debit.toJson(),
      'credit': instance.credit.toJson(),
      'total': instance.total.toJson(),
    };

_$_ReconciliationLabelField _$$_ReconciliationLabelFieldFromJson(Map json) =>
    _$_ReconciliationLabelField(
      label: LocalizationField.fromJson(
          Map<String, dynamic>.from(json['label'] as Map)),
      total: json['total'] as String,
      count: (json['count'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ReconciliationLabelFieldToJson(
        _$_ReconciliationLabelField instance) =>
    <String, dynamic>{
      'label': instance.label.toJson(),
      'total': instance.total,
      'count': instance.count,
    };
