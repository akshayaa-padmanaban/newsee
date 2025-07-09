import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onSelectDateRange;
  final List<String> features;
  final String? selectedFeature;
  final ValueChanged<String?> onFeatureChanged;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const FilterSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onSelectDateRange,
    required this.features,
    required this.selectedFeature,
    required this.onFeatureChanged,
    this.padding = const EdgeInsets.all(8.0),
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Padding(
      padding: padding,
      child: Wrap(
        spacing: spacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onSelectDateRange,
            child: Text(
              startDate != null && endDate != null
                  ? "${dateFormat.format(startDate!)} → ${dateFormat.format(endDate!)}"
                  : 'Select Date Range',
            ),
          ),
          DropdownButton<String>(
            hint: const Text('Select Feature'),
            value: selectedFeature,
            items: features
                .map(
                  (feature) => DropdownMenuItem(
                    value: feature,
                    child: Text(feature),
                  ),
                )
                .toList(),
            onChanged: onFeatureChanged,
          ),
        ],
      ),
    );
  }
}