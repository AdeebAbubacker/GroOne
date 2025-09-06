

// import 'package:flutter/material.dart';
// import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_model.dart';
// import 'package:gro_one_app/utils/app_searchabledropdown.dart';
// import 'package:gro_one_app/utils/app_text_style.dart';

// class CompanyTypeSearchableDropdown extends StatelessWidget {
//   final String? selectedCompanyTypeId;
//   final ValueChanged<String?> onCompanyTypeChanged;
//   final List<LpCompanyTypeModel> companyTypeList;
//   final String labelText;
//   final String hintText;
//   final bool mandatoryStar;

//   const CompanyTypeSearchableDropdown({
//     super.key,
//     required this.selectedCompanyTypeId,
//     required this.onCompanyTypeChanged,
//     required this.companyTypeList,
//     required this.labelText,
//     required this.hintText,
//     this.mandatoryStar = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final companyTypeNames = companyTypeList.map((e) => e.companyType.toString()).toList();

//     final selectedItem = selectedCompanyTypeId != null
//         ? companyTypeList.firstWhere(
//             (e) => e.id.toString() == selectedCompanyTypeId,
//           ).companyType.toString()
//         : null;

//     return SearchableDropdown(
//       key: key,
//       labelText: labelText,
//       mandatoryStar: mandatoryStar,
//       selectedItem: selectedItem?.isEmpty ?? true ? null : selectedItem,
//       items: companyTypeNames,
//       hintText: hintText,
//       onChanged: (String? newCompanyTypeName) {
//         if (newCompanyTypeName != null) {
//           final selectedCompanyType = companyTypeList.firstWhere(
//             (e) => e.companyType.toString() == newCompanyTypeName,
//           );
//           onCompanyTypeChanged(selectedCompanyType.id.toString());
//                 }
//       },
//       dropdownBuilder: (context, selectedItem) {
//         if (selectedItem == null || selectedItem.isEmpty) {
//           return SizedBox.shrink();
//         }
//         return Row(
//           children: [
//             Text(selectedItem, style: AppTextStyle.body),
//           ],
//         );
//       },
//       emptyBuilder: (context, _) => Center(child: Text("No company types found")),
//     );
//   }
// }
