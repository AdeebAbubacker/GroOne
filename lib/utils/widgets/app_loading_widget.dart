import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';

/// Reusable loading widget for displaying loading states throughout the app
/// 
/// This widget:
/// - Shows a centered circular progress indicator
/// - Uses the app's primary color for consistency
/// - Can be used in any screen that needs to show a loading state
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }
} 