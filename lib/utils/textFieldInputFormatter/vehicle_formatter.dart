import 'package:flutter/services.dart';

class VehicleNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    
    String cleaned = newValue.text.replaceAll(' ', '').toUpperCase();
    String formatted = '';
    int cursorPosition = 0;
    
    int i = 0;
    int length = cleaned.length;

    // State code (2 letters)
    if (length >= 2) {
      formatted += cleaned.substring(0, 2) + ' ';
      i = 2;
    } else {
      formatted = cleaned;
      i = length;
    }

    // District code (2 digits)
    if (length >= i + 2) {
      formatted += cleaned.substring(i, i + 2) + ' ';
      i += 2;
    } else if (i < length) {
      formatted += cleaned.substring(i);
      i = length;
    }

    // Series letters (1 or 2 letters)
    int lettersCount = 0;
    while (i < length && RegExp(r'[A-Z]').hasMatch(cleaned[i]) && lettersCount < 2) {
      formatted += cleaned[i];
      i++;
      lettersCount++;
    }
    if (lettersCount > 0) formatted += ' ';

    // Remaining digits (number)
    if (i < length) {
      formatted += cleaned.substring(i);
    }

    // Adjust cursor
    int nonSpaceBeforeCursor = 0;
    for (int j = 0; j < newValue.selection.end && j < newValue.text.length; j++) {
      if (newValue.text[j] != ' ') nonSpaceBeforeCursor++;
    }

    // Count spaces to add
    int spaceCount = 0;
    if (nonSpaceBeforeCursor > 2) spaceCount++;
    if (nonSpaceBeforeCursor > 4) spaceCount++;
    if (nonSpaceBeforeCursor > 4 + lettersCount) spaceCount++;

    cursorPosition = nonSpaceBeforeCursor + spaceCount;
    if (cursorPosition > formatted.length) cursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

