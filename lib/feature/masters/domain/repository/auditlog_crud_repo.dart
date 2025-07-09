import 'package:intl/intl.dart';
import 'package:newsee/AppData/DBConstants/table_key_auditlog.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/feature/masters/domain/modal/auditlog.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/simplecursor_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

class AuditLogCrudRepo extends SimpleCrudRepo<AuditLog>
    with SimplecursorCrudRepo<AuditLog> {
  final Database _db;
  AuditLogCrudRepo(this._db);

  @override
  Future<int> save(AuditLog log) async {
    return _db.insert(
      TableKeysAuditLog.tableName,
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<int> delete(AuditLog item) => throw UnimplementedError();
  @override
  Future<int> update(AuditLog item) => throw UnimplementedError();
  @override
  Future<List<AuditLog>> getById({required int id}) => throw UnimplementedError();

  @override
  Future<List<AuditLog>> getAll() async {
    final rows = await _db.query(
      TableKeysAuditLog.tableName,
      orderBy: '${TableKeysAuditLog.id} DESC',
    );
    return rows.map(AuditLog.fromMap).toList();
  }

  @override
  Future<List<AuditLog>> getByColumnName({
    required String columnName,
    required String columnValue,
  }) async {
    final rows = await _db.query(
      TableKeysAuditLog.tableName,
      where: '$columnName = ?',
      whereArgs: [columnValue],
      orderBy: '${TableKeysAuditLog.id} DESC',
    );
    return rows.map(AuditLog.fromMap).toList();
  }

  @override
  Future<List<AuditLog>> getByColumnNames({
    required List<String> columnNames,
    required List<String> columnValues,
  }) async {
    final where = queryBuilder(columnNames);
    final rows = await _db.query(
      TableKeysAuditLog.tableName,
      where: where,
      whereArgs: columnValues,
      orderBy: '${TableKeysAuditLog.id} DESC',
    );
    return rows.map(AuditLog.fromMap).toList();
  }

  Future<List<AuditLog>> getByFeature(String feature) =>
      getByColumnName(columnName: TableKeysAuditLog.feature, columnValue: feature);

  Future<List<AuditLog>> getFilteredLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? feature,
  }) async {
    final List<String> whereClauses = [];
    final List<String> args = [];
    final isoFmt = DateFormat('yyyy-MM-dd');

    if (startDate != null && endDate != null) {
      whereClauses.add('${TableKeysAuditLog.logDate} BETWEEN ? AND ?');
      args.addAll([
        isoFmt.format(startDate),
        isoFmt.format(endDate),
      ]);
    }

    if (feature != null && feature.isNotEmpty) {
      whereClauses.add('${TableKeysAuditLog.feature} = ?');
      args.add(feature);
    }

    final rows = await _db.query(
      TableKeysAuditLog.tableName,
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: '${TableKeysAuditLog.id} DESC',
    );
    return rows.map(AuditLog.fromMap).toList();
  }
  
  @override
  Future<int> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
