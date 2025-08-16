import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_state.dart';
import 'package:gro_one_app/features/kavach/model/kavach_vehicle_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_truck_length_model.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/kavach/view/kavach_add_vehicle_bottom_sheet.dart';
import 'package:gro_one_app/features/master/widget/master_vehicle_tab.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_search_bar.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/extensions/string_extensions.dart';
import '../bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_bloc.dart';
import '../bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_event.dart';

class KavachAddedVehiclesScreen extends StatefulWidget {
  const KavachAddedVehiclesScreen({super.key});

  @override
  State<KavachAddedVehiclesScreen> createState() =>
      _KavachAddedVehiclesScreenState();
}

class _KavachAddedVehiclesScreenState extends State<KavachAddedVehiclesScreen> {
  final searchController = TextEditingController();
  final kavachCheckoutVehicleBloc = locator<KavachCheckoutVehicleBloc>();
  final Map<String, List<TruckLengthModel>> _truckTypeData = {};
  final KavachRepository _repository = locator<KavachRepository>();

  @override
  void initState() {
    super.initState();
    kavachCheckoutVehicleBloc.add(FetchKavachVehicles());
  }

  /// Helper method to get truck type display text using API data
  String _getTruckTypeDisplayText(KavachVehicleModel vehicle, [Map<String, List<TruckLengthModel>>? truckTypeData]) {
    // First try to use truckTypeInfo if available (from vehicle API response)
    if (vehicle.truckTypeInfo != null) {
      final type = vehicle.truckTypeInfo!.type;
      final subType = vehicle.truckTypeInfo!.subType;
      
      // Format similar to GPS: "Type - Length"
      if (type.isNotEmpty && subType.isNotEmpty) {
        return '$type - $subType';
      } else if (type.isNotEmpty) {
        return '$type Truck';
      } else if (subType.isNotEmpty) {
        return 'Truck - $subType';
      }
    }
    
    // Try to get truck type data from truck-types API using truckTypeId
    if (vehicle.truckType != null && truckTypeData != null) {
      return _getTruckTypeAndLengthFromApi(vehicle.truckType!, truckTypeData);
    }
    
    // Fallback to individual truckType and truckLength fields
    final truckType = vehicle.truckType;
    final truckLength = vehicle.truckLength;
    
    if (truckType != null && truckType > 0 && truckLength != null && truckLength > 0) {
      final typeText = _getTruckTypeName(truckType);
      return '$typeText Truck - ${truckLength}ft';
    } else if (truckType != null && truckType > 0) {
      final typeText = _getTruckTypeName(truckType);
      return '$typeText Truck';
    } else if (truckLength != null && truckLength > 0) {
      return 'Truck - ${truckLength}ft';
    }
    
    return 'Truck type not available';
  }

  /// Helper method to convert truck type ID to name (fallback for old mapping)
  String _getTruckTypeName(int truckTypeId) {
    switch (truckTypeId) {
      case 1:
        return 'Open';
      case 2:
        return 'Closed';
      case 3:
        return 'Trailer';
      default:
        return 'Unknown';
    }
  }

  /// Get truck type and length from API data based on truckTypeId
  String _getTruckTypeAndLengthFromApi(int truckTypeId, Map<String, List<TruckLengthModel>> truckTypeData) {
    // Find the truck type by matching the ID directly with the API data
    for (final entry in truckTypeData.entries) {
      final truckTypes = entry.value;
      for (final truckType in truckTypes) {
        if (truckType.id == truckTypeId) {
          // Found matching truck type, return "Type - SubType" format
          return '${truckType.type} - ${truckType.subType}';
        }
      }
    }
    
    // If no match found, fallback to old mapping
    final truckTypeName = _getTruckTypeName(truckTypeId);
    return '$truckTypeName Truck';
  }

