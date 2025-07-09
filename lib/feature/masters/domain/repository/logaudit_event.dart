/*
@author     : akshayaa.p
@createdOn  : 28/06/2025
@desc       : Generic helper that writes an audit‑log entry to the local SQLite database.
*/

import 'dart:convert';
import 'package:newsee/feature/masters/domain/modal/auditlog.dart';
import 'package:newsee/feature/masters/domain/repository/auditlog_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

Future<void> logAuditEvent({
  required Database db,
  required String feature,                
  required Map<String, dynamic> payload,  
  String? error,                       
}) async {
  final repo = AuditLogCrudRepo(db);
  final now  = DateTime.now();

  await repo.save(
    AuditLog(
      logDate: '${now.day.toString().padLeft(2, '0')}-'
               '${now.month.toString().padLeft(2, '0')}-'
               '${now.year}',
      time:    '${now.hour.toString().padLeft(2, '0')}:'
               '${now.minute.toString().padLeft(2, '0')}',
      feature: feature,
      logdata: jsonEncode(payload),
      errorresponse: error,
    ),
  );
}
