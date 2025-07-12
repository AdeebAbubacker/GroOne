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

  static String formatCurrency(totalPrice) {
    final formatter = NumberFormat("#,##,###");
    return "₹ ${formatter.format(totalPrice)}";
  }
}
