import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';

class SuccessDialogView extends StatefulWidget {
  final String? message;
  final String? heading;
  final void Function()? onContinue;
  final void Function()? afterDismiss;
  const SuccessDialogView({super.key,  this.message,  this.heading, this.afterDismiss, this.onContinue});

  @override
  State<SuccessDialogView> createState() => _SuccessDialogViewState();
}

class _SuccessDialogViewState extends State<SuccessDialogView> {

  @override
  void initState() {
    initFunction(context);
    super.initState();
  }

  void initFunction(BuildContext context) => frameCallback(() async {
    await Future.delayed(Duration(seconds: 3));
    if(!context.mounted) return;
    widget.afterDismiss?.call();
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        20.height,

        Lottie.asset(AppJSON.success, width: 150, repeat: false, frameRate: FrameRate(120)),
        20.height,



        if(widget.heading != null)...[
          Text(widget.heading!, textAlign: TextAlign.center, style: AppTextStyle.greenColor20w700),
          20.height,
        ],


        if(widget.message != null)...[
          Text(widget.message!, textAlign: TextAlign.center, style: AppTextStyle.body1),
          20.height,
        ],


        if(widget.onContinue != null)...[
          AppButton(
            onPressed:widget.onContinue ?? (){},
            title: context.appText.continueText,
          ),
          10.height,
        ],


      ],
    );
  }
}
