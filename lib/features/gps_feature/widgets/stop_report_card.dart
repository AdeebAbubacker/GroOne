// lib/features/gps_feature/presentation/widgets/stop_report_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/report_model.dart';

class StopReportCard extends StatelessWidget {
  final StopReport report;
  const StopReportCard({Key? key, required this.report}) : super(key: key);

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) { return 'Invalid Date'; }
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) { return 'N/A'; }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xffffffff), // Light blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2196F3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Text(
            _formatDate(report.startTime), 
            style: const TextStyle(
              color: Colors.black87, 
              fontWeight: FontWeight.bold, 
              fontSize: 18
            )
          ),
          const SizedBox(height: 12),
          
          // Time and location row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time
              Text(
                _formatTime(report.startTime),
                style: const TextStyle(
                  color: Color(0xFFE53935), // Red color for time
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                )
              ),
              const SizedBox(width: 8),
              // Separator
              const Text(
                '|',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
                )
              ),
              const SizedBox(width: 8),
              // Location - flexible to take remaining space
              Expanded(
                child: Text(
                  report.address,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    height: 1.3
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Engine time info and View on Map button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFBBDEFB), // Slightly darker blue
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Engine time info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Engine On time',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.duration,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                ),
                
                // View on Map button
                GestureDetector(
                  onTap: () {
                    // Add your map navigation logic here
                    print('Navigate to map for location: ${report.address}');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View on Map',
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF2196F3),
                          size: 14
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}