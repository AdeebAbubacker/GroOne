import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

class AppErrorWidget extends StatelessWidget {
  /// The error type containing the error message and details
  final ErrorType error;
  
  /// Callback function to be called when the retry button is pressed
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the error message
          Text(
            error.getText(context),
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Retry button
          TextButton(
            onPressed: onRetry,
            child: Text(
              AppString.label.refresh.capitalize,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 