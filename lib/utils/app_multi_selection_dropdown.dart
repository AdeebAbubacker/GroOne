import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class AppMultiSelectionDropdown<T extends Object> extends StatelessWidget {
  final String? labelText;
  final TextStyle? labelTextStyle;
  final String? hintText;
  final MultiSelectController<T> controller;
  final bool? mandatoryStar;
  final List<DropdownItem<T>> items;
  final void Function(List<T>)? onSelectionChange;
  final String? Function(List<DropdownItem<T>>?)? validator;
  final Widget? prefixIcon;
  final String? headerText;
  final bool showValidationError;
  final Function(String searchChanged)? onSearchChanged;
  final VoidCallback? onTap;

  const AppMultiSelectionDropdown({
    super.key,
    this.labelText,
    this.labelTextStyle,
    this.hintText,
    required this.controller,
    required this.items,
    this.onSelectionChange,
    this.validator,
    this.prefixIcon,
    this.headerText, 
    this.mandatoryStar = false,
    this.showValidationError = false,
    this.onTap,
    this.onSearchChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              Text(" ${labelText.capitalize}", style:labelTextStyle ?? AppTextStyle.textFiled),
              if(mandatoryStar == true)
                Text(" *", style:labelTextStyle ?? AppTextStyle.textFiled.copyWith(color: Colors.red)),
            ],
          ),
        if (labelText != null) 6.height,
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              // Dismiss keyboard when dropdown loses focus
              FocusScope.of(context).unfocus();
            }
          },
          child: Listener(
            onPointerDown: (_) {
              // Dismiss keyboard when tapping on dropdown
              FocusScope.of(context).unfocus();
              if (onTap != null) {
                onTap!();
              }
            },
            child: MultiDropdown<T>(
              key: key,
              controller: controller,
              items: items,
              enabled: true,
              searchEnabled: true,
              validator: null, // Disable built-in validator to avoid maroon error text
              onSelectionChange: onSelectionChange,
              fieldDecoration: FieldDecoration(
                padding: const EdgeInsets.all(14),
                hintText: hintText ?? '',
                hintStyle: AppTextStyle.textFieldHint,
                prefixIcon: prefixIcon,
                backgroundColor: AppColors.textFieldFillColor,
                border: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.borderColor, width: 1), borderRadius: BorderRadius.circular(commonTexFieldRadius)),
                focusedBorder: OutlineInputBorder(borderSide:  BorderSide(color: AppColors.secondaryColor, width: 1), borderRadius: BorderRadius.circular(commonTexFieldRadius)),
                errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 1.5), borderRadius: BorderRadius.circular(commonTexFieldRadius)),
              ),
              dropdownDecoration: DropdownDecoration(
                elevation: 10,
                marginTop: 0,
                maxHeight: 400,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(commonTexFieldRadius),
                header: headerText != null
                    ? Text(headerText!, textAlign: TextAlign.start, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold))
                    : null,
              ),

              dropdownItemDecoration: DropdownItemDecoration(
                selectedIcon: Icon(Icons.check_box, color: AppColors.primaryColor),
                disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
              ),

              searchDecoration: SearchFieldDecoration(
                hintText: "Search",
                border: OutlineInputBorder(borderSide: const BorderSide(width: 1, color: AppColors.borderColor), borderRadius: BorderRadius.circular(commonTexFieldRadius)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.secondaryColor, width: 1), borderRadius: BorderRadius.circular(commonTexFieldRadius)),
              ),


              chipDecoration: ChipDecoration(
                backgroundColor: AppColors.primaryColor,
                wrap: true,
                spacing: 10,
                runSpacing: 6,
                labelStyle: AppTextStyle.body3WhiteColor,
                deleteIcon: Icon(Icons.clear, color: Colors.white, size: 18)
              ),

          ),
        )),
        // Add custom error text display in red color only when validation is triggered
        if (validator != null && showValidationError)
          Builder(
            builder: (context) {
              final errorText = validator!(controller.selectedItems);
              if (errorText != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
