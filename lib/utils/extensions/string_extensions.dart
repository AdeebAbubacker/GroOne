// String Extensions
extension StringExtensions on String? {

  /// Capitalizes the entire string, making the first letter of each word uppercase
  String get capitalize {
    if (this == null || this!.isEmpty) return '';
    return this!.split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  /// Capitalizes only the first letter of the string
  String get capitalizeFirst {
    if (this == null || this!.isEmpty) return '';
    return this![0].toUpperCase() + this!.substring(1).toLowerCase();
  }
}
