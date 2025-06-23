
/*
  @author     : akshayaa.p
  @date       : 19/06/2025
  @desc       : Reusable stateless widget used to display an action tile in a bottom sheet.
                - Optionally shows a status pill on the trailing side.
                - Status pill changes color based on completion:
                    - Green for 'Completed'
                    - Red for 'Pending'
                - Tapping the tile triggers the onTap callback.
*/


import 'package:flutter/material.dart';

class OptionsSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String subtitle;
  final String? status;

  const OptionsSheet({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.subtitle,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status?.toLowerCase() == 'completed';

    return ListTile(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTap();
      },
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: status != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            )
          : null,
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade200),
      ),
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
