import 'package:flutter/material.dart';

class customLead extends StatelessWidget {
  final String name;
  final String type;
  final String product;
  final String cifid;
  final String loanamount;
  final String location;
  final IconData icon;
  final Color color;

  const customLead({
    Key? key,
    required this.icon,
    this.color = Colors.teal,
    required this.name,
    required this.type,
    required this.product,
    required this.cifid,
    required this.loanamount,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label(Icons.face, "Name", name),
            label(Icons.person, "Type", type),
            label(Icons.badge, "Product", product),
            label(Icons.credit_card, "CIF ID", cifid),
            label(Icons.currency_rupee, "Loan Amount", loanamount),
            label(Icons.location_on, "Location", location),
          ],
        ),
      ),
    );
  }

  Widget label(IconData iconData, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
