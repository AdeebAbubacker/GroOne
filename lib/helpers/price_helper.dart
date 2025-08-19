import 'package:intl/intl.dart';

class PriceHelper {

  static String formatINR(dynamic amount, {String symbol = '₹', bool showDecimal = false}) {
    try {
      final cleanAmount = amount.toString().replaceAll('Rs', '').trim();

      final numValue = num.tryParse(cleanAmount) ?? 0;
      final hasDecimals = cleanAmount.contains('.');

      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: symbol,
        decimalDigits: hasDecimals || showDecimal ? 2 : 0,
      );
      return formatter.format(numValue);
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