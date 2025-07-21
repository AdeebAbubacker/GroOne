import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
class AppMultilineTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final FocusNode? focusNode;
  final Function(String)? onChanged;

  const AppMultilineTextField({
    super.key,
    this.controller,
    this.hintText = "Enter remarks...",
    this.maxLines = 5,
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      onChanged: onChanged,
      style: AppTextStyle.textFiled.copyWith(color: AppColors.primaryTextColor),
      decoration: commonInputDecoration(hintText: hintText),
    );
  }
}
