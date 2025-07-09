/*
@author     : akshayaa.p
@createdOn  : 28/06/2025
@desc       : Logs audit entries related to the master download lifecycle, including 
              table deletion, API request and data insertion. 
              It captures timestamp, feature name and status info in the local SQLite database.
@params     : {Database db}         - The SQLite database instance used for saving the log.
              {String masterName}   - The name of the master table being acted upon.
              {AuditLogger stage}   - The current audit stage (tableDelete, apiRequest, tableInsert).
              {int? rowCount}       - Used only during tableInsert to log number of inserted rows.
              {String? error}       - Error message to store if the operation fails.
*/

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:newsee/feature/masters/domain/modal/auditlog.dart';
import 'package:newsee/feature/masters/domain/repository/auditlog_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

enum AuditLogger { apiRequest, tableInsert }

Future<void> logMasterAudit({
  required Database db,
  required String masterName,  
  required AuditLogger stage,
  int? rowCount,               
  String? error,                  
}) async {
  final repo = AuditLogCrudRepo(db);
  final now = DateTime.now();

  const page = 'masterdownload';
  const feature = 'masterdownload';
  final request = stage == AuditLogger.apiRequest ? 'apirequest' : '';

  final prefix = stage == AuditLogger.apiRequest ? 'api' : 'tableinsert';
  final action = '$prefix-$masterName';

  final data = (stage == AuditLogger.tableInsert && rowCount != null)
      ? 'rows=$rowCount'
      : '';

  await repo.save(
    AuditLog(
      logDate: DateFormat('dd-MM-yyyy').format(now),
      time: DateFormat('HH:mm').format(now),
      feature: feature,
      logdata: jsonEncode({
        'page': page,
        'request': request,
        'action': action,
        'data': data,
      }),
      errorresponse: error,
    ),
  );
}