

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class BloodCategoryDropdown extends StatelessWidget {
  final String? selected;
  final ValueChanged<BloodGroupResponseModel?> onChanged;

  const BloodCategoryDropdown({
    Key? key,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateUI = context.watch<ProfileCubit>().state.bloodGroupResponseUIState;
    final stateList = stateUI?.data ?? [];

    return SearchableDropdown(
      labelText: context.appText.bloodGroup,
      mandatoryStar: true,
      selectedItem: selected,
      items: stateList.map((e) => e.groupName ?? '').toList(),
      hintText: context.appText.selectbloodGroup,
      onChanged: (String? newValue) {
        if (newValue != null) {
          final selectedCategory = stateList.firstWhere(
            (e) => e.groupName == newValue,
          );
          onChanged(selectedCategory);
        }
      },
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null || selectedItem.isEmpty) {
          return const SizedBox.shrink();
        }
        return Row(children: [Text(selectedItem)]);
      },
      emptyBuilder: (context, _) =>
          const Center(child: Text("No Blood Group found")),
    );
  }
}

