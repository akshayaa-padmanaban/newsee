import 'package:flutter/material.dart';

class KycPage extends StatelessWidget {
  final String title;
  KycPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(title, style: TextStyle(fontSize: 12.0))]);
  }
}
