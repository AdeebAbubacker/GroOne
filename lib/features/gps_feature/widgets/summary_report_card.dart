// lib/features/gps_feature/widgets/summary_report_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_colors.dart';
import '../model/address_model.dart';
import '../model/report_model.dart';
import 'address_skeleton.dart';

class SummaryReportCard extends StatelessWidget {
  final SummaryReport report;
  final SummaryAddressResponse? addressResponse;
  
  const SummaryReportCard({
    Key? key, 
    required this.report,
    this.addressResponse,
  }) : super(key: key);

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatDecimal(double value) {
    // Format similar to Java's DecimalFormat("##.##")
    final formatter = NumberFormat("##.##");
    return formatter.format(value);
  }

  String _calculateTotalViolations() {
    // Sum of all safety violations similar to trip report
    int sum = report.harshBraking + report.harshCornering + report.harshAcceleration + report.overSpeed;
    return sum.toString();
  }

  /// Get color based on driving safety score
  /// Logic from Android:
  /// - score <= 7.5: Red
  /// - score >= 8.75: Light Green
  /// - score > 7.5 && score < 8.75: Yellow
  /// - else: White
  Color _getSafetyScoreColor() {
    final safetyScore = report.safetyScore;
    
    if (safetyScore <= 7.5) {
      return AppColors.appRedColor; // Red
    } else if (safetyScore >= 8.75) {
      return const Color(0xFF4CAF50); // Light Green
    } else if (safetyScore > 7.5 && safetyScore < 8.75) {
      return const Color(0xFFFFC107); // Yellow
    } else {
      return Colors.white; // White
    }
  }

  String _getDisplayAddress({required bool isStart}) {
    // If we have real addresses from reverse geocoding, use them
    if (addressResponse != null) {
      final realAddress = isStart ? addressResponse!.startAddress : addressResponse!.endAddress;
      if (realAddress != "No Address") {
        return realAddress;
      }
    }
    
    // Fallback to formatted coordinates from the report
    final rawAddress = isStart ? report.startAddress : report.endAddress;
    
    if (rawAddress.contains(',')) {
      final parts = rawAddress.split(',');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0].trim()) ?? 0.0;
        final lng = double.tryParse(parts[1].trim()) ?? 0.0;
        
        // If coordinates are 0,0 (invalid GPS), show dash
        if (lat == 0.0 && lng == 0.0) {
          return "-";
        }
        
        return "Lat: ${lat.toStringAsFixed(6)}\nLng: ${lng.toStringAsFixed(6)}";
      }
    }
    
    return rawAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeaderSection(),
          const SizedBox(height: 20),
          
          // Location Timeline Section
          _buildLocationTimelineSection(),
          const SizedBox(height: 20),
          
          // Metrics Grid Section
          _buildMetricsGridSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Date and Safety Count
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(report.reportDate),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_calculateTotalViolations()} Safety count',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        // Right side - Color Code
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Color Code',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _getSafetyScoreColor(),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationTimelineSection() {
    // Check if addresses are available
    if (addressResponse == null) {
      // Show skeleton while addresses are loading
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const AddressSkeleton(showStartEnd: true),
      );
    }

    return Column(
      children: [
        // Start Location
        _buildLocationRow(
          isStart: true,
          address: _getDisplayAddress(isStart: true),
          time: _formatDateTime(report.startTime),
        ),
        const SizedBox(height: 16),
        // End Location
        _buildLocationRow(
          isStart: false,
          address: _getDisplayAddress(isStart: false),
          time: _formatDateTime(report.endTime),
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required bool isStart,
    required String address,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location icon
        Container(
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.only(top: 2),
          child: Icon(
            isStart ? Icons.my_location : Icons.location_on,
            color: isStart ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        
        // Address and time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGridSection() {
    return Column(
      children: [
        // First row - Distance and Avg Speed
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.place,
                iconColor: const Color(0xFF2196F3),
                value: '${_formatDecimal(report.distance)} Kms',
                label: 'Distance',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.speed,
                iconColor: const Color(0xFF2196F3),
                value: '${report.avgSpeed} Km/hr',
                label: 'Avg. Speed',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Second row - Engine ON and Idle Time
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.access_time,
                iconColor: const Color(0xFF2196F3),
                value: report.engineTime,
                label: 'Engine ON',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.warning_amber_outlined,
                iconColor: const Color(0xFF2196F3),
                value: report.idleTime,
                label: 'Idle Time',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          
          // Value and Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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