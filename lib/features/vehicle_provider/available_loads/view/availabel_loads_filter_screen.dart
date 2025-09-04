import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class AvailableLoadsFilterScreen extends StatefulWidget {
  const AvailableLoadsFilterScreen({super.key});

  @override
  State<AvailableLoadsFilterScreen> createState() =>
      _AvailableLoadsFilterScreenState();
}

class _AvailableLoadsFilterScreenState
    extends State<AvailableLoadsFilterScreen> {
  final formKey = GlobalKey<FormState>();

  String? vehicleTypeDownValue;
  String? laneDropDownValue;
  String? loadTypeDropDownValue;
  final ScrollController scrollController=ScrollController();

  final filterCubit = locator<LoadFilterCubit>();

  /// Selected Data

  int? truckTypeId;
  int? laneId;
  int? commodityId;
  List<Item> preferLanesModel=[];

  @override
  void initState() {
    _setInitialFilterData();
    check();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }


  check(){
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {

      }
    },);
  }



  void disposeFunction() => frameCallback(() {});

  void _getTruckType(
    List<TruckTypeModel> truckTypeList,
    String? selectedTruckType,
  ) {
    TruckTypeModel? truckTypeModel = truckTypeList.firstWhere((element) {
      String commodity = "${element.type} ${element.subType}";
      return commodity == selectedTruckType;
    });
    truckTypeId = truckTypeModel.id;
    filterCubit.setTruckTypeData(
      truckTypeId: truckTypeModel.id,
      value: selectedTruckType,
    );
  }

  void _getLaneId(List<Item> preferLanesModel, String? selectedLens) {
    Item? selectedObject = preferLanesModel.firstWhere((element) {
      String lane =
          '${element.fromLocation?.name ?? ""} - ${element.toLocation?.name ?? ""}';
      return lane == selectedLens;
    });
    laneId = selectedObject.masterLaneId;
    filterCubit.setLensData(
      leneId: selectedObject.masterLaneId,
      value: selectedLens,
    );
  }

  void _getCommodity(List<LoadCommodityListModel> loadTypeList, String? value) {
    LoadCommodityListModel? loadType = loadTypeList.firstWhere((element) {
      String loadType = element.name;
      return loadType == value;
    });
    commodityId = loadType.id;
    filterCubit.setCommodityData(commodityId: loadType.id, value: value);
  }

  void _setInitialFilterData() {
    if (filterCubit.state.isFilterApplied == false) {
      return;
    }

    vehicleTypeDownValue = filterCubit.state.selectedTruckType?['value'];
    truckTypeId = filterCubit.state.selectedTruckType?['id'];

    laneDropDownValue = filterCubit.state.selectedLaneType?['value'];
    laneId = filterCubit.state.selectedLaneType?['id'];

    loadTypeDropDownValue = filterCubit.state.selectedCommodity?['value'];
    commodityId = filterCubit.state.selectedCommodity?['id'];
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.filter,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return BlocBuilder<LoadFilterCubit, LoadFilterState>(
      builder: (context, state) {
        List<TruckTypeModel> truckTypeList = state.truckTypeUIState?.data ?? [];
        preferLanesModel  =
            state.truckTypeLaneUIState?.data?.data?.items ?? [];
        List<LoadCommodityListModel> loadTypeList =
            state.commodityResponseUIState?.data ?? [];

        return Form(
          key: formKey,
          child: Column(
            children: [
              // Vehicle Type
              SearchableDropdown(
                hintText: context.appText.selectVehicleType,
                items:
                    truckTypeList.map((e) => "${e.type} ${e.subType}").toList(),
                labelText: context.appText.vehicleType,
                selectedItem: vehicleTypeDownValue,
                onChanged: (value) {
                  _getTruckType(truckTypeList, value);
                },
              ),
              20.height,

              // Lane Type
              SearchableDropdown(
                hintText: context.appText.selectLaneType,
                items:
                preferLanesModel
                        .map(
                          (e) =>
                              '${e.fromLocation?.name ?? ""} - ${e.toLocation?.name ?? ""}',
                        )
                        .toList(),
                labelText: context.appText.lane,
                selectedItem: laneDropDownValue,
                onChanged: (value) {
                  _getLaneId(preferLanesModel, value);
                },
              ),

              20.height,

              // Road Type
              SearchableDropdown(

                hintText: context.appText.selectRoadType,
                items: loadTypeList.map((e) => e.name).toList(),
                labelText: context.appText.loadType,
                selectedItem: loadTypeDropDownValue,
                onChanged: (value) {
                  _getCommodity(loadTypeList, value);
                },
              ),
              50.height,
              Row(
                children: [
                  // Cancel
                  AppButton(
                    onPressed: () {
                      filterCubit.setIsFilterApplied(value: false);
                      context.pop();
                    },
                    title: context.appText.cancel,
                    style: AppButtonStyle.outline,
                  ).expand(),

                  20.width,

                  // Apply
                  AppButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "commodityId": commodityId,
                        "truckTypeId": truckTypeId,
                        "lensType": laneId,
                      });
                      filterCubit.setIsFilterApplied(value: true);
                    },
                    title: context.appText.apply,
                    style: AppButtonStyle.primary,
                  ).expand(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
