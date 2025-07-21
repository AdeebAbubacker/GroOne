// lib/features/gps_feature/presentation/widgets/reachability_report_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gro_one_app/utils/app_colors.dart';

import '../model/report_model.dart';
import '../model/address_model.dart';
import 'address_skeleton.dart';

class ReachabilityReportCard extends StatelessWidget {
  final ReachabilityReport report;
  final ReachabilityAddressResponse? addressResponse;
  
  const ReachabilityReportCard({
    Key? key, 
    required this.report,
    this.addressResponse,
  }) : super(key: key);

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd-MM-yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  Color _getStatusColor() {
    switch (report.status.toLowerCase()) {
      case 'reached':
        return AppColors.activeDarkGreenColor;
      case 'pending':
        return AppColors.orangeTextColor;
      case 'not reached':
        return AppColors.activeRedColor;
      default:
        return AppColors.grayColor;
    }
  }

  String _getDisplayAddress() {
    print("🌍 UI: Getting display address for reachability location");
    print("🌍 UI: Reachability ID: ${report.id}");
    print("🌍 UI: Device ID: ${report.deviceId}");
    print("🌍 UI: AddressResponse available: ${addressResponse != null}");
    
    // First priority: Real address fetched from server using lat/lng
    if (addressResponse != null) {
      final realAddress = addressResponse!.address;
      print("🌍 UI: Real address from reverse geocoding: '$realAddress'");
      if (realAddress != "No Address") {
        print("🌍 UI: Using real reverse geocoded address: $realAddress");
        return realAddress;
      } else {
        return realAddress;
      }
    } else {
      print("🌍 UI: No AddressResponse available, falling back to API fields");
    }
    
    // Second priority: Addresses from API response
    if (report.setAddress.isNotEmpty && report.setAddress != "No Address") {
      print("🌍 UI: Using setAddress from API: ${report.setAddress}");
      return report.setAddress;
    }
    if (report.endAddress.isNotEmpty && report.endAddress != "No Address") {
      print("🌍 UI: Using endAddress from API: ${report.endAddress}");
      return report.endAddress;
    }
    
    // Third priority: Geofence name
    if (report.geofenceName.isNotEmpty) {
      print("🌍 UI: Using geofence name: ${report.geofenceName}");
      return report.geofenceName;
    }
    
    // Final fallback: Coordinates
    if (report.lat != 0.0 && report.lng != 0.0) {
      final formatted = "Lat: ${report.lat.toStringAsFixed(6)}, Lng: ${report.lng.toStringAsFixed(6)}";
      print("🌍 UI: Using formatted coordinates: $formatted");
      return formatted;
    }
    
    print("🌍 UI: No location data available");
    return "Location not available";
  }

  String _formatRadius(double radius) {
    if (radius == 0.0) {
      return "No radius";
    }
    // Convert meters to km if > 1000, otherwise show in meters
    if (radius >= 1000) {
      return "${(radius / 1000).toStringAsFixed(2)} Km";
    } else {
      return "${radius.toStringAsFixed(0)} Km";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          // Header with Device ID and Status
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Device ID
                Text(
                  '${report.deviceId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    report.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Map Section

          

          
         // Address Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: addressResponse == null 
              ? const AddressSkeleton(showStartEnd: false)
              : Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.activeDarkGreenColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getDisplayAddress(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
          
          const SizedBox(height: 16),
          
          // Details Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Created and Reached Row
                Row(
                  children: [
                    // Created
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Created:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                _formatDateTime(report.dateAdded),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Reached Row
                Row(
                  children: [
                    // Reached
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: AppColors.activeDarkGreenColor,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reached:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                _formatDateTime(report.reachDate),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.activeDarkGreenColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Radius Row
                Row(
                  children: [
                    Icon(
                      Icons.radar,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Radius',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatRadius(report.radius),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
} 