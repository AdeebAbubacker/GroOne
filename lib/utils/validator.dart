
class Validator {
  Validator._();

  /// Email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Field Required
  static String? fieldRequired(String? value, {String? fieldName}){
    if (value == null || value.trim().isEmpty) {
      if(fieldName != null){
        return '$fieldName is required';
      }else{
        return 'This filed is required';
      }
    }
    return null;
  }

  /// Password
  static String? password(String? value){
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if(value.length < 6){
      return "Password must be at least 6 character long.";
    }
    return null;
  }

  static String? phone(String? value) {
    const int requiredLength = 10;

    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    }

    // Allow only digits
    final isDigitsOnly = RegExp(r'^\d{10}$');
    if (!isDigitsOnly.hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }

    // Starts with 0
    if (value.startsWith('0')) {
      return 'Mobile number cannot start with 0';
    }

    // Disallow repeated digits like 0000000000, 1111111111, etc.
    if (RegExp(r'^(\d)\1*$').hasMatch(value)) {
      return 'Mobile number cannot have all same digits';
    }

    return null;
  }




  static String? countryCode(String? value) {
    String pattern = r'^\+\d{1,3}$';  // Pattern for '+' followed by 1 to 3 digits
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Please enter country code';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid country code';
    }
    return null;
  }
  static String? pincode(String? value) {
    String pattern = r'^[1-9][0-9]{5}$'; // Reject all 0s, allow 6 digits
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Please enter pincode';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid pincode';
    }
    return null;
  }


  static String? noSpecialCharacters(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final regex = RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!regex.hasMatch(value)) {
      return '$fieldName should not contain special characters';
    }
    return null;
  }

  static String? positiveNumber(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  static String? alphabetsOnly(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final regex = RegExp(r'^[a-zA-Z ]+$');
    if (!regex.hasMatch(value.trim())) {
      return '$fieldName should contain alphabets only';
    }
    return null;
  }

  static String? licenseNumberValidator(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    // Format: 2 letters + hyphen + 13 digits (total 16 characters)
    // Example: DL-1420110012345
    final regex = RegExp(r'^[A-Z]{2}-\d{13}$');

    if (!regex.hasMatch(value.trim().toUpperCase())) {
      return '$fieldName should be in format: XX-1234567890123 (2 letters, hyphen, 13 digits)';
    }

    return null;
  }

  static String? validateVehicleNumber(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    // Indian vehicle number pattern (no spaces, no hyphens)
    final regex = RegExp(r'^[A-Z]{2}\d{1,2}[A-Z]{1,2}\d{1,4}$', caseSensitive: false);

    if (!regex.hasMatch(value.trim().toUpperCase())) {
      return '$fieldName is invalid. Example: MH12AB1234';
    }
    return null;
  }

  static String? rcBookNumberValidator(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    final trimmedValue = value.trim().toUpperCase();
    
    // RC book number format: 5 letters + 4 digits + 1 letter
    // Example: AAAPA1234A
    final regex = RegExp(r'^[A-Z]{5}\d{4}[A-Z]$');
    
    if (!regex.hasMatch(trimmedValue)) {
      return '$fieldName should be in format: AAAPA1234A (5 letters, 4 digits, 1 letter)';
    }
    
    return null;
  }

}
