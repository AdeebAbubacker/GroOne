import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/model/model.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';

class RouteSearchableDropdown extends StatelessWidget {
  final RouteList? selectedRoute;
  final ValueChanged<RouteList?> onChanged;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;
  final Future<List<RouteList>> Function(int page, String? searchKey)
      fetchRoutes;

  const RouteSearchableDropdown({
    super.key,
    required this.selectedRoute,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.fetchRoutes,
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
              Text(" *",
                  style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
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
          child: SearchableDropdown<RouteList>.paginated(
            hintText: Text(hintText,style:AppTextStyle.textFieldHint,),
            isDialogExpanded: false, 
            requestItemCount: 10,  
          
            // Initial selected value
            initialValue: selectedRoute != null
                ? SearchableDropdownMenuItem<RouteList>(
                    value: selectedRoute!,
                    label:
                        "${selectedRoute?.fromLocation?.name ?? ''} → ${selectedRoute?.toLocation?.name ?? ''}",
                    child: Text(
                        "${selectedRoute?.fromLocation?.name ?? ''} → ${selectedRoute?.toLocation?.name ?? ''}"),
                  )
                : null,
           
            // Called whenever dropdown needs more items
            paginatedRequest: (int page, String? searchKey) async {
              final routes = await fetchRoutes(page, searchKey);
              return routes.map((route) {
                final from = route.fromLocation?.name ?? '';
                final to = route.toLocation?.name ?? '';
                return SearchableDropdownMenuItem<RouteList>(
                  value: route,
                  label: "$from → $to",
                  child: Text("$from → $to"),
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
