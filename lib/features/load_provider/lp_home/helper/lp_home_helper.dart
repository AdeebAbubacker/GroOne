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


 /// Returns a `hh:mm:ss` count-down that starts **three hours after the object
 /// was created** and ticks down toward 0 from the current device‐time.
 ///
 /// If the three-hour window has already elapsed you’ll get `"00:00:00"`.
 static String getMatchingTime(String createdAtString) {
   try {
     // 1️⃣ parse the original timestamp coming from the backend
     final createdAt = DateTime.parse(createdAtString).toLocal();

     // 2️⃣ add the extra 3 hours that the load is allowed to stay in “matching”
     final targetTime = createdAt.add(const Duration(hours: 3));

     // 3️⃣ compute the remaining time *from now* until that target
     final now        = DateTime.now();
     final difference = targetTime.difference(now);

     // 4️⃣ if we are already past the deadline → show all zeros
     if (difference.isNegative) return "00:00:00";

     // 5️⃣ format as HH:MM:SS
     final hours   = difference.inHours;
     final minutes = difference.inMinutes.remainder(60);
     final seconds = difference.inSeconds.remainder(60);

     return "${hours.toString().padLeft(2, '0')}:"
         "${minutes.toString().padLeft(2, '0')}:"
         "${seconds.toString().padLeft(2, '0')}";
   } catch (_) {
     // any parsing error → fallback
     return "00:00:00";
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
     debugPrint("Price Range: $priceRange");
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

       return "$tenPercent";
     } else {
       double doubleValue = double.parse(priceRange);
       int rounded = doubleValue.round();
       // Case: Single value like "1000"
       final value = rounded;
       if (value == 0) return "Invalid price";

       final tenPercent = (value * 0.10).round();
       return "$tenPercent";
     }
   } catch (e) {
     return "Calculation error";
   }
 }


 // Get Location Display
 static String getPickUpAndDropLocationDisplay({required String? address, required String? location}) {
   final cleanedLocation = location?.trim() ?? '';
   final cleanedAddress = address?.trim() ?? '';

   if (cleanedAddress.isEmpty) return cleanedLocation;
   if (cleanedLocation.isEmpty) return cleanedAddress;
   return "$cleanedAddress, $cleanedLocation";
 }




}