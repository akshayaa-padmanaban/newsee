/*
 @created on : May 16, 2025
 @author : Akshayaa 
 @description : A custom TextInputFormatter that applies Indian Rupee style
                comma formatting (e.g. 1,00,000) while typing and allows
                only numeric digits.
*/

import 'package:flutter/services.dart';

class Rupeeformatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Removes all non digit characters and extracts only digits
    String raw = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (raw.isEmpty) return newValue;

    // Extract last 3 digits then extract remaining digits before the last 3 digits 
    // then group the remaining digits in 2s from the end
    String lastThree = raw.length > 3 ? raw.substring(raw.length - 3) : raw;
    String otherNumbers = raw.length > 3 ? raw.substring(0, raw.length - 3) : '';
    String formatted = '';
    while (otherNumbers.length > 2) {
      formatted = ',${otherNumbers.substring(otherNumbers.length - 2)}$formatted';
      otherNumbers = otherNumbers.substring(0, otherNumbers.length - 2);
    }
    if (otherNumbers.isNotEmpty) formatted = otherNumbers + formatted;

    String finalValue =
        formatted.isEmpty ? lastThree : '$formatted,$lastThree';

    return TextEditingValue(
      text: finalValue,
      selection: TextSelection.collapsed(offset: finalValue.length),
    );
  }
}
