import 'package:flutter/services.dart';

class BankAccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Allow only digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit length to 18 digits
    if (digitsOnly.length > 18) {
      digitsOnly = digitsOnly.substring(0, 18);
    }

    int offset = newValue.selection.baseOffset;
    if (offset > digitsOnly.length) {
      offset = digitsOnly.length;
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