  /// Fetch all truck type data from the API
  Future<void> _fetchAllTruckTypes() async {
    if (_truckTypeData.isNotEmpty) {
      return; // Already fetched
    }

    try {
      final result = await _repository.fetchAllTruckTypes();
      if (result is Success<List<TruckLengthModel>>) {
        setState(() {
          // Group truck types by their type (Open, Closed, Trailer)
          for (final truckType in result.value) {
            if (!_truckTypeData.containsKey(truckType.type)) {
              _truckTypeData[truckType.type] = [];
            }
            _truckTypeData[truckType.type]!.add(truckType);
          }
        });
      }
    } catch (e) {
      // Silently handle errors to avoid breaking the UI
    }
  }

  Widget vehicleCard(KavachVehicleModel vehicle, Map<String, List<TruckLengthModel>> truckTypeData) {
    return InkWell(
      onTap: () {
        if (vehicle.vehicleStatus==1) {
          Navigator.of(
                    context,
                  ).pop(vehicle.vehicleNumber);
        } else {
          ToastMessages.alert(message: 'Vehicle is currently inactive');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightBlueIconBackgroundColor2,
              child: SvgPicture.asset(
                AppIcons.svg.truck,
                colorFilter: AppColors.svg(AppColors.primaryColor),
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vehicle.vehicleNumber.formatVehicleNumberForDisplay,
                        style: AppTextStyle.h4.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      6.width,
                      Visibility(
                        visible: vehicle.status == 1,
                        child: const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    vehicle.truckMakeAndModel ?? '',
                    style: AppTextStyle.bodyBlackColorW500,
                  ),
                  Text(
                    _getTruckTypeDisplayText(vehicle, truckTypeData),
                    style: AppTextStyle.textGreyColor12w400,
                  ),
                ],
              ),
            ),
            if (vehicle.vehicleStatus == 1)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F8ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.appText.active,
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            10.height,
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.appText.addedVehicle,
                    style: AppTextStyle.appBar.copyWith(
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // await commonBottomSheetWithBGBlur<String?>(
                    //   context: context,
                    //   screen: const KavachAddVehicleBottomSheet(),
                    // );
                    AddVehicleDialog.show(context: context);
                    kavachCheckoutVehicleBloc.add(FetchKavachVehicles());
                  },
                  child: Text(
                    '+ ${context.appText.addVehicle}',
                    style: AppTextStyle.primaryColor14w700,
                  ),
                ),
              ],
            ),
            AppSearchBar(
              searchController: searchController,
              onChanged: (text) {
                setState(() {});
              },
            ),
            Expanded(
              child: BlocBuilder<
                KavachCheckoutVehicleBloc,
                KavachCheckoutVehicleState
              >(
                builder: (context, state) {
                  if (state is KavachCheckoutVehicleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is KavachCheckoutVehicleLoaded) {
                    final searchText = searchController.text.toLowerCase();

                    // Filter the list based on search text
                    final filteredVehicles =
                        state.vehicles.where((vehicle) {
                          return vehicle.vehicleNumber.toLowerCase().contains(
                                searchText,
                              ) ||
                              vehicle.rcNumber.toLowerCase().contains(
                                searchText,
                              ) ||
                              vehicle.capacity.toLowerCase().contains(
                                searchText,
                              );
                        }).toList();

                    if (filteredVehicles.isEmpty) {
                      return Center(
                        child: Text(context.appText.noVehiclesFound),
                      );
                    }

                    // Fetch all truck type data from API
                    _fetchAllTruckTypes();

                    return ListView.separated(
                      itemCount: filteredVehicles.length,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      separatorBuilder: (_, __) => 12.height,
                      itemBuilder: (_, index) {
                        final vehicle = filteredVehicles[index];
                        return vehicleCard(vehicle, _truckTypeData);
                      },
                    );
                  } else if (state is KavachCheckoutVehicleError) {
                    return Center(child: Text("Error: ${state.error}"));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: commonSafeAreaPadding),
      ),
    );
  }
}
