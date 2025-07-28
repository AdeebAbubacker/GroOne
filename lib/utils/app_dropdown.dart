import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

class AppDropdown extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final InputDecoration? decoration;
  final Widget? prefixIcon;
  final bool? mandatoryStar;
  final String? dropdownValue;
  final List<DropdownMenuItem<String>> dropDownList;
  final String? Function(String?)? validator;
  final TextStyle? labelTextStyle;
  final Function(String?)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? onSaved;
  final bool enabled;

  const AppDropdown({
    super.key,
    this.labelText,
    this.hintText,
    this.labelTextStyle,
    this.currentFocus,
    this.nextFocus,
    this.decoration,
    this.prefixIcon,
    required this.dropdownValue,
    required this.dropDownList,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.mandatoryStar = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              Text(" $labelText", style: labelTextStyle ?? AppTextStyle.body3),
              if(mandatoryStar == true)
                Text(" *", style:labelTextStyle ?? AppTextStyle.textFiled.copyWith(color: Colors.red)),
            ],
          ),
        if (labelText != null) 6.height,
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            dropdownColor: AppColors.scaffoldBackgroundColor,
            isExpanded: false,
            enableFeedback: true,
            decoration: enabled 
                ? (decoration ?? commonInputDecoration())
                : (decoration ?? commonInputDecoration()).copyWith(
                    fillColor: Colors.grey.shade100,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(commonRadius),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(commonRadius),
                    ),
                  ),
            focusNode: currentFocus,
            borderRadius: BorderRadius.circular(commonRadius),
            value: dropdownValue,
            style: enabled ? AppTextStyle.textFiled : AppTextStyle.textFiled.copyWith(color: Colors.grey),
            hint: hintText != null ? Text(hintText.capitalizeFirst, style: enabled ? AppTextStyle.textFieldHint : AppTextStyle.textFieldHint.copyWith(color: Colors.grey)) : null,
            items: dropDownList,
            onChanged: enabled ? onChanged : null,
            onTap: enabled ? onTap : null,
            onSaved: enabled ? onSaved : null,
            validator: enabled ? validator : null,
          ),
        ),
      ],
    );
  }
}
