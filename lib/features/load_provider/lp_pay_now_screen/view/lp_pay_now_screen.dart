import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';

class LpPayNowScreen extends StatelessWidget {
  const LpPayNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(    backgroundColor: AppColors.backgroundColor,
        title: "Make Payment",
      ),
    );
  }
}
