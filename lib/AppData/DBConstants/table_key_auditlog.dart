/*
@author     : akshayaa.p 28/06/2025
@desc       : A class that contains string constants representing the column names 
              used in the 'auditlog' table of the local SQLite database.
@params     : {String logDate}       - The date (`yyyy‑MM‑dd`) on which the log entry was written.
              {String time}          - The time (`HH:mm:ss`) at which the log entry was written.
              {String feature}       - The name of the feature or module that produced the log.
              {String logData}       - The detailed JSON or text data captured for the log entry.
              {String errorResponse} - Any error information if the operation failed; empty/null on success.
*/

import 'package:flutter/material.dart';

@immutable
class TableKeysAuditLog {
  TableKeysAuditLog._();

  static const String tableName = 'auditlog';

  static const String id = 'id';
  static const String logDate = 'log_date';
  static const String time = 'time';
  static const String feature = 'feature';
  static const String logData = 'logdata';
  static const String errorResponse = 'errorresponse';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $logDate TEXT,
      $time TEXT,
      $feature TEXT,
      $logData TEXT,
      $errorResponse TEXT
    )
  ''';
}