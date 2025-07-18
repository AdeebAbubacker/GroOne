// lib/features/gps_feature/presentation/widgets/summary_report_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/report_model.dart';

class SummaryReportCard extends StatelessWidget {
  final SummaryReport report;
  const SummaryReportCard({Key? key, required this.report}) : super(key: key);

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, hh:mm a').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLocationRow(
              icon: Icons.play_circle_filled,
              color: Colors.green,
              title: "Day Start",
              address: "Daily Summary",
              time: _formatDateTime(report.startTime),
            ),
            _buildDottedLine(),
            _buildLocationRow(
              icon: Icons.stop_circle,
              color: Colors.red,
              title: "Day End",
              address: "Daily Summary",
              time: _formatDateTime(report.endTime),
            ),
            const Divider(height: 32),
            _buildStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({required IconData icon, required Color color, required String title, required String address, required String time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(address, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0, top: 4, bottom: 4),
      child: Column(
        children: List.generate(4, (index) => Container(width: 2, height: 4, margin: const EdgeInsets.only(bottom: 2), color: Colors.grey[300])),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(Icons.social_distance, '${(report.distance / 1000).toStringAsFixed(2)} km', 'Distance'),
        _buildStatItem(Icons.speed, '${report.avgSpeed.toStringAsFixed(1)} km/h', 'Avg Speed'),
        _buildStatItem(Icons.speed, '${report.maxSpeed.toStringAsFixed(1)} km/h', 'Max Speed'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[800]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}