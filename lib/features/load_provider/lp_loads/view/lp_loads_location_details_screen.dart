import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_load_bottom_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/google_map_widdget.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../model/lp_load_get_by_id_response.dart';

class LpLoadsLocationDetailsScreen extends StatefulWidget {
  final int loadId;

  const LpLoadsLocationDetailsScreen({super.key,
    required this.loadId
  });


  @override
  State<LpLoadsLocationDetailsScreen> createState() => _LpLoadsLocationDetailsScreenState();
}

class _LpLoadsLocationDetailsScreenState extends State<LpLoadsLocationDetailsScreen> {
  String kilometers = '';
  final lpLoadLocator = locator<LpLoadCubit>();
  Timer? _ticker;
  String _countDown = "00:00:00";

  @override
  void initState() {
    super.initState();
    lpLoadLocator.getLpLoadsById(loadId: widget.loadId);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _updateCountDown(String? status, LoadData loadItem) {
    if (status == 'Matching') {
      final matchingStartDate = loadItem.matchingStartDate;
      if (matchingStartDate != null) {
        _countDown = LpHomeHelper.getMatchingTime(matchingStartDate.toIso8601String());
      }
    } else if (status == 'KYC Pending') {
      final kycPendingDate = loadItem.customer?.kycPendingDate;
      if (kycPendingDate != null) {
        _countDown = LpHomeHelper.getKycPendingTimeLeft(kycPendingDate.toIso8601String());
      }
    } else {
      _countDown = "--:--:--";
    }

    if (mounted) {
      setState(() {});
    }
  }

  void callTimer(LoadData loadItem){
    if(loadItem.createdAt != null && loadItem.loadStatusDetails?.loadType != null){
      final status = loadItem.loadStatusDetails?.loadType;
      if (status == 'Matching' || status == 'KYC Pending') {
        _updateCountDown(status, loadItem);                                   // first paint
        _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
          _updateCountDown(status, loadItem);
        });
      }
    } else {
      _ticker = Timer(const Duration(seconds: 0), () {});   // dummy, will cancel
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: BlocBuilder<LpLoadCubit, LpLoadState>(
            builder: (context, state) {
              final uiState = state.lpLoadById;

              if (uiState == null || uiState.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              final loadItem = uiState.data?.loadData as LoadData;

              if (loadItem == null) {
                return const Center(child: Text("No loads found."));
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                callTimer(loadItem);
              });
              return Stack(
                children: [
                  GoogleMapWidget(
                    pickupLocation: loadItem.pickUpLocation,
                    dropLocation: loadItem.dropLocation,
                    pickUpLatLong: loadItem.pickUpLatlon,
                    dropLatLong: loadItem.dropLatlon,
                  ),
                  buildTopLocationWidget(loadItem),
                  LpLoadBottomWidget(loadItem: loadItem, kilometers: kilometers),
                  buildSupportWidget(),
                ],
              );
            }
        ),
      ),
    );
  }
  

  /// Location Details
  Widget buildTopLocationWidget(LoadData loadItem) {
    return Positioned(
      top: 30,
      left: 16,
      right: 16,
      child: Container(
        decoration: commonContainerDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(onTap: () {
                  Navigator.pop(context);
                },child: Icon(Icons.arrow_back)),
                8.width,
                Text('#${loadItem.loadId}', style: AppTextStyle.body3),
                Spacer(),
                Text(
                  loadItem.createdAt != null ? DateTimeHelper.formatCustomDateIST(loadItem.createdAt!) : "--",
                  style: AppTextStyle.body4PrimaryColor.copyWith(fontSize: 10),
                ),
              ],
            ),
            12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Pickup address & date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        loadItem.pickUpLocation,
                        style: AppTextStyle.body2.copyWith(color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      loadItem.pickUpDateTime != null
                          ? DateTimeHelper.getFormattedDate(loadItem.pickUpDateTime!)
                          : "--",
                      style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor),
                    ),
                  ],
                ),
                20.width,
                Icon(Icons.arrow_forward),
                20.width,

                // Drop location & date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        loadItem.dropLocation,
                        style: AppTextStyle.body2.copyWith(color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      loadItem.expectedDeliveryDateTime != null
                          ? DateTimeHelper.getFormattedDate(loadItem.expectedDeliveryDateTime!)
                          : "--",
                      style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor),
                    ),
                  ],
                ),
                Spacer(),

                // Load status & matching time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: commonContainerDecoration(
                        color: LpHomeHelper.getLoadStatusColor(loadItem.loadStatusDetails?.loadType ?? ''),
                      ),
                      width: 100,
                      child: Text(
                        LpHomeHelper.getLoadTypeDisplayText(loadItem.loadStatusDetails?.loadType ?? ''),
                        style: AppTextStyle.body3.copyWith(
                          color: LpHomeHelper.getLoadStatusTextColor(loadItem.loadStatusDetails?.loadType ?? ''),
                        ),
                      ).center().paddingAll(4),
                    ),
                    4.height,
                    if (loadItem.loadStatus == 1)
                      if(loadItem.customer?.kycPendingDate != null)
                        Text(
                        _countDown,
                        // LpHomeHelper.getKycPendingTimeLeft(loadItem.customer!.kycPendingDate.toString()),
                        style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).paddingRight(5),
                    if (loadItem.loadStatus == 2)
                        Text(
                        _countDown,
                        // LpHomeHelper.getMatchingTime(loadItem.matchingStartDate.toString()),
                        style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).paddingRight(5)
                  ],
                ),
              ],
            )
          ],
        ).paddingAll(commonRadius),
      ),
    );
  }


  /// Support
  Widget buildSupportWidget() {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomWidgetMaxHeight = screenHeight * 0.45;

    return Positioned(
        right: 5, bottom: bottomWidgetMaxHeight + 10,child: IconButton(
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
    ));


  }
}

