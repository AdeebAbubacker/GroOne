import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/model/searchable_dropdown_menu_item.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class BloodCategoryDropdown extends StatelessWidget {
  final BloodGroupResponseModel? selectedCategory;
  final ValueChanged<BloodGroupResponseModel?> onChanged;
  final bool isEdit;

  const BloodCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.appText.bloodGroup, style: AppTextStyle.textFiled),
            const SizedBox(width: 2),
            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
            color: isEdit ? AppColors.lightGreyColor : Colors.white,
          ),
          child: SearchableDropdown<BloodGroupResponseModel>.paginated(
            hintText: Text(context.appText.selectbloodGroup, style: AppTextStyle.textFieldHint),
            isDialogExpanded: false,
            requestItemCount: 10,
            dialogOffset: 0,
            /// initial value
            initialValue: selectedCategory != null
                ? SearchableDropdownMenuItem<BloodGroupResponseModel>(
                    value: selectedCategory!,
                    label: selectedCategory!.groupName ?? '',
                    child: Text(selectedCategory!.groupName ?? ''),
                  )
                : null,

            /// fetch items with pagination
           paginatedRequest: (int page, String? searchKey) async {
          final cubit = context.read<ProfileCubit>();

          // Fetch all blood groups only once if not already fetched
          if (cubit.state.bloodGroupResponseUIState?.data == null ||
              cubit.state.bloodGroupResponseUIState!.data!.isEmpty) {
            await cubit.fetchBloodGroup();
          }

          final allGroups = cubit.state.bloodGroupResponseUIState?.data ?? [];

          // Apply local search
          final filteredGroups = (searchKey == null || searchKey.isEmpty)
              ? allGroups
              : allGroups.where((g) =>
                  (g.groupName ?? '').toLowerCase().contains(searchKey.toLowerCase())
                ).toList();

          return filteredGroups.map((e) {
            return SearchableDropdownMenuItem<BloodGroupResponseModel>(
              value: e,
              label: e.groupName ?? '',
              child: Text(e.groupName ?? ''),
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
