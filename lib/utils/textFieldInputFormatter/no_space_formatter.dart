import 'package:flutter/services.dart';

class NoSpaceTextFormatter extends TextInputFormatter {
  final RegExp _noSpaceRegex = RegExp(r'\s'); // matches all whitespace characters

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all space characters
    final filteredText = newValue.text.replaceAll(_noSpaceRegex, '');
    int selectionIndex = filteredText.length;

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
