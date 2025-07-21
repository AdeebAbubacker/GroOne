// import 'package:flutter/material.dart';

// /// Enum representing the status of a timeline step.
// enum TimelineStepStatus {
//   completed,
//   current,
//   upcoming,
//   unknown,
// }

// /// Helper to convert string to enum
// TimelineStepStatus getTimelineStepStatus(String? status) {
//   switch (status?.toLowerCase()) {
//     case 'completed':
//       return TimelineStepStatus.completed;
//     case 'current':
//       return TimelineStepStatus.current;
//     case 'upcoming':
//       return TimelineStepStatus.upcoming;
//     default:
//       return TimelineStepStatus.unknown;
//   }
// }

// /// Model class for each driver timeline step
// class DriverTimelineStep {
//   final int id;
//   final String label;
//   final String status;
//   final DateTime timestamp;
//   final String commodityName;
//   final String truckType;
//   final String truckSubType;
//   final String loadProviderName;

//   DriverTimelineStep({
//     required this.id,
//     required this.label,
//     required this.status,
//     required this.timestamp,
//     required this.commodityName,
//     required this.truckType,
//     required this.truckSubType,
//     required this.loadProviderName,
//   });

//   factory DriverTimelineStep.fromJson(Map<String, dynamic> json) {
//     return DriverTimelineStep(
//       id: json['id'],
//       label: json['label'],
//       status: json['status'],
//       timestamp: DateTime.parse(json['timestamp']),
//       commodityName: json['commodity']['name'] ?? '',
//       truckType: json['truckType']['type'] ?? '',
//       truckSubType: json['truckType']['subType'] ?? '',
//       loadProviderName: json['loadProvider']['companyName'] ?? '',
//     );
//   }
// }

// /// Helper class for driver timeline
// class DriverTimelineHelper {
//   /// Parses raw JSON list into a list of timeline step models
//   static List<DriverTimelineStep> parseTimelineSteps(List<dynamic> jsonList) {
//     return jsonList
//         .map((e) => DriverTimelineStep.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   /// Returns a color based on the timeline status
//   static Color getStepColor(String status) {
//     final stepStatus = getTimelineStepStatus(status);
//     switch (stepStatus) {
//       case TimelineStepStatus.completed:
//         return Colors.green;
//       case TimelineStepStatus.current:
//         return Colors.orange;
//       case TimelineStepStatus.upcoming:
//         return Colors.grey;
//       default:
//         return Colors.black;
//     }
//   }

//   /// Returns an icon based on the timeline status
//   static IconData getStepIcon(String status) {
//     final stepStatus = getTimelineStepStatus(status);
//     switch (stepStatus) {
//       case TimelineStepStatus.completed:
//         return Icons.check_circle;
//       case TimelineStepStatus.current:
//         return Icons.radio_button_checked;
//       case TimelineStepStatus.upcoming:
//         return Icons.radio_button_unchecked;
//       default:
//         return Icons.help_outline;
//     }
//   }

//   /// Optional: format timestamp if needed
//   static String formatTimestamp(DateTime timestamp) {
//     return "${timestamp.toLocal()}".split(' ')[0]; // YYYY-MM-DD
//   }
// }
