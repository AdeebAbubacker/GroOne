import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';

class LpHomeHelper {

  // Get Kyc Pending Timer
 static String getKycPendingTimeLeft(String createdAt, {Duration kycDuration = const Duration(hours: 48)}) {
    try {
      final created = DateTime.parse(createdAt).toLocal(); // Adjust for local time
      final now = DateTime.now();
      final expiry = created.add(kycDuration);
      final difference = expiry.difference(now);

      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      if (difference.isNegative) return "0h to verify";


      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

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
     final targetTime = createdAt.add(const Duration(hours: 2));

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

 // static String getMatchingTime(String createdAtString) {
 //   try {
 //     final createdAt = DateTime.parse(createdAtString).toLocal();
 //     final targetTime = createdAt.add(const Duration(hours: 2));
 //     final now = DateTime.now();
 //     final difference = targetTime.difference(now);
 //
 //     if (difference.isNegative) return "0 min";
 //
 //     final totalMinutes = difference.inMinutes;
 //     return "$totalMinutes min";
 //   } catch (_) {
 //     return "0 min";
 //   }
 // }





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
     case 'Assigned':
       return 'Assigned';
     case 'Loading':
       return 'Loading';
     case 'In Transit':
       return 'In Transit';
     case 'Unloading':
       return 'Unloading';
     case 'Unloading Held':
       return 'Unloading Held';
     case 'POD Dispatch':
       return 'POD Dispatch';
     case 'Completed':
       return 'Completed';
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
       return const Color(0xFFe7dbff); // Light purple
     case "confirmed":
       return const Color(0xFFd4f3f7); // Light green
     case "agree":
       return const Color(0xFFFFF9C4); // Light yellow
     case "assigned":
       return const Color(0xFFD5F4E6); // Light yellow
     case "loading":
       return AppColors.brownColor; // Light yellow
     case "in transit":
       return AppColors.lightRedColor; // Light yellow
     case "unloading":
       return AppColors.lightGreenBox; // Light yellow
     case "unloading held":
       return AppColors.red; // Light yellow
     case "pod dispatch":
       return Color(0xff42A5F5); // Light yellow
     case "completed":
       return AppColors.greenColor; // Light yellow
     default:
       return Colors.grey.shade200;
   }
 }

 // Get Load Status State
 static int getPaymentState(LoadStatus loadStatus) {
  switch (loadStatus) {
    case LoadStatus.loading:
      return 1;
    case LoadStatus.inTransit:
      return 2;
    case LoadStatus.unloading:
      return 3;
    case LoadStatus.unloadingHeld:
      return 4;
     case LoadStatus.completed:
      return 5;  
    default:
      return 0; // Not eligible or unknown
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
       return const Color(0xFF00bcd4); // Dark green
     case "agree":
       return const Color(0xFF9A7B00); // Dark yellow
     case "assigned":
       return const Color(0xFF2E7D32); // Dark green
     case "loading":
       return AppColors.lightBrownTextColor; // Dark green
     case "in transit":
       return AppColors.redTextColor; // Dark green
     case "unloading":
       return AppColors.greenColor; // Dark green
     case "unloading held":
       return AppColors.white; // Dark green
     case "completed":
       return AppColors.white; // Dark green
     default:
       return Colors.white;
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

 static LoadStatus? getLoadStatusFromString(String? loadType) {
   switch (loadType) {
     case 'KYC Pending':
       return LoadStatus.kycPending;
     case 'Matching':
       return LoadStatus.matching;
     case 'Confirmed':
       return LoadStatus.confirmed;
     case 'Assigned':
       return LoadStatus.assigned;
     case 'Loading':
       return LoadStatus.loading;
     case 'In Transit':
       return LoadStatus.inTransit;
     case 'Unloading':
       return LoadStatus.unloading;
     case 'Unloading Held':
       return LoadStatus.unloadingHeld;
     case 'POD Dispatch':
       return LoadStatus.podDispatch;
     case 'Completed':
       return LoadStatus.completed;
     default:
       return null;
   }
 }





}

enum LoadStatus {
  kycPending,
  matching,
  confirmed,
  assigned,
  loading,
  inTransit,
  unloading,
  unloadingHeld,
  podDispatch,
  completed
}