import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  DateTimeHelper._();

  /// Get Current Date Time
  static DateTime now() {
    return DateTime.now();
  }

  /// Get Date Time Format
  static String getDateTimeFormat(DateTime date) {
    var formatter = DateFormat('dd/MM/yyyy - hh:mm a');
    return formatter.format(date);
  }

  /// Get Time Format With Am or Pm
  static String getTimeFormatWithAmOrPm(DateTime date) {
    var formatter = DateFormat('hh:mm a');
    return formatter.format(date);
  }

  /// Get Format Date
  static String getFormattedDate(DateTime date) {
    var formatter = DateFormat("dd-MM-yyyy");
    return formatter.format(date);
  }

  /// Get Date With Short Name
  static String getFormattedDateWithShortMonthName(DateTime date) {
    var formatter = DateFormat("dd MMM yyyy");
    return formatter.format(date);
  }

  /// Convert to AM or Pm
  static String convertToAmPm(String time, BuildContext context) {
    DateTime parsedTime = DateTime.parse('1970-01-01 $time:00');
    String formattedTime = TimeOfDay.fromDateTime(parsedTime).format(context);
    return formattedTime;
  }

  /// Convert to API/database format: "2025-06-14T20:00:00.000Z"
  static String convertToDatabaseFormat(String date) {
    try {
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      // Convert to UTC and format as ISO 8601
      return parsedDate.toUtc().toIso8601String(); // e.g., "2025-06-14T00:00:00.000Z"
    } catch (e) {
      return "Invalid Date";
    }
  }


  /// Convert to database format
  static String convertToDatabaseFormat2(String date) {
    try {
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      return DateFormat("yyyy-MM-dd").format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// Output: 14 Jul, 2025, 7.30 PM
  static String formatCustomDate(DateTime date) {
    try {
    return DateFormat("d MMM y, h.mm a").format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// convert to IST format
  static String formatCustomDateIST(DateTime? date) {
    try {
      if (date == null) return "Invalid Date";
      final istDate = date.toUtc().add(const Duration(hours: 5, minutes: 30));
      return DateFormat("d MMM y, h.mm a").format(istDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  static DateTime? convertStringToDateTime(String dateString) {
    try {
      // Define input format (DD/MM/YYYY)
      final DateFormat format = DateFormat("dd/MM/yyyy");
      return format.parse(dateString);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return null;
    }
  }

  /// Input Date Format : dd/MM/yyyy
  static DateTime convertToDateTimeWithCurrentTime(String date) {
    try {
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      DateTime now = DateTime.now();
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, now.hour, now.minute, now.second);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return DateTime.now();
    }
  }

  /// Input Format hh : mm a , example- 05 : 15 PM
  static TimeOfDay convertStringToTimeOfDay(String timeString) {
    try {
      final DateFormat format = DateFormat("hh : mm a");
      final DateTime parsedDateTime = format.parse(timeString);
      return TimeOfDay(hour: parsedDateTime.hour, minute: parsedDateTime.minute);
    } catch (e) {
      debugPrint("Error parsing time: $e");
      return TimeOfDay.now();
    }
  }



  /// Converts date and time strings into ISO8601 UTC format for API
  static String convertToApiDateTime(String date, String time) {
    try {
      // Combine date and time strings
      String input = "$date , $time";

      // Expected format
      final inputFormat = DateFormat("dd/MM/yyyy , hh : mm a");

      // Parse to DateTime in local time
      final localDateTime = inputFormat.parse(input);

      // Convert to UTC
      final utcDateTime = localDateTime.toUtc();

      // Return ISO 8601 format string
      return utcDateTime.toIso8601String();
    } catch (e) {
      return ""; // or throw an error/log it
    }


  }



}
