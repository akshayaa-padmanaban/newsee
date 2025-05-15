import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IntegerTextField extends StatelessWidget {
  final String controlName;
  final String label;

  const IntegerTextField(this.controlName, this.label, {Key? key}) : super(key: key);

  int getMaxLength() {
    if (controlName == 'mobilenumber') return 10;
    return 20;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(getMaxLength()),
        ],
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
        validationMessages: {
        ValidationMessage.required: (error) => '$label is required',
      },
      ),
    );
  }
}
