import 'package:flutter/material.dart';
import 'package:gro_one_app/features/fastag/widgets/fastag_footer_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class FastagEmptyStateWidget extends StatelessWidget {
  const FastagEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Empty state illustration
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyIconBackgroundColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Stack(
                    children: [
                      // Folder icon
                      Positioned(
                        left: 30,
                        top: 25,
                        child: Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.folder_outlined,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      // X mark on folder
                      Positioned(
                        right: 30,
                        top: 25,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.greyIconColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      // Person icon
                      Positioned(
                        right: 25,
                        top: 35,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Question mark
                      Positioned(
                        right: 15,
                        top: 15,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.orangeTextColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                24.height,
                
                // No FASTag found text
                Text(
                  context.appText.noFastagFound,
                  style: AppTextStyle.h3.copyWith(
                    color: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                16.height,
                
                // Description text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'You don\'t have any FASTags yet. Add your first FASTag to get started.',
                    style: AppTextStyle.body2.copyWith(
                      color: AppColors.greyTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Footer with branding
        const FastagFooterWidget(),
      ],
    );
  }
} 