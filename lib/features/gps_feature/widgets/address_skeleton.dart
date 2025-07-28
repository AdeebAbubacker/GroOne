// lib/features/gps_feature/widgets/address_skeleton.dart
import 'package:flutter/material.dart';

class AddressSkeleton extends StatefulWidget {
  final bool showStartEnd; // Whether to show start/end addresses or just single address

  const AddressSkeleton({
    Key? key,
    this.showStartEnd = true,
  }) : super(key: key);

  @override
  State<AddressSkeleton> createState() => _AddressSkeletonState();
}

class _AddressSkeletonState extends State<AddressSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
        return widget.showStartEnd ? _buildStartEndSkeleton() : _buildSingleSkeleton();
      },
    );
  }

  Widget _buildStartEndSkeleton() {
    return Column(
      children: [
        Row(
          children: [
            _buildShimmerCircle(4, Colors.green),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerBox(double.infinity, 16)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildShimmerCircle(4, Colors.red),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerBox(double.infinity, 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleSkeleton() {
    return Row(
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
            (_animation.value - 0.3).clamp(0.0, 1.0),
            _animation.value.clamp(0.0, 1.0),
            (_animation.value + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCircle(double radius, Color baseColor) {
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
            (_animation.value - 0.3).clamp(0.0, 1.0),
            _animation.value.clamp(0.0, 1.0),
            (_animation.value + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }
} 