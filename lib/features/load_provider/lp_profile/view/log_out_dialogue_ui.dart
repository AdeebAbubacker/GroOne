import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_image.dart';

class LogOutDialogueUi extends StatelessWidget {
  const LogOutDialogueUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20.h,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, size: 24),
          ),
        ),

        // Illustration
        SvgPicture.asset(
          AppImage.svg.logOutImage,
          // replace with your image asset
          height: 150,
        ),

        // Title
        const Text(
          "Log Out?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        // Subtitle
        const Text(
          "You’ll be signed out from your account. Come back soon!",
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
