import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

import '../../../vp-helper/vp_helper.dart';

class LoadStatusLabel extends StatelessWidget {
  final LoadStatus? loadStatus;
  final String? loadStatusTitle;
  final bool? loadOnHold;
  final String? statusBgColor;
  final String? statusTxtColor;
  const LoadStatusLabel({
    super.key,
    required this.loadStatus,
    this.loadStatusTitle,
    this.loadOnHold,
    this.statusBgColor,
    this.statusTxtColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: VpHelper.getColor(statusBgColor ?? '')
      ),
      child: Text(
        (loadOnHold??false) ? context.appText.unLoadingHeld:
        loadStatusTitle ?? "",
        style: AppTextStyle.body.copyWith(
          fontSize: 12,
          color: VpHelper.getColor(statusTxtColor ?? ''),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

}
