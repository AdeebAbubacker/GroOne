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
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/nullable_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../model/lp_load_get_by_id_response.dart';

class LpLoadsLocationDetailsScreen extends StatefulWidget {
  final String loadId;

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

  void _updateCountDown(LoadStatus? status, LoadData loadItem) {
    if (status == LoadStatus.matching) {
      final matchingStartDate = loadItem.matchingStartDate;
      if (matchingStartDate != null) {
        _countDown = LpHomeHelper.getMatchingTime(matchingStartDate.toIso8601String());
      }
    } else if (status == LoadStatus.kycPending) {
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
    if(loadItem.createdAt != null && loadItem.loadStatusDetails?.loadStatus != null){
      // final status = loadItem.loadStatusDetails?.loadStatus;
      final statusString = loadItem.loadStatusDetails?.loadStatus;
      final status = LpHomeHelper.getLoadStatusFromString(statusString);
      if (status == LoadStatus.matching || status == LoadStatus.kycPending) {
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
        child: BlocBuilder<LpLoadCubit, LpLoadState>(
            builder: (context, state) {
              final uiState = state.lpLoadById;

              if (uiState == null || uiState.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              final loadItem = uiState.data?.data as LoadData;

              if (loadItem.isNull) {
                return Center(child: Text(context.appText.noLoadFound));
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                callTimer(loadItem);
              });
              final status = LpHomeHelper.getLoadStatusFromString(loadItem.loadStatusDetails?.loadStatus);

              return Stack(
                children: [
                  GoogleMapWidget(
                    pickupLocation: loadItem.loadRoute?.pickUpLocation,
                    dropLocation: loadItem.loadRoute?.dropLocation,
                    pickUpLatLong: loadItem.loadRoute?.pickUpLatlon,
                    dropLatLong: loadItem.loadRoute?.dropLatlon,
                  ),
                  buildTopLocationWidget(loadItem, status),
                  LpLoadBottomWidget(loadItem: loadItem, kilometers: kilometers, loadStatus: status!),
                  buildSupportWidget(),
                ],
              );
            }
        ),
      ),
    );
  }
  

  /// Location Details
  Widget buildTopLocationWidget(LoadData loadItem, LoadStatus? status) {
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
                GestureDetector(onTap: () {
                  Navigator.pop(context);
                },child: Icon(Icons.arrow_back)),
                8.width,
                Text(loadItem.loadSeriesId, style: AppTextStyle.body3),
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
                        loadItem.loadRoute?.pickUpLocation ?? '',
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
                ).expand(),
                // 10.width,
                Icon(Icons.arrow_forward),
                20.width,

                // Drop location & date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        loadItem.loadRoute?.dropLocation ?? '',
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
                ).expand(),
                // Spacer(),

                // Load status & matching time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: commonContainerDecoration(
                        color: LpHomeHelper.getLoadStatusColor(loadItem.loadStatusDetails?.loadStatus ?? ''),
                      ),
                      // width: 80,
                      child: Text(
                        LpHomeHelper.getLoadTypeDisplayText(loadItem.loadStatusDetails?.loadStatus ?? ''),
                        style: AppTextStyle.body3.copyWith(
                          color: LpHomeHelper.getLoadStatusTextColor(loadItem.loadStatusDetails?.loadStatus ?? ''),
                        ),
                      ).center().paddingSymmetric(vertical: 4,horizontal: 10),
                    ),
                    4.height,
                    if (status == LoadStatus.kycPending)
                      if(loadItem.customer?.kycPendingDate != null)
                        Text(
                        _countDown,
                        // LpHomeHelper.getKycPendingTimeLeft(loadItem.customer!.kycPendingDate.toString()),
                        style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).paddingRight(5),
                    if (status == LoadStatus.matching)
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

