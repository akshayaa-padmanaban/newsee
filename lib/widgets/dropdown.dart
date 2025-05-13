import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

Widget Dropdown({
    required String controlName,
    required String label,
    required List<String> items,
  }){
    return Padding(
      padding: EdgeInsets.all(16),
      child: ReactiveDropdownField<String>(
        formControlName: controlName,
        decoration: InputDecoration(
          labelText: label,
          hintText: '--Select--',
        ),
        items: items
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
      ),
    );
  }
  