import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/remove_space_inpur_formatter.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Color? inputTextColor;
  final Color? cursorColor;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool? mandatoryStar;
  final bool? readOnly;
  final bool? showCursor;
  final bool? autofocus;
  final Function()? onTextFieldTap;
  final int? maxLines;
  final bool? obscureText;
  final bool? ignorePointers;
  final TextStyle? labelTextStyle;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  const AppTextField({
    super.key,
      this.controller,
      this.labelTextStyle,
      this.decoration,
      this.onTextFieldTap,
      this.labelText,
      this.inputTextColor,
      this.cursorColor,
      this.inputFormatters,
      this.textAlign = TextAlign.start,
      this.validator,
      this.onFieldSubmitted,
      this.currentFocus,
      this.nextFocus,
      this.keyboardType,
      this.readOnly,
      this.showCursor,
      this.autofocus,
      this.maxLines,
      this.obscureText,
      this.ignorePointers,
      this.maxLength,
      this.textInputAction,
      this.hintText,
      this.onChanged,
    this.autofillHints,
    this.mandatoryStar = false,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (labelText != null)
          Row(
            children: [
              Text(" $labelText", style:labelTextStyle ?? AppTextStyle.textFiled),
              if(mandatoryStar == true)
              Text(" *", style:labelTextStyle ?? AppTextStyle.textFiled.copyWith(color: Colors.red)),
            ],
          ),
        if (labelText != null)
          6.height,
        TextFormField(
          enabled: enabled ?? true,
          validator: validator,
          inputFormatters: inputFormatters ?? [],
          textAlign: textAlign ?? TextAlign.start,
          controller: controller,
          focusNode: currentFocus,
          cursorColor: cursorColor ?? AppColors.lightGreyTextColor,
          cursorWidth: 1.5,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          obscureText: obscureText ?? false,
          obscuringCharacter: "•",
          cursorRadius: const Radius.circular(5),
          readOnly: readOnly ?? false,
          autofocus: autofocus ?? false,
          showCursor: showCursor,
          ignorePointers: ignorePointers,
          style: AppTextStyle.textFiled.copyWith(color:  inputTextColor ?? AppColors.primaryTextColor),
          decoration: decoration ?? commonInputDecoration(hintText: hintText),
          maxLength: maxLength,
          autofillHints: autofillHints,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted ??
              (value) {
                try {
                  fieldFocusChange(context, current: currentFocus!, nextFocus: nextFocus!);
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
          onTap: onTextFieldTap ?? () {},
          textCapitalization: textCapitalization,
        ),
      ],
    );
  }
}
