import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class MobileNumberTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String countryCode;
  final String countryFlagAssetPath;
  final bool? disableView;
  final bool? readOnly;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const MobileNumberTextField({
    super.key,
    this.controller,
    this.hintText,
    this.countryCode = "+91",
    required this.countryFlagAssetPath,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.disableView,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: (disableView ?? false) ? AppColors.greyIconBackgroundColor : Colors.white,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          child: Row(
            children: [
              Image.asset(countryFlagAssetPath, height: 20),
              const SizedBox(width: 8),
              Text(
                countryCode,
                style: AppTextStyle.textFieldHintBlackColor,
              ),
            ],
          ),
        ),
        10.width,
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          onChanged: onChanged,
          readOnly: readOnly ?? false,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: AppTextStyle.textFiled.copyWith(color: AppColors.primaryTextColor),
          cursorColor: AppColors.lightGreyTextColor,
          decoration: InputDecoration(
            fillColor: (disableView ?? false ) ? AppColors.greyIconBackgroundColor : Colors.white,
            hintText: hintText ?? "Enter your mobile number",
            hintStyle: AppTextStyle.textFieldHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderColor), // same as default
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),

        ).expand(),
      ],
    );
  }
}
