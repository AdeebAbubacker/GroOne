

import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class CommodityTypeDropdown extends StatelessWidget {
  final String? selectedCommodityTypeId;
  final ValueChanged<String?> onCompanyTypeChanged;
  final List<LoadCommodityListModel> companyTypeList;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;

  const CommodityTypeDropdown({
    super.key,
    required this.selectedCommodityTypeId,
    required this.onCompanyTypeChanged,
    required this.companyTypeList,
    required this.labelText,
    required this.hintText,
    this.mandatoryStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final companyTypeNames = companyTypeList.map((e) => e.name.toString()).toList();

    final selectedItem = selectedCommodityTypeId != null
        ? companyTypeList.firstWhere(
            (e) => e.id.toString() == selectedCommodityTypeId,
          ).name.toString()
        : null;

    return SearchableDropdown(
      labelText: labelText,
      mandatoryStar: mandatoryStar,
      selectedItem: selectedItem?.isEmpty ?? true ? null : selectedItem,
      items: companyTypeNames,
      hintText: hintText,
      onChanged: (String? newCompanyTypeName) {
        if (newCompanyTypeName != null) {
          final selectedCompanyType = companyTypeList.firstWhere(
            (e) => e.name.toString() == newCompanyTypeName,
          );
          onCompanyTypeChanged(selectedCompanyType.id.toString());
                }
      },
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null || selectedItem.isEmpty) {
          return SizedBox.shrink();
        }
        return Row(
          children: [
            Text(selectedItem, style: AppTextStyle.body),
          ],
        );
      },
      emptyBuilder: (context, _) => Center(child: Text("No commodities types found")),
    );
  }
}
