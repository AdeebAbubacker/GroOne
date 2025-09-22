import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/model/model.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';

class RouteSearchableDropdown extends StatelessWidget {
  final RouteList? selectedRoute;
  final ValueChanged<RouteList?> onChanged;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;

  final Future<List<RouteList>> Function(int page, String? searchKey)fetchRoutes;

  RouteSearchableDropdown({
    super.key,
    required this.selectedRoute,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.fetchRoutes,
    this.mandatoryStar = false,

  });
 final lpLoadLocator = locator<LpLoadCubit>();
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
          child: SearchableDropdown<RouteList>.paginated(
            hintText: Text(hintText, style: AppTextStyle.textFieldHint),
            isDialogExpanded: false,
            dialogOffset: 0,
            requestItemCount: 10,
            // Initial selected value
            initialValue:
                selectedRoute != null
                    ? SearchableDropdownMenuItem<RouteList>(
                      value: selectedRoute!,
                      label:
                          "${selectedRoute?.fromLocation?.name ?? ''} → ${selectedRoute?.toLocation?.name ?? ''}",
                      child: Text(
                        "${selectedRoute?.fromLocation?.name ?? ''} → ${selectedRoute?.toLocation?.name ?? ''}",
                      ),
                    )
                    : null,

            // Called whenever dropdown needs more items
            paginatedRequest: (int page, String? searchKey) async {
              final routes = await fetchRoutes(page, searchKey);
               if (lpLoadLocator.isRoutesLastPage && page > lpLoadLocator.rootsCurrentPage) {
              return [];
            }
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

class VehicleTypeSearchableDropdown extends StatefulWidget {
  final TruckTypeModel? selectedVehicleType;
  final ValueChanged<TruckTypeModel?> onChanged;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;
  final Future<List<TruckTypeModel>> Function() fetchVehicleTypes;

  const VehicleTypeSearchableDropdown({
    super.key,
    required this.selectedVehicleType,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.fetchVehicleTypes,
    this.mandatoryStar = false,
  });

  @override
  State<VehicleTypeSearchableDropdown> createState() =>
      _VehicleTypeSearchableDropdownState();
}

class _VehicleTypeSearchableDropdownState
    extends State<VehicleTypeSearchableDropdown> {
  List<TruckTypeModel> _allVehicleTypes = [];
  bool _isFetched = false;

  Future<List<TruckTypeModel>> _getVehicleTypes() async {
    if (!_isFetched) {
      _allVehicleTypes = await widget.fetchVehicleTypes();
      _isFetched = true;
    }
    return _allVehicleTypes;
  }

  @override
  Widget build(BuildContext context) {
    final initialTruck = widget.selectedVehicleType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.labelText, style: AppTextStyle.textFiled),
            if (widget.mandatoryStar)
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
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<TruckTypeModel>.future(
            dialogOffset: 0,
            hintText: Text(widget.hintText, style: AppTextStyle.textFieldHint),
            isDialogExpanded: false,

            // ✅ Pre-select value if ID matches
            initialValue: initialTruck != null
                ? SearchableDropdownMenuItem<TruckTypeModel>(
                    value: initialTruck,
                    label:
                        "${initialTruck.type ?? ''} ${initialTruck.subType ?? ''}",
                    child: Text(
                      "${initialTruck.type ?? ''} ${initialTruck.subType ?? ''}",
                    ),
                  )
                : null,

            futureRequest: () async {
              final allVehicleTypes = await _getVehicleTypes();
              return allVehicleTypes.map((vehicle) {
                return SearchableDropdownMenuItem<TruckTypeModel>(
                  value: vehicle,
                  label: "${vehicle.type ?? ''} ${vehicle.subType ?? ''}",
                  child: Text("${vehicle.type ?? ''} ${vehicle.subType ?? ''}"),
                );
              }).toList();
            },

            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

class LoadTypeSearchableDropdown extends StatelessWidget {
  final LoadCommodityListModel? selectedLoadType;
  final ValueChanged<LoadCommodityListModel?> onChanged;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;
  final Future<List<LoadCommodityListModel>> Function(
    int page,
    String? searchKey,
  )
  fetchLoadTypes;

  const LoadTypeSearchableDropdown({
    super.key,
    required this.selectedLoadType,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.fetchLoadTypes,
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
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<LoadCommodityListModel>.paginated(
            hintText: Text(hintText, style: AppTextStyle.textFieldHint),
            isDialogExpanded: false,
            requestItemCount: 10,
            dialogOffset: 0,
            /// initial selected value
            initialValue:
                selectedLoadType != null
                    ? SearchableDropdownMenuItem<LoadCommodityListModel>(
                      value: selectedLoadType!,
                      label: selectedLoadType?.name ?? '',
                      child: Text(selectedLoadType?.name ?? ''),
                    )
                    : null,

            /// fetch paginated items
            paginatedRequest: (int page, String? searchKey) async {
              final loadTypes = await fetchLoadTypes(page, null);
              final filteredLoadTypes =
                  (searchKey == null || searchKey.isEmpty)
                      ? loadTypes
                      : loadTypes
                          .where(
                            (type) => (type.name).toLowerCase().contains(
                              searchKey.toLowerCase(),
                            ),
                          )
                          .toList();

              return filteredLoadTypes.map((type) {
                return SearchableDropdownMenuItem<LoadCommodityListModel>(
                  value: type,
                  label: type.name,
                  child: Text(type.name),
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

class LoadWeightSearchableDropdown extends StatelessWidget {
  final LoadWeightModel? selectedWeight;
  final ValueChanged<LoadWeightModel?> onChanged;
  final String labelText;
  final String hintText;
  final bool mandatoryStar;
  final Future<List<LoadWeightModel>> Function()
  fetchWeights;

  const LoadWeightSearchableDropdown({
    super.key,
    required this.selectedWeight,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.fetchWeights,
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
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<LoadWeightModel>.future(
            dialogOffset: 0,
            hintText: Text(hintText, style: AppTextStyle.textFieldHint),
            isDialogExpanded: false,

            /// initial value
            initialValue:
                selectedWeight != null
                    ? SearchableDropdownMenuItem<LoadWeightModel>(
                      value: selectedWeight!,
                      label: "${selectedWeight?.value} Ton",
                      child: Text("${selectedWeight?.value} Ton"),
                    )
                    : null,

            /// fetch items with pagination
            futureRequest: () async {
              // Fetch all weights once
              final weights = await fetchWeights(); 
              return weights.map((weight) {
                return SearchableDropdownMenuItem<LoadWeightModel>(
                  value: weight,
                  label: "${weight.value} Ton",
                  child: Text("${weight.value} Ton"),
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
