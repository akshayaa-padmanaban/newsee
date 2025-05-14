import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

Widget CustomTextField(String controlName, String label) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ReactiveTextField<String>(
      formControlName: controlName,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
