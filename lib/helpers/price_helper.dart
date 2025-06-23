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

}