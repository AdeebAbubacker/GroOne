import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlphaOnlyTextFormatter extends TextInputFormatter {
  final RegExp _alphaRegex = RegExp(r'[a-zA-Z]');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Keep only alphabet characters
    final filteredText = newValue.text.characters.where((c) => _alphaRegex.hasMatch(c)).join();
    int selectionIndex = filteredText.length;
    selectionIndex = selectionIndex.clamp(0, filteredText.length);

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
