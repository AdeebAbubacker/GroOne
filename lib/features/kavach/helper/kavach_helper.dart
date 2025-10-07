import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_colors.dart';

class KavachHelper {
  static Color getKavachOrderStatusColor(String status) {
    switch (status) {
      case 'Order Placed':
        return AppColors.primaryColor;
      case 'Dispatched':
        return Colors.orange;
      case 'Delivered':
        return AppColors.greenColor;
      case 'Failed':
        return AppColors.activeRedColor;
      case 'Installed':
        return Colors.teal;
      default:
        return AppColors.primaryColor;
    }
  }

  static String formatCurrency(
    dynamic totalPrice, {
    bool roundOf = false,
    bool withoutDecimal = false,
  }) {
    final formatter =
        withoutDecimal ? NumberFormat("#,##,##0") : NumberFormat("#,##,##0.00");
    final num value =
        totalPrice is num
            ? totalPrice
            : double.tryParse(totalPrice.toString()) ?? 0;
    return formatter.format(roundOf ? value.round().toDouble() : value);
  }

  static String formatCurrencyRoundOf(dynamic totalPrice) {
    final formatter = NumberFormat("#,##,##0.00", "en_IN");
    final num value =
        totalPrice is num
            ? totalPrice
            : double.tryParse(totalPrice.toString()) ?? 0;
    final roundedValue = value.round();
    return formatter.format(roundedValue.toDouble());
  }

  static bool isValidGSTIN(String gstIn) {
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );
    return gstRegex.hasMatch(gstIn);
  }
}
