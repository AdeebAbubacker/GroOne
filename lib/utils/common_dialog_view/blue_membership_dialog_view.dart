import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';


class BlueMembershipDialogView extends StatefulWidget {
  final String blueId;
  final void Function()? afterDismiss;
  const BlueMembershipDialogView({super.key, required this.blueId, this.afterDismiss});

  @override
  State<BlueMembershipDialogView> createState() => _BlueMembershipDialogViewState();
}

class _BlueMembershipDialogViewState extends State<BlueMembershipDialogView> {


  @override
  void initState() {
    initFunction(context);
    super.initState();
  }

  void initFunction(BuildContext context) => frameCallback(() async {
    await Future.delayed(Duration(seconds: 3));
    if(!context.mounted) return;
    if(widget.afterDismiss != null){
      widget.afterDismiss?.call();
    }
    Navigator.of(context).pop();
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        30.height,

        SvgPicture.asset(AppImage.svg.blueTick, height: 150),
        40.height,

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          decoration: commonContainerDecoration(color: AppColors.primaryColor),
          child: Text("${context.appText.blueMembershipId}: ${widget.blueId}", textAlign: TextAlign.center, style: AppTextStyle.h6WhiteColor),
        ),
        20.height,

        Text(context.appText.blueMemberShipIdSuccess, textAlign: TextAlign.center, style: AppTextStyle.h4),
        10.height,

        Text(context.appText.startExploringPremiumLoad, style: AppTextStyle.body3GreyColor, textAlign: TextAlign.center),
      ],
    ).paddingSymmetric(horizontal: 5);
  }
}
