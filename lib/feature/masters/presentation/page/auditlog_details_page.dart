import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsee/feature/masters/domain/modal/auditlog.dart';

class AuditLogDetailPage extends StatelessWidget {
  final AuditLog log;

  const AuditLogDetailPage({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> logJson = {};
    try {
      logJson = json.decode(log.logdata);
    } catch (_) {}

    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          border: TableBorder.all(),
          children: logJson.entries.map((entry) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(entry.value.toString()),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
