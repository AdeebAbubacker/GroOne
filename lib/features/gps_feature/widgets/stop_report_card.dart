// lib/features/gps_feature/widgets/stop_report_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_colors.dart';
import '../model/address_model.dart';
import '../model/report_model.dart';
import 'address_skeleton.dart';

class StopReportCard extends StatelessWidget {
  final StopReport report;
  final AddressResponse? addressResponse;

  const StopReportCard({Key? key, required this.report, this.addressResponse})
    : super(key: key);

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  String _getDisplayAddress() {
    // If we have real addresses from reverse geocoding, use them
    if (addressResponse != null) {
      final realAddress = addressResponse!.startAddress;
      if (realAddress != "No Address") {
        return realAddress;
      }
    }

    // Fallback to original address from API if it looks like a real address
    if (report.address.isNotEmpty && !report.address.contains(',')) {
      return report.address;
    }

    // Final fallback to formatted coordinates
    // If coordinates are 0,0 (invalid GPS), show dash
    if (report.latitude == 0.0 && report.longitude == 0.0) {
      return "-";
    }

    return "Lat: ${report.latitude.toStringAsFixed(6)}\nLng: ${report.longitude.toStringAsFixed(6)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Text(
            _formatDate(report.startTime),
            style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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
                  color: AppColors.activeRedColor, // Red color for time
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              // Separator
              const Text(
                '|',
                style: TextStyle(color: AppColors.black, fontSize: 14),
              ),
              const SizedBox(width: 8),
              // Location - flexible to take remaining space
              Expanded(
                child:
                    addressResponse == null
                        ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: const AddressSkeleton(showStartEnd: false),
                        )
                        : Text(
                          _getDisplayAddress(),
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Engine time info and View on Map button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLightColor, // Slightly darker blue
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
                        style: TextStyle(color: AppColors.black, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.duration,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // View on Map button
                GestureDetector(
                  onTap: () {
                    // Add your map navigation logic here
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View on Map',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryColor,
                          size: 13,
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
