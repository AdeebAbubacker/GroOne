
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/global_variables.dart';

class Validator {
  Validator._();

  /// Email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return appContext.appText.emailIsRequired;
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return appContext.appText.validEmailAddress;
    }
    return null;
  }

  /// Field Required
  static String? fieldRequired(String? value, {String? fieldName}){
    if (value == null || value.trim().isEmpty) {
      if(fieldName != null){
        return '$fieldName ${appContext.appText.isRequired}';
      }else{
        return appContext.appText.thisFieldIsRequired;
      }
    }
    return null;
  }

  /// Password
  static String? password(String? value){
    if (value == null || value.isEmpty) {
      return appContext.appText.passwordIsRequired;
    }
    if(value.length < 6){
      return appContext.appText.passwordMustBeAtLeast6Digit;
    }
    return null;
  }

  static String? phone(String? value) {
    const int requiredLength = 10;

    if (value == null || value.isEmpty) {
      return appContext.appText.pleaseEnterMobileNumber;
    }

    // Allow only digits
    final isDigitsOnly = RegExp(r'^\d{10}$');
    if (!isDigitsOnly.hasMatch(value)) {
      return appContext.appText.pleaseEnter10DigitMobileNumber;
    }

    // Starts with 0
    if (value.startsWith('0')) {
      return appContext.appText.mobileNumberCannotStartWith0;
    }

    // Disallow repeated digits like 0000000000, 1111111111, etc.
    if (RegExp(r'^(\d)\1*$').hasMatch(value)) {
      return appContext.appText.mobileNumberCannotHaveSameNumber;
    }

    return null;
  }





  static String? pincode(String? value) {
    String pattern = r'^[1-9][0-9]{5}$'; // Reject all 0s, allow 6 digits
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return appContext.appText.pleaseEnterPinCode;
    } else if (!regExp.hasMatch(value)) {
      return appContext.appText.pleaseEnterValidPinCode;
    }
    return null;
  }


  static String? noSpecialCharacters(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${appContext.appText.isRequired}';
    }
    final regex = RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!regex.hasMatch(value)) {
      return '$fieldName should not contain special characters';
    }
    return null;
  }

  static String? positiveNumber(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${appContext.appText.isRequired}';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  static String? alphabetsOnly(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName  ${appContext.appText.isRequired}';
    }
    final regex = RegExp(r'^[a-zA-Z ]+$');
    if (!regex.hasMatch(value.trim())) {
      return '$fieldName should contain alphabets only';
    }
    return null;
  }

  static String? licenseNumberValidator(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName  ${appContext.appText.isRequired}';
    }

    // Format: 2 letters + hyphen + 13 digits (total 16 characters)
    // Example: DL-1420110012345
    final regex = RegExp(r'^[A-Z]{2}-\d{13}$');

    if (!regex.hasMatch(value.trim().toUpperCase())) {
      return '$fieldName';
    }

    return null;
  }

  static String? validateVehicleNumber(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${appContext.appText.isRequired}';
    }

    // Indian vehicle number pattern (no spaces, no hyphens)
    final regex = RegExp(r'^[A-Z]{2}[ -]?[0-9]{2}[ -]?[A-Z]{1,2}[ -]?[0-9]{4}$', caseSensitive: false);

    if (!regex.hasMatch(value.trim().toUpperCase())) {
      return '$fieldName is invalid';
    }
    return null;
  }

  static String? rcBookNumberValidator(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${appContext.appText.isRequired}';
    }
    
    final trimmedValue = value.trim().toUpperCase();
    final regex = RegExp(r'^[A-Z]{2}\d{2}[A-Z]{1,2}\d{4}$');
    
    if (!regex.hasMatch(trimmedValue)) {
      return '$fieldName should be in format: XX12AB1234 (2 letters, 2 digits, 1-2 letters, 4 digits)';
    }
    
    return null;
  }
  static String? indianLicenseNumber(String? value, {required String fieldName}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName ${appContext.appText.isRequired}';
  }

  final trimmedValue = value.trim().toUpperCase();
  final regex = RegExp(r"^([A-Z]{2})[- ]?([0-9]{2})[- ]?((19|20)[0-9]{2})[- ]?([0-9]{7})$", caseSensitive: false,);

  if (!regex.hasMatch(trimmedValue)) {
    return '$fieldName is invalid.';
  }

  return null;
}

}

