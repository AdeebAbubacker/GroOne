import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Input validation utilities to prevent crashes from invalid user input
class InputValidator {
  /// Validate email format
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  /// Validate phone number format (10 digits)
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Phone is required';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return 'Invalid phone format';
    }
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    return null;
  }

  /// Validate numeric value
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) return numericError;

    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  /// Validate PIN code (6 digits)
  static String? validatePinCode(String? pinCode) {
    if (pinCode == null || pinCode.isEmpty) return 'PIN code is required';
    if (!RegExp(r'^[0-9]{6}$').hasMatch(pinCode)) {
      return 'PIN code must be 6 digits';
    }
    return null;
  }

  /// Validate vehicle number format
  static String? validateVehicleNumber(String? vehicleNumber) {
    if (vehicleNumber == null || vehicleNumber.isEmpty)
      return 'Vehicle number is required';

    // Basic Indian vehicle number format: AA-12-BB-1234
    final pattern = RegExp(r'^[A-Z]{2}-[0-9]{1,2}-[A-Z]{1,2}-[0-9]{4}$');
    if (!pattern.hasMatch(vehicleNumber)) {
      return 'Invalid vehicle number format (e.g., DL-12-AB-1234)';
    }
    return null;
  }

  /// Validate Aadhaar number (12 digits)
  static String? validateAadhaar(String? aadhaar) {
    if (aadhaar == null || aadhaar.isEmpty) return 'Aadhaar number is required';
    if (!RegExp(r'^[0-9]{12}$').hasMatch(aadhaar)) {
      return 'Aadhaar number must be 12 digits';
    }
    return null;
  }

  /// Validate PAN number format
  static String? validatePAN(String? pan) {
    if (pan == null || pan.isEmpty) return 'PAN number is required';

    // PAN format: ABCDE1234F
    final pattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!pattern.hasMatch(pan)) {
      return 'Invalid PAN format (e.g., ABCDE1234F)';
    }
    return null;
  }

  /// Safe text editing controller with validation
  static TextEditingController createSafeController({
    String? initialValue,
    String? Function(String?)? validator,
  }) {
    return TextEditingController(text: initialValue ?? '');
  }

  /// Safe form field with validation
  static Widget createSafeFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorMaxLines: 2,
      ),
    );
  }
}

/// Safe text input formatter
class SafeTextInputFormatter {
  /// Allow only numbers
  static List<TextInputFormatter> numbersOnly() {
    return [FilteringTextInputFormatter.digitsOnly];
  }

  /// Allow only letters and spaces
  static List<TextInputFormatter> lettersOnly() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))];
  }

  /// Allow only alphanumeric characters
  static List<TextInputFormatter> alphanumericOnly() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))];
  }

  /// Allow only numbers and decimal point
  static List<TextInputFormatter> decimalNumbers() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
  }

  /// Limit to specific length
  static List<TextInputFormatter> limitLength(int maxLength) {
    return [LengthLimitingTextInputFormatter(maxLength)];
  }
}
