import 'package:flutter/material.dart';

class LpHomeHelper {

  // Get Kyc Pending Timer
 static String getKycPendingTimeLeft(String createdAt, {Duration kycDuration = const Duration(hours: 48)}) {
    try {
      final created = DateTime.parse(createdAt).toLocal(); // Adjust for local time
      final now = DateTime.now();
      final expiry = created.add(kycDuration);
      final remaining = expiry.difference(now);

      if (remaining.isNegative) {
        return "0h to verify";
      } else if (remaining.inHours >= 1) {
        return "${remaining.inHours} hour${remaining.inHours > 1 ? "s" : ""} to verify";
      } else {
        return "${remaining.inMinutes} min${remaining.inMinutes > 1 ? "s" : ""} to verify";
      }
    } catch (e) {
      return "Invalid time";
    }
  }

  // Get Matching Time
  static String getMatchingTime(String createdAtString) {
   try {
     // Parse createdAt
     DateTime createdAt = DateTime.parse(createdAtString).toLocal();

     // Add 3 hours
     DateTime targetTime = createdAt.add(const Duration(hours: 3));

     // Get current time
     DateTime now = DateTime.now();

     // Calculate difference
     Duration difference = targetTime.difference(now);

     if (difference.isNegative) {
       return "00:00:00";
     }

     int hours = difference.inHours;
     int minutes = difference.inMinutes % 60;

     if (hours > 0) {
       return "$hours hr ${minutes.toString().padLeft(2, '0')} min left";
     } else {
       return "$minutes min left";
     }
   } catch (e) {
     return "Invalid time";
   }
 }


 // Get Load type
 static String getLoadTypeDisplayText(String loadType) {
   switch (loadType) {
     case 'KYC Pending':
       return 'KYC pending';
     case 'Matching':
       return 'Matching';
     case 'Confirmed':
       return 'Confirmed';
     case 'Agree':
       return 'Agreed';
     default:
       return 'Unknown';
   }
 }




 // Get Load Status Color
 static Color getLoadStatusColor(String loadType) {
   switch (loadType.toLowerCase()) {
     case "kyc pending":
       return const Color(0xFFFFE6E0); // Light peach
     case "matching":
       return const Color(0xFFE6D8FF); // Light purple
     case "confirmed":
       return const Color(0xFFD5F4E6); // Light green
     case "agree":
       return const Color(0xFFFFF9C4); // Light yellow
     default:
       return Colors.grey.shade200;
   }
 }


 // Get Load Status Text Color
static Color getLoadStatusTextColor(String loadType) {
   switch (loadType.toLowerCase()) {
     case "kyc pending":
       return const Color(0xFFE05A33); // Red-orange
     case "matching":
       return const Color(0xFF864DFF); // Purple
     case "confirmed":
       return const Color(0xFF2E7D32); // Dark green
     case "agree":
       return const Color(0xFF9A7B00); // Dark yellow
     default:
       return Colors.black;
   }
 }


 // Get Calculate Percentage
 static  String calculateTenPercentOfAverage(String priceRange) {
   try {
     final cleaned = priceRange.replaceAll(' ', '');

     if (cleaned.contains('-')) {
       // Case: Range format like "1500-2000"
       final parts = cleaned.split('-');
       if (parts.length != 2) return "Invalid range";

       final min = int.tryParse(parts[0]) ?? 0;
       final max = int.tryParse(parts[1]) ?? 0;

       if (min == 0 || max == 0) return "Invalid range";

       final avg = ((min + max) / 2).round();
       final tenPercent = (avg * 0.10).round();

       return "Rs. $tenPercent";
     } else {
       // Case: Single value like "1000"
       final value = int.tryParse(cleaned) ?? 0;
       if (value == 0) return "Invalid price";

       final tenPercent = (value * 0.10).round();
       return "$tenPercent";
     }
   } catch (e) {
     return "Calculation error";
   }
 }




}