// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditlog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => AuditLog(
  id: (json['id'] as num?)?.toInt(),
  logDate: json['logDate'] as String,
  time: json['time'] as String,
  feature: json['feature'] as String,
  logdata: json['logdata'] as String,
  errorresponse: json['errorresponse'] as String?,
);

Map<String, dynamic> _$AuditLogToJson(AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'logDate': instance.logDate,
  'time': instance.time,
  'feature': instance.feature,
  'logdata': instance.logdata,
  'errorresponse': instance.errorresponse,
};
