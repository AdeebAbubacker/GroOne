import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class EndhanErrorDialog {
  static void show(BuildContext context, dynamic errorType) {
    String errorMessage = 'An error occurred. Please try again.';

    // Debug logging for API response
    print('🔍 === ENDHAN ERROR DIALOG DEBUG ===');
    print('🔍 Error Type: ${errorType.runtimeType}');
    print('🔍 Error Type String: ${errorType.toString()}');
    
    if (errorType != null) {
      // Check if it's an ErrorType and use the getText method
      if (errorType is ErrorType) {
        errorMessage = errorType.getText(context);
        print('🔍 ErrorType.getText(): $errorMessage');
        
        // Additional logging for ErrorWithMessage
        if (errorType is ErrorWithMessage) {
          print('🔍 ErrorWithMessage Details:');
          print('  - Message: ${errorType.message}');
          print('  - Code: ${errorType.code}');
        }
      } else {
        // Fallback for non-ErrorType objects
        final errorString = errorType.toString();
        print('🔍 Non-ErrorType object: $errorString');
        
        // Try to extract message from ErrorWithMessage string representation
        if (errorString.contains('ErrorWithMessage')) {
          final messageStart = errorString.indexOf('message: ');
          if (messageStart != -1) {
            final messageEnd = errorString.lastIndexOf(')');
            if (messageEnd != -1) {
              errorMessage = errorString.substring(messageStart + 9, messageEnd);
              print('🔍 Extracted message from string: $errorMessage');
            }
          }
        } else {
          // Clean up generic error type names
          errorMessage = errorString
              .replaceAll('Instance of \'', '')
              .replaceAll('\'', '')
              .replaceAll('Error', ' error');
          print('🔍 Cleaned error message: $errorMessage');
        }
      }
    }
    
    print('🔍 Final Error Message: $errorMessage');
    print('🔍 === END ERROR DIALOG DEBUG ===');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
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
                'OK',
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