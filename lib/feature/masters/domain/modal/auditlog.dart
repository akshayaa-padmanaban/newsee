import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'auditlog.g.dart';

@JsonSerializable()

class AuditLog {
  final int? id;
  final String logDate;        
  final String time;           
  final String feature;
  final String logdata;
  final String? errorresponse;

  AuditLog({
    this.id,
    required this.logDate,
    required this.time,
    required this.feature,
    required this.logdata,
    this.errorresponse,
  });

  AuditLog copyWith({
    int? id,
    String? logDate,
    String? time,
    String? feature,
    String? logdata,
    String? errorresponse,
  }) {
    return AuditLog(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      time: time ?? this.time,
      feature: feature ?? this.feature,
      logdata: logdata ?? this.logdata,
      errorresponse: errorresponse ?? this.errorresponse,
    );
  }

  Map<String, dynamic> toMap() => {
        'id' : id,
        'log_date' : logDate,
        'time' : time,
        'feature' : feature,
        'logdata' : logdata,
        'errorresponse' : errorresponse,
      };

  factory AuditLog.fromMap(Map<String, dynamic> map) => AuditLog(
        id : map['id'] as int?,
        logDate : map['log_date'] as String,
        time : map['time'] as String,
        feature : map['feature'] as String,
        logdata : map['logdata'] as String,
        errorresponse : map['errorresponse'] as String?,
      );

  String toJson() => json.encode(toMap());
  factory AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);

  @override
  String toString() => 'AuditLog($id, $logDate $time, $feature)';
}
