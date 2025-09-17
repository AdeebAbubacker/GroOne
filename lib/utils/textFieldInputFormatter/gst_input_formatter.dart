import 'package:flutter/services.dart';

class GSTInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    if (text.length > 15) text = text.substring(0, 15);

    int offset = newValue.selection.baseOffset;
    if (offset > text.length) {
      offset = text.length;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
