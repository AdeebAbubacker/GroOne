import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';

/// Reusable app bar widget for consistent navigation throughout the app
/// 
/// This widget:
/// - Provides a consistent app bar design across all screens
/// - Automatically shows back button when navigation is possible
/// - Supports custom actions and title positioning
/// - Uses the app's color scheme for consistency
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar
  final String title;
  
  /// Whether to center the title text (default: true)
  final bool centreTile;
  
  /// Optional list of action buttons to display on the right side
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.centreTile = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: centreTile,
      // Show back button only if navigation is possible
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 