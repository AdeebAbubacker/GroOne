

import 'package:flutter/material.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/VpCompanyTypeModel.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class VpCompanyTypeSearchableDropdown extends StatelessWidget {
  final String? selectedCompanyTypeId;
  final ValueChanged<String?> onCompanyTypeChanged;
  final List<VpCompanyTypeModel> companyTypeList;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;

  const VpCompanyTypeSearchableDropdown({
    super.key,
    required this.selectedCompanyTypeId,
    required this.onCompanyTypeChanged,
    required this.companyTypeList,
    required this.labelText,
    required this.hintText,
    this.mandatoryStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final companyTypeNames = companyTypeList.map((e) => e.companyType.toString()).toList();

    final selectedItem = selectedCompanyTypeId != null
        ? companyTypeList.firstWhere(
            (e) => e.id.toString() == selectedCompanyTypeId,
          ).companyType.toString()
        : null;

    return SearchableDropdown(
      key: key,
      labelText: labelText,
      mandatoryStar: mandatoryStar,
      selectedItem: selectedItem?.isEmpty ?? true ? null : selectedItem,
      items: companyTypeNames,
      hintText: hintText,
      onChanged: (String? newCompanyTypeName) {
        if (newCompanyTypeName != null) {
          final selectedCompanyType = companyTypeList.firstWhere(
            (e) => e.companyType.toString() == newCompanyTypeName,
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
      emptyBuilder: (context, _) => Center(child: Text("No company types found")),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/VpCompanyTypeModel.dart';
// import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';
// import 'package:gro_one_app/utils/app_text_style.dart';

// class VpCompanyTypeSearchableDropdown extends StatelessWidget {
//   final String? selectedCompanyTypeId;
//   final ValueChanged<String?> onCompanyTypeChanged;
//   final Future<List<VpCompanyTypeModel>> Function(int page, String? searchKey) fetchCompanyTypes;
//   final String labelText;
//   final String hintText;
//   final bool mandatoryStar;

//   const VpCompanyTypeSearchableDropdown({
//     super.key,
//     required this.selectedCompanyTypeId,
//     required this.onCompanyTypeChanged,
//     required this.fetchCompanyTypes,
//     required this.labelText,
//     required this.hintText,
//     this.mandatoryStar = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(labelText, style: AppTextStyle.textFiled),
//             if (mandatoryStar)
//               Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade400),
//             borderRadius: BorderRadius.circular(4),
//             color: Colors.white,
//           ),
//           child: SearchableDropdown<VpCompanyTypeModel>.paginated(
//             hintText: Text(hintText, style: AppTextStyle.textFieldHint),
//             isDialogExpanded: false,
//             requestItemCount: 10,

//             // Initial selected value
//             initialValue: selectedCompanyTypeId != null
//                 ? SearchableDropdownMenuItem<VpCompanyTypeModel>(
//                     value: null, // We will resolve the selected item in paginatedRequest
//                     label: '',
//                     child: const SizedBox.shrink(),
//                   )
//                 : null,

//             // Pagination request
//             paginatedRequest: (int page, String? searchKey) async {
//               final companyTypes = await fetchCompanyTypes(page, searchKey);
//               return companyTypes.map((company) {
//                 return SearchableDropdownMenuItem<VpCompanyTypeModel>(
//                   value: company,
//                   label: company.companyType.toString(),
//                   child: Text(company.companyType.toString()),
//                 );
//               }).toList();
//             },

//             onChanged: (VpCompanyTypeModel? newCompany) {
//               onCompanyTypeChanged(newCompany?.id.toString());
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
