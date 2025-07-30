import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

import '../../../vp-helper/vp_helper.dart';

class LoadStatusLabel extends StatelessWidget {
  final LoadStatus? loadStatus;
  final String? loadStatusTitle;
  final bool? loadOnHold;

  const LoadStatusLabel({
    super.key,
    required this.loadStatus,
    this.loadStatusTitle,
    this.loadOnHold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _getBackgroundColor(),
      ),
      child: Text(
        (loadOnHold??false) ? context.appText.unLoadingHeld:
        loadStatusTitle ?? "",
        style: AppTextStyle.body.copyWith(
          fontSize: 12,
          color: _getTextColor(),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if(loadOnHold??false){
     return AppColors.iconRed;
    }
    switch (loadStatus) {
      case LoadStatus.inTransit:
        return const Color(0xffFF5722).withOpacity(0.3);
      case LoadStatus.unloading:
        return AppColors.teal.withOpacity(0.3);
      case LoadStatus.completed:
        return AppColors.activeDarkGreenColor;
      case LoadStatus.podDispatched:
      return Color(0xff42A5F5);
      default:
        return AppColors.activeDarkGreenColor.withAlpha(64);
    }
  }

  Color _getTextColor() {
    if(loadOnHold??false){
      return AppColors.white;
    }
    switch (loadStatus) {
      case LoadStatus.inTransit:
        return const Color(0xffFF5722);
      case LoadStatus.completed || LoadStatus.podDispatched:
        return Colors.white;
      case LoadStatus.unloading:
        return Colors.teal;
      default:
        return AppColors.activeDarkGreenColor;
    }
  }


}
