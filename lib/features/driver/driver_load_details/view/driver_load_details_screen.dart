 import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/driver/driver_home/helper/driver_load_helper.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_load_bottom_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/google_map_widdget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class DriverLoadsLocationDetailsScreen extends StatefulWidget {
  final String loadId;

  const DriverLoadsLocationDetailsScreen({super.key, required this.loadId});

  @override
  State<DriverLoadsLocationDetailsScreen> createState() => _DriverLoadsLocationDetailsScreenState();
}

class _DriverLoadsLocationDetailsScreenState extends State<DriverLoadsLocationDetailsScreen> {
  Timer? _ticker;
  String _countDown = "--:--:--";
  bool _simConsentCalled = false;
   final driverLoadDetailsCubit = locator<DriverLoadDetailsCubit>();
  @override
  void initState() {
    super.initState();
    getLoadDetails();
  }

Future<void> getLoadDetails() async {
  await driverLoadDetailsCubit.getDriverLoadsById(loadId: widget.loadId);

  final statusId = driverLoadDetailsCubit.state.lpLoadById?.data?.data?.loadStatusId;

  if (statusId != null) {
    driverLoadDetailsCubit.updatePODVisibilityBasedOnStatus(statusId);
  }
}

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: 
        BlocConsumer<DriverLoadDetailsCubit, DriverLoadDetailsState>(
         bloc: driverLoadDetailsCubit,
          listener: (context, state) {
            
          },
          builder: (context, state) {
            final uiState = state.lpLoadById;
        
            if (uiState == null || uiState.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (uiState.status == Status.ERROR) {
              return Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  genericErrorWidget(
                    onRefresh: () => context.read<DriverLoadDetailsCubit>().getDriverLoadsById(loadId: widget.loadId),
                  ).paddingTop(50),
                ],
              );
            }
            if (uiState.status == Status.SUCCESS) {
            final loadItem = uiState.data;
              if (loadItem?.data == null) {
                        return Stack(
                            children: [
                              Positioned(
                                top: 20,
                                left: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              genericErrorWidget(
                                onRefresh: () => context.read<DriverLoadDetailsCubit>().getDriverLoadsById(loadId: widget.loadId),
                              ).paddingTop(50),
                            ],
                          );
                        }
                        
           
        
            return Stack(
              children: [
                GoogleMapWidget(
                  pickupLocation: loadItem?.data?.loadRoute?.pickUpLocation,
                  dropLocation: loadItem?.data?.loadRoute?.dropLocation,
                  pickUpLatLong: loadItem?.data?.loadRoute?.pickUpLatlon,
                  dropLatLong: loadItem?.data?.loadRoute?.dropLatlon,
                  driverLat: 3,
                  driverLong: 23,
                ),
                buildTopLocationWidget(loadItem!),
                DriverLoadBottomWidget(loadItem: loadItem,kilometers: '34',cubit: context.read<DriverLoadDetailsCubit>(),),
                buildFloatingWidget(context),
                buildSimConsentWidget(loadItem.data?.driverConsent ?? 0),
              ],
            );
            }
            return genericErrorWidget(error: GenericError());
          }
        ),
      )
    );
  }

  Widget buildTopLocationWidget(DriverLoadDetailsModel loadItem) {
    return Positioned(
      top: 15,
      left: 16,
      right: 16,
      child: Container(
        decoration: commonContainerDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back),
                ),
                8.width,
                Text(loadItem.data?.loadSeriesId ?? "--", style: AppTextStyle.body3),
                const Spacer(),
                Text(
                  loadItem.data?.createdAt != null
                      ? DateTimeHelper.formatCustomDateIST( loadItem.data?.createdAt)
                      : "--",
                  style: AppTextStyle.body4PrimaryColor.copyWith(fontSize: 10),
                ),
                   

              ],
            ),
            12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Pickup
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        loadItem.data?. loadRoute?.pickUpLocation ?? '',
                        style: AppTextStyle.body2.copyWith(color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                   loadItem.data!.pickUpDateTime != null
                    ? DateTimeHelper.getFormattedDate(loadItem.data!.pickUpDateTime!)
                    : '',

                      style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor),
                    ),
                  ],
                ).expand(),

                const Icon(Icons.arrow_forward),
                20.width,

                // Drop
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        loadItem.data?.loadRoute?.dropLocation ?? '',
                        style: AppTextStyle.body2.copyWith(color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                        loadItem.data?.expectedDeliveryDateTime != null
                          ? DateTimeHelper.getFormattedDate( loadItem.data!.expectedDeliveryDateTime!)
                          : "--",
                      style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor),
                    ),
                  ],
                ).expand(),
                 DriverLoadHelper.driverStatusWidget(loadItem.data?.loadStatusId.toString()),
                ],
            )
          ],
        ).paddingAll(12),
      ),
    );
  }


  /// Support
  Widget buildFloatingWidget(status) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomWidgetMaxHeight = screenHeight * 0.45;

    return Positioned(
        right: 5, bottom: bottomWidgetMaxHeight + 10,child: Column(
          children: [
            IconButton(
                onPressed: () {
            
                },
                icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: commonContainerDecoration(shadow: true,shadowColor: AppColors.secondaryButtonColor,borderRadius: BorderRadius.circular(20)),
                  child: Icon(Icons.location_searching, color: AppColors.primaryColor),
                )
            ),
            IconButton(
            onPressed: () {
              commonSupportDialog(context);
            },
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: commonContainerDecoration(shadow: true,shadowColor: AppColors.secondaryButtonColor,borderRadius: BorderRadius.circular(20)),
              child: SvgPicture.asset(
                AppIcons.svg.support,
                width: 25,
                colorFilter: AppColors.svg(AppColors.primaryColor),
              ),
            )
                ),

          ],
        ));
  }


    Widget buildSimConsentWidget(int driverConsent) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomWidgetMaxHeight = screenHeight * 0.45;
    final isTrackingAllowed = driverConsent==1;

    return Positioned(
        left: 5, bottom: bottomWidgetMaxHeight + 10,child: IconButton(
        onPressed: () {
          commonSupportDialog(context);
        },
        icon: Container(
          decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(6)),
          child: Row(
            children: [
              Container(decoration: BoxDecoration(shape: BoxShape.circle, color: isTrackingAllowed ? AppColors.activeDarkGreenColor : AppColors.red), height: 12, width: 12),
              10.width,
              Text(context.appText.sim, style: AppTextStyle.h5 )
            ],
          ).paddingAll(8),
        )
    ));


  }
}




