
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
    if (value == null || value.isEmpty) {
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
    String pattern = r'^\d{4,6}$'; // Matches 4 to 6 digit numbers (common for many countries)
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



}
