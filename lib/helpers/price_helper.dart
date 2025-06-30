import 'package:intl/intl.dart';

class PriceHelper {

  static String formatINR(dynamic amount) {
    try {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      );
      return formatter.format(num.tryParse(amount.toString()) ?? 0);
    } catch (_) {
      return '₹0';
    }
  }

  static String formatINRRange(String range) {
    try {
      final parts = range.split(' - ');
      if (parts.length == 2) {
        final min = formatINR(parts[0]);
        final max = formatINR(parts[1]);
        return '$min - $max';
      }
      return formatINR(range);
    } catch (_) {
      return '₹0';
    }
  }

}