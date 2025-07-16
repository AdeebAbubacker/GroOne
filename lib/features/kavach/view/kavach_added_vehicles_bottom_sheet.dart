import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_state.dart';
import 'package:gro_one_app/features/kavach/model/kavach_vehicle_model.dart';
import 'package:gro_one_app/features/kavach/view/kavach_add_vehicle_bottom_sheet.dart';
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

  @override
  void initState() {
    super.initState();
    kavachCheckoutVehicleBloc.add(FetchKavachVehicles());
  }

  Widget vehicleCard(KavachVehicleModel vehicle) {
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
                        vehicle.vehicleNumber,
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
                    '${vehicle.truckTypeInfo?.type} - ${vehicle.truckTypeInfo?.subType} ',
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
                    await commonBottomSheetWithBGBlur<String?>(
                      context: context,
                      screen: const KavachAddVehicleBottomSheet(),
                    );
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

                    return ListView.separated(
                      itemCount: filteredVehicles.length,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      separatorBuilder: (_, __) => 12.height,
                      itemBuilder: (_, index) {
                        final vehicle = filteredVehicles[index];
                        return vehicleCard(vehicle);
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
