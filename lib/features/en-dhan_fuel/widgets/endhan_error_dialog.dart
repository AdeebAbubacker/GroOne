import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

class EndhanErrorDialog {
  static void show(BuildContext context, dynamic errorType) {
    String errorMessage = context.appText.anErrorOccurred;

    if (errorType != null) {
      // Check if it's an ErrorType and use the getText method
      if (errorType is ErrorType) {
        errorMessage = errorType.getText(context);
        
        // Additional logging for ErrorWithMessage
        if (errorType is ErrorWithMessage) {
          // ErrorWithMessage details available
        }
      } else {
        // Fallback for non-ErrorType objects
        final errorString = errorType.toString();
        
        // Try to extract message from ErrorWithMessage string representation
        if (errorString.contains('ErrorWithMessage')) {
          final messageStart = errorString.indexOf('message: ');
          if (messageStart != -1) {
            final messageEnd = errorString.lastIndexOf(')');
            if (messageEnd != -1) {
              errorMessage = errorString.substring(messageStart + 9, messageEnd);
            }
          }
        } else {
          // Clean up generic error type names
          errorMessage = errorString
              .replaceAll('Instance of \'', '')
              .replaceAll('\'', '')
              .replaceAll('Error', ' error');
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.appText.error,
            style: AppTextStyle.body1.copyWith(color: Colors.red),
          ),
          content: Text(errorMessage, style: AppTextStyle.body3),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset customer creation state to allow retry
                final cubit = locator<EnDhanCubit>();
                cubit.resetCustomerCreationState();
              },
              child: Text(
                context.appText.ok,
                style: AppTextStyle.body3.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 