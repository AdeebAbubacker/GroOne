import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';



// class RouteSearchableDropdown extends StatelessWidget {
//   final RouteList? selectedRoute;
//   final ValueChanged<RouteList?> onChanged;
//   final String labelText;
//   final String hintText;
//   final bool mandatoryStar;
//   final Future<List<RouteList>> Function(int page, String? searchKey)
//       fetchRoutes;

//   const RouteSearchableDropdown({
//     super.key,
//     required this.selectedRoute,
//     required this.onChanged,
//     required this.labelText,
//     required this.hintText,
//     required this.fetchRoutes,
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
//               Text(" *",
//                   style:
//                       AppTextStyle.textFiled.copyWith(color: Colors.red)),
//           ],
//         ),
//         const SizedBox(height: 6),
// Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400), 
//         borderRadius: BorderRadius.circular(8), // rounded corners
//       ),
//       child: SearchableDropdown<RouteList>.paginated(
        
//         isDialogExpanded: false,
//         hintText: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(hintText),
//         ),
//         requestItemCount: 20,
//         initialValue: selectedRoute != null
//             ? SearchableDropdownMenuItem<RouteList>(
            
//                 value: selectedRoute,
//                 label: "${selectedRoute?.fromLocation?['name'] ?? ''} → ${selectedRoute?.toLocation?['name'] ?? ''}",
//                 child: Text("${selectedRoute?.fromLocation?['name'] ?? ''} → ${selectedRoute?.toLocation?['name'] ?? ''}"),
//               )
//             : null,
//         paginatedRequest: (int page, String? searchKey) async {
//           final routes = await fetchRoutes(page, searchKey);
//           return routes.map((route) {
//             final from = route.fromLocation?['name'] ?? '';
//             final to = route.toLocation?['name'] ?? '';
//             return SearchableDropdownMenuItem<RouteList>(
              
//               value: route,
//               label: "$from → $to",
//               child: Text("$from → $to"),
//             );
//           }).toList();
//         },
//         onChanged: onChanged,
//       ),
//     ),

// ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

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
              Text(
                " *",
                style: AppTextStyle.textFiled.copyWith(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SearchableDropdown<RouteList>.paginated(
            isDialogExpanded: false,
            hintText: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(hintText),
            ),
            requestItemCount: 20, // Number of items per page
            initialValue: selectedRoute != null
                ? SearchableDropdownMenuItem<RouteList>(
                    value: selectedRoute,
                    label:
                        "${selectedRoute?.fromLocation?.name ?? ''} → ${selectedRoute?.toLocation?.name ?? ''}",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                          "${selectedRoute?.fromLocation?.name ?? ''} → ${selectedRoute?.toLocation?.name ?? ''}"),
                    ),
                  )
                : null,
            paginatedRequest: (int page, String? searchKey) async {
              final allRoutes = await fetchRoutes(page, searchKey);

              // Simulate pagination
              final startIndex = (page - 1) * 20;
              final endIndex = startIndex + 20;

              final pagedRoutes =
                  startIndex < allRoutes.length ? allRoutes.sublist(
                      startIndex,
                      endIndex > allRoutes.length
                          ? allRoutes.length
                          : endIndex) : [];

              return pagedRoutes.map((route) {
                final from = route.fromLocation?['name'] ?? '';
                final to = route.toLocation?['name'] ?? '';
                return SearchableDropdownMenuItem<RouteList>(
                  value: route,
                  label: "$from → $to",
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text("$from → $to"),
                  ),
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
