// lib/features/gps_feature/presentation/widgets/stop_report_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../model/report_model.dart';
import '../model/address_model.dart';
import '../cubit/report_cubit.dart';

class StopReportCard extends StatelessWidget {
  final StopReport report;
  final AddressResponse? addressResponse;
  
  const StopReportCard({
    Key? key, 
    required this.report,
    this.addressResponse,
  }) : super(key: key);

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
    print("🌍 UI: Getting display address for stop location");
    print("🌍 UI: Stop Device ID: ${report.deviceId}");
    print("🌍 UI: Stop Start Time: ${report.startTime}");
    print("🌍 UI: AddressResponse available: ${addressResponse != null}");
    
    // If we have real addresses from reverse geocoding, use them
    if (addressResponse != null) {
      final realAddress = addressResponse!.startAddress;
      print("🌍 UI: Real address from response: '$realAddress'");
      if (realAddress != "No Address") {
        print("🌍 UI: Using real address: $realAddress");
        return realAddress;
      } else {
        print("🌍 UI: Real address is 'No Address', falling back to coordinates");
      }
    } else {
      print("🌍 UI: No AddressResponse available, falling back to coordinates or original address");
    }
    
    // Fallback to original address from API if it looks like a real address
    if (report.address.isNotEmpty && !report.address.contains(',')) {
      print("🌍 UI: Using original address from API: ${report.address}");
      return report.address;
    }
    
    // Final fallback to formatted coordinates
    // If coordinates are 0,0 (invalid GPS), show dash
    if (report.latitude == 0.0 && report.longitude == 0.0) {
      print("🌍 UI: Coordinates are 0,0 (invalid GPS), showing dash");
      return "-";
    }
    
    final formatted = "Lat: ${report.latitude.toStringAsFixed(6)}\nLng: ${report.longitude.toStringAsFixed(6)}";
    print("🌍 UI: Using formatted coordinates: $formatted");
    return formatted;
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
                  _getDisplayAddress(),
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
                    print('Navigate to map for location: ${_getDisplayAddress()}');
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