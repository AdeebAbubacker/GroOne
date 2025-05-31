import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class SuccessDialogView extends StatefulWidget {
  final String? message;
  final String? heading;
  const SuccessDialogView({super.key,  this.message,  this.heading});

  @override
  State<SuccessDialogView> createState() => _SuccessDialogViewState();
}

class _SuccessDialogViewState extends State<SuccessDialogView> {

  @override
  void initState() {
    initFunction(context);
    super.initState();
  }

  void initFunction(BuildContext context) => addPostFrameCallback(() async {
    await Future.delayed(Duration(seconds: 2));
    if(!context.mounted) return;
    Navigator.of(context).pop();

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        20.height,
        Image.asset(AppImage.png.successGif),
        SizedBox(height: 50),

        if(widget.message != null)
        Text(widget.message!, textAlign: TextAlign.center, style: AppTextStyle.greenColor20w700),
        30.height,

        if(widget.heading != null)
        Text(
          widget.heading!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        12.height,
      ],
    );
  }
}
