// lib/features/gps_feature/widgets/skeleton_report_card.dart
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';

class SkeletonReportCard extends StatefulWidget {
  final ReportCardType type;
  
  const SkeletonReportCard({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<SkeletonReportCard> createState() => _SkeletonReportCardState();
}

class _SkeletonReportCardState extends State<SkeletonReportCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: _buildSkeletonContent(),
        );
      },
    );
  }

  Widget _buildSkeletonContent() {
    switch (widget.type) {
      case ReportCardType.trip:
        return _buildTripSkeleton();
      case ReportCardType.stop:
        return _buildStopSkeleton();
      case ReportCardType.summary:
        return _buildSummarySkeleton();
      default:
        return _buildGenericSkeleton();
    }
  }

  Widget _buildTripSkeleton() {
    return Column(
      children: [
        // Header section
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(60, 24),
              _buildShimmerBox(80, 24),
            ],
          ),
        ),
        
        // Address section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildShimmerCircle(8),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShimmerBox(double.infinity, 16)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildShimmerCircle(8),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShimmerBox(double.infinity, 16)),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Stats section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatSkeleton(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatSkeleton(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatSkeleton(),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStopSkeleton() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(80, 20),
              _buildShimmerBox(60, 20),
            ],
          ),
        ),
        
        // Address
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerBox(double.infinity, 16)),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _buildDetailSkeleton()),
              const SizedBox(width: 12),
              Expanded(child: _buildDetailSkeleton()),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSummarySkeleton() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(100, 24),
              _buildShimmerBox(80, 20),
            ],
          ),
        ),
        
        // Address section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildShimmerCircle(8),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShimmerBox(double.infinity, 16)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildShimmerCircle(8),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShimmerBox(double.infinity, 16)),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Stats grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatSkeleton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatSkeleton()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatSkeleton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatSkeleton()),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGenericSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildShimmerBox(double.infinity, 20),
          const SizedBox(height: 12),
          _buildShimmerBox(double.infinity, 16),
          const SizedBox(height: 12),
          _buildShimmerBox(200, 16),
        ],
      ),
    );
  }

  Widget _buildStatSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerBox(40, 12),
          const SizedBox(height: 4),
          _buildShimmerBox(60, 14),
        ],
      ),
    );
  }

  Widget _buildDetailSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerBox(50, 12),
          const SizedBox(height: 4),
          _buildShimmerBox(80, 14),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment(-1.0, 0.0),
          end: Alignment(1.0, 0.0),
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: [
            _animation.value - 0.3,
            _animation.value,
            _animation.value + 0.3,
          ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
        ),
      ),
    );
  }

  Widget _buildShimmerCircle(double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(-1.0, 0.0),
          end: Alignment(1.0, 0.0),
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: [
            _animation.value - 0.3,
            _animation.value,
            _animation.value + 0.3,
          ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
        ),
      ),
    );
  }
}

enum ReportCardType {
  trip,
  stop,
  summary,
  dailyKm,
  reachability,
} 