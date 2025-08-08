import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';


class TruckTypeSearchableDropdown extends StatelessWidget {
  final String? selectedTruckTypeId;
  final ValueChanged<String?> onTruckTypeChanged;
  final List<LoadTruckTypeListModel> truckTypeList;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;

  const TruckTypeSearchableDropdown({
    super.key,
    required this.selectedTruckTypeId,
    required this.onTruckTypeChanged,
    required this.truckTypeList,
    required this.labelText,
    required this.hintText,
    this.mandatoryStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final truckTypeLabels = truckTypeList
        .map((e) => '${e.type} Truck - ${e.subType}')
        .toList();

    final selectedItem = selectedTruckTypeId != null
        ? (() {
            final selected =
                truckTypeList.firstWhere((e) => e.id.toString() == selectedTruckTypeId);
            return '${selected.type} Truck - ${selected.subType}';
          })()
        : null;

    return SearchableDropdown(
      labelText: labelText,
      mandatoryStar: mandatoryStar,
      selectedItem: (selectedItem?.isEmpty ?? true) ? null : selectedItem,
      items: truckTypeLabels,
      hintText: hintText,
      onChanged: (String? newTruckTypeLabel) {
        if (newTruckTypeLabel != null) {
          try {
            final selectedTruckType = truckTypeList.firstWhere(
              (e) => '${e.type} Truck - ${e.subType}' == newTruckTypeLabel,
            );
            onTruckTypeChanged(selectedTruckType.id.toString());
          } catch (e) {
            onTruckTypeChanged(null);
          }
        } else {
          onTruckTypeChanged(null);
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
      emptyBuilder: (context, _) => Center(child: Text("No truck types found")),
    );
  }
}
