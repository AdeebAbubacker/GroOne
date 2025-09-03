import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';


class RouteSearchableDropdown extends StatelessWidget {
  final String? selectedRouteStatus;
  final ValueChanged<RouteList?> onRouteChanged;
  final List<RouteList> routeList;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;

  const RouteSearchableDropdown({
    super.key,
    required this.selectedRouteStatus,
    required this.onRouteChanged,
    required this.routeList,
    required this.labelText,
    required this.hintText,
    this.mandatoryStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final routeLabels = routeList
        .map((e) => '${e.fromLocation?['name'] ?? ''} → ${e.toLocation?['name'] ?? ''}')
        .toList();

    final selectedItem = selectedRouteStatus != null
        ? (() {
            final selected = routeList.firstWhere(
              (e) => e.masterLaneId.toString() == selectedRouteStatus,
            );
            return '${selected.fromLocation?['name'] ?? ''} → ${selected.toLocation?['name'] ?? ''}';
          })()
        : null;

    return SearchableDropdown(
      labelText: labelText,
      mandatoryStar: mandatoryStar,
      selectedItem: (selectedItem?.isEmpty ?? true) ? null : selectedItem,
      items: routeLabels,
      hintText: hintText,
      onChanged: (String? newRouteLabel) {
        if (newRouteLabel != null) {
          try {
            final selectedRoute = routeList.firstWhere(
              (e) =>
                  '${e.fromLocation?['name'] ?? ''} → ${e.toLocation?['name'] ?? ''}' ==
                  newRouteLabel,
            );
            onRouteChanged(selectedRoute);
          } catch (e) {
            onRouteChanged(null);
          }
        } else {
          onRouteChanged(null);
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
      emptyBuilder: (context, _) =>
          Center(child: Text("No routes found", style: AppTextStyle.body)),
    );
  }
}
