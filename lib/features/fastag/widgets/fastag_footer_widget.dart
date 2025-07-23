import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class FastagFooterWidget extends StatelessWidget {
  const FastagFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          // Cityscape background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightGreyIconBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: CustomPaint(
                painter: CityscapePainter(),
                size: const Size(double.infinity, 80),
              ),
            ),
          ),
          
          // Truck and branding
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                // Truck illustration
                Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.greyIconColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // Truck body
                      Positioned(
                        left: 5,
                        top: 8,
                        child: Container(
                          width: 25,
                          height: 15,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              '#gro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Truck wheels
                      Positioned(
                        left: 8,
                        bottom: 2,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 2,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                12.width,
                
                // Branding text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#gro',
                      style: AppTextStyle.h4.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Built with love from',
                      style: AppTextStyle.body3.copyWith(
                        color: AppColors.greyTextColor,
                        fontSize: 10,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.orangeTextColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Center(
                            child: Text(
                              '🇮🇳',
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ),
                        4.width,
                        Text(
                          'India',
                          style: AppTextStyle.body3.copyWith(
                            color: AppColors.greyTextColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CityscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.greyIconColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw simple building shapes
    final buildings = [
      Rect.fromLTWH(10, 20, 15, 60),
      Rect.fromLTWH(30, 30, 12, 50),
      Rect.fromLTWH(45, 25, 18, 55),
      Rect.fromLTWH(68, 35, 14, 45),
      Rect.fromLTWH(85, 20, 16, 60),
      Rect.fromLTWH(105, 30, 13, 50),
      Rect.fromLTWH(120, 25, 15, 55),
      Rect.fromLTWH(140, 35, 12, 45),
      Rect.fromLTWH(155, 20, 18, 60),
      Rect.fromLTWH(175, 30, 14, 50),
      Rect.fromLTWH(195, 25, 16, 55),
      Rect.fromLTWH(215, 35, 13, 45),
      Rect.fromLTWH(235, 20, 15, 60),
      Rect.fromLTWH(255, 30, 12, 50),
      Rect.fromLTWH(270, 25, 18, 55),
      Rect.fromLTWH(290, 35, 14, 45),
      Rect.fromLTWH(310, 20, 16, 60),
      Rect.fromLTWH(330, 30, 13, 50),
      Rect.fromLTWH(345, 25, 15, 55),
    ];

    for (final building in buildings) {
      canvas.drawRect(building, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 