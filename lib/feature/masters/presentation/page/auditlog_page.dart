import 'package:flutter/material.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/masters/domain/modal/auditlog.dart';
import 'package:newsee/feature/masters/domain/repository/auditlog_crud_repo.dart';
import 'package:newsee/feature/masters/presentation/page/auditlog_details_page.dart';
import 'package:newsee/widgets/filter_section.dart';

class AuditLogPage extends StatelessWidget {
  const AuditLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
        backgroundColor: Colors.teal,
      ),
      body: const AuditLogContent(),
    );
  }
}

class AuditLogContent extends StatelessWidget {
  const AuditLogContent({super.key});

  static final _dateRange = ValueNotifier<DateTimeRange?>(null);
  static final _selectedFeature = ValueNotifier<String?>(null);
  static final _logs = ValueNotifier<List<AuditLog>>([]);
  static final _isLoading = ValueNotifier<bool>(false);

  static const _features = ['Login', 'Master Download'];

  static bool _didInitialFetch = false;
  static Future<void> _fetchLogs() async {
    _isLoading.value = true;

    final db   = await DBConfig().database;
    final repo = AuditLogCrudRepo(db);

    final data = await repo.getFilteredLogs(
      startDate: _dateRange.value?.start,
      endDate  : _dateRange.value?.end,
      feature  : _selectedFeature.value,
    );

    _logs.value     = data;
    _isLoading.value = false;
  }

  static Future<void> _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate : DateTime.now(),
    );
    if (picked != null) {
      _dateRange.value = picked;
      await _fetchLogs();
    }
  }

  static bool get _hasFilter =>
      _dateRange.value != null ||
      (_selectedFeature.value?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    if (!_didInitialFetch) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _didInitialFetch = true;
        await _fetchLogs();
      });
    }

    return Column(
      children: [
        ValueListenableBuilder<DateTimeRange?>(
          valueListenable: _dateRange,
          builder: (_, range, __) {
            return ValueListenableBuilder<String?>(
              valueListenable: _selectedFeature,
              builder: (_, selected, __) {
                return FilterSection(
                  startDate: range?.start,
                  endDate  : range?.end,
                  onSelectDateRange: () => _pickDateRange(context),
                  features: _features,
                  selectedFeature: selected,
                  onFeatureChanged: (value) async {
                    _selectedFeature.value = value;
                    await _fetchLogs();
                  },
                );
              },
            );
          },
        ),
        const Divider(),

        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (_, loading, __) {
              if (loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!_hasFilter && !_didInitialFetch) {
                return const Center(child: Text('Please select a filter to view logs.'));
              }

              return ValueListenableBuilder<List<AuditLog>>(
                valueListenable: _logs,
                builder: (_, logs, __) {
                  if (logs.isEmpty) {
                    return const Center(child: Text('No logs found for selected filters.'));
                  }
                  return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (_, i) {
                      final log = logs[i];
                      return ListTile(
                        title   : Text('${log.logDate} ${log.time}'),
                        subtitle: Text(log.feature),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap   : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AuditLogDetailPage(log: log),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
