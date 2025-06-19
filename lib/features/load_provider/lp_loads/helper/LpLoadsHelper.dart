import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';

class LpLoadsHelper {
  // Get Load type
  static String getLoadTypeDisplayText(int loadType) {
    switch (loadType) {
      case 1:
        return 'KYC pending';
      case 2:
        return 'Matching';
      case 3:
        return 'Confirmed';
      case 5:
        return 'Assigned';
      default:
        return 'Unknown';
    }
  }




  // Get Load Status Color
  static Color getLoadStatusColor(int loadType) {
    switch (loadType) {
      case 1:
        return const Color(0xFFFFE6E0); // Light peach
      case 2:
        return AppColors.lightPurpleColor; // Light purple
      case 3:
        return const Color(0x1A9C27B0); // Light pink
      case 5:
        return const Color(0xFFD5F4E6); // Light green
      default:
        return Colors.grey.shade200;
    }
  }


  // Get Load Status Text Color
  static Color getLoadStatusTextColor(int loadType) {
    switch (loadType) {
      case 1:
        return const Color(0xFFE05A33); // Red-orange
      case 2:
        return AppColors.purpleColor; // Purple
      case 3:
        return AppColors.textPurpleColor; // light purple
      case 5:
        return const Color(0xFF2E7D32); // Green
      default:
        return Colors.black;
    }
  }


}