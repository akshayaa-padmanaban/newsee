import 'package:flutter/material.dart';

enum FormStatus { none, pending, completed }

class StatusPill extends StatelessWidget {
  final FormStatus formStatus;

  const StatusPill({super.key, required this.formStatus});

  @override
  Widget build(BuildContext context) {
    if (formStatus == FormStatus.none) return const SizedBox.shrink();

    final bool isCompleted = formStatus == FormStatus.completed;
    final Color backgroundColor = isCompleted ? Colors.green : Colors.orange;
    final IconData iconData = isCompleted ? Icons.check : Icons.close;
    final String label = isCompleted ? 'Completed' : 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
           BoxShadow(color: Colors.grey, blurRadius: 10)
      ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 8, 
            backgroundColor: Colors.white,
            child: Icon(
              iconData,
              size: 12, 
              color: backgroundColor,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12, 
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
