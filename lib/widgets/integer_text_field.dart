import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

Widget IntegerTextField(String controlName, String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        validationMessages: {
          ValidationMessage.pattern: (error)=>'Enter the valid number of digits'
        },
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }