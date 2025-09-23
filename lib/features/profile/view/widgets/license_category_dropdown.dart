import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/model/searchable_dropdown_menu_item.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class LicenseCategoryDropdown extends StatelessWidget {
  final LicenseCategoryResponseModel? selectedCategory;
  final ValueChanged<LicenseCategoryResponseModel?> onChanged;

  const LicenseCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.appText.licenseCategory, style: AppTextStyle.textFiled),
            const SizedBox(width: 2),
            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<LicenseCategoryResponseModel>.paginated(
            dialogOffset: 0,
            hintText: Text(context.appText.selectLicenseCategory, style: AppTextStyle.textFieldHint),
            isDialogExpanded: false,
            requestItemCount: 10,

            /// initial value
            initialValue: selectedCategory != null
                ? SearchableDropdownMenuItem<LicenseCategoryResponseModel>(
                    value: selectedCategory!,
                    label: selectedCategory!.categoryName ?? '',
                    child: Text(selectedCategory!.categoryName ?? ''),
                  )
                : null,

            /// fetch items with pagination
            paginatedRequest: (int page, String? searchKey) async {
              final cubit = context.read<ProfileCubit>();
              await cubit.fetchLicenseCategory();

              // Get full list
              final categories = cubit.state.licneseCategoryResponseUIState?.data ?? [];
              final filteredCategories = (searchKey == null || searchKey.isEmpty)
                  ? categories
                  : categories.where((c) =>
                      (c.categoryName ?? '')
                          .toLowerCase()
                          .contains(searchKey.toLowerCase())).toList();

              return filteredCategories.map((category) {
                return SearchableDropdownMenuItem<LicenseCategoryResponseModel>(
                  value: category,
                  label: category.categoryName ?? '',
                  child: Text(category.categoryName ?? ''),
                );
              }).toList();
            },


            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
