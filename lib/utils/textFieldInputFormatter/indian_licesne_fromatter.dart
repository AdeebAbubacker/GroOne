
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class IndianLicenseFormatter extends TextInputFormatter {
  static const int maxLength = 15; 

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (text.length > maxLength) {
      text = text.substring(0, maxLength);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
