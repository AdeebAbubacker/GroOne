import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/model/model.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';

class TruckTypeSearchableDropdown extends StatelessWidget {
  final LoadTruckTypeListModel? selectedTruckType;
  final ValueChanged<LoadTruckTypeListModel?> onChanged;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;
  final Future<List<LoadTruckTypeListModel>> Function(
    int page,
    String? searchKey,
  )
  fetchTruckTypes;

  const TruckTypeSearchableDropdown({
    super.key,
    required this.selectedTruckType,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.fetchTruckTypes,
    this.mandatoryStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(labelText, style: AppTextStyle.textFiled),
            if (mandatoryStar)
              Text(
                " *",
                style: AppTextStyle.textFiled.copyWith(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 6),

        /// Dropdown with pagination
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<LoadTruckTypeListModel>.paginated(
            hintText: Text(hintText, style: AppTextStyle.textFieldHint),
            isDialogExpanded: false,
            requestItemCount: 10,

            // Initial selected value
            initialValue:
                selectedTruckType != null
                    ? SearchableDropdownMenuItem<LoadTruckTypeListModel>(
                      value: selectedTruckType!,
                      label:
                          "${selectedTruckType?.type} Truck - ${selectedTruckType?.subType}",
                      child: Text(
                        "${selectedTruckType?.type} Truck - ${selectedTruckType?.subType}",
                      ),
                    )
                    : null,

            // Called whenever dropdown needs more items
            paginatedRequest: (int page, String? searchKey) async {
              final truckTypes = await fetchTruckTypes(page, searchKey);
              return truckTypes.map((truck) {
                final label = "${truck.type} Truck - ${truck.subType}";
                return SearchableDropdownMenuItem<LoadTruckTypeListModel>(
                  value: truck,
                  label: label,
                  child: Text(label),
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
