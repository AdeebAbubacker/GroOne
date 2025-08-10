import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';

class LicenseCategoryDropdown extends StatelessWidget {
  final String? selected;
  final ValueChanged<LicenseCategoryResponseModel?> onChanged;

  const LicenseCategoryDropdown({
    Key? key,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateUI = context.watch<ProfileCubit>().state.licneseCategoryResponseUIState;
    final categoryList = stateUI?.data ?? [];

    return SearchableDropdown(
      labelText: context.appText.licenseCategory,
      mandatoryStar: true,
      selectedItem: selected,
      items: categoryList.map((e) => e.categoryName ?? '').toList(),
      hintText: context.appText.selectLicenseCategory,
      onChanged: (String? newValue) {
        if (newValue != null) {
          final selectedCategory = categoryList.firstWhere(
            (e) => e.categoryName == newValue,
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
          const Center(child: Text("No License found")),
    );
  }
}
