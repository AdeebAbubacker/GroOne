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
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';

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

              if(uiState.status == Status.ERROR) {
                return Stack(
                  children: [
                    Positioned(top: 20,left: 0,child: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                    genericErrorWidget(onRefresh: () => lpLoadLocator.getLpLoadsById(loadId: widget.loadId), error: uiState.errorType).paddingTop(50),
                  ],
                );
              }

              final loadItem = uiState.data?.data as LoadData;

              final status = LpHomeHelper.getLoadStatusFromString(loadItem.loadStatusDetails?.loadStatus);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                callTimer(loadItem);
              });

              return Stack(
                children: [
                  GoogleMapWidget(
                    pickupLocation: loadItem.loadRoute?.pickUpLocation,
                    dropLocation: loadItem.loadRoute?.dropLocation,
                    pickUpLatLong: loadItem.loadRoute?.pickUpLatlon,
                    dropLatLong: loadItem.loadRoute?.dropLatlon,
                    driverLat: loadItem.trackingDetails?.currentLat,
                    driverLong: loadItem.trackingDetails?.currentLong,
                  ),
                  buildTopLocationWidget(loadItem, status),
                  LpLoadBottomWidget(loadItem: loadItem, loadStatus: status!),
                  buildFloatingWidget(status),
                  if(status.index >= LoadStatus.loading.index)
                    buildSimConsentWidget(loadItem),
                ],
              );
            }
        ),
      ),
    );
  }
  

  /// Location Details
  Widget buildTopLocationWidget(LoadData loadItem, LoadStatus? status) {
    var statusData = loadItem.loadOnhold ? context.appText.unloadingHeld :loadItem.loadStatusDetails?.loadStatus ?? '';
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
                  loadItem.createdAt != null ? DateTimeHelper.formatCustomDateTimeIST(loadItem.createdAt!) : "--",
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
                          ? DateTimeHelper.formatCustomDateIST(loadItem.pickUpDateTime!)
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
                          ? DateTimeHelper.formatCustomDateIST(loadItem.expectedDeliveryDateTime!)
                          : "--",
                      style: AppTextStyle.body4.copyWith(color: AppColors.lightBlackColor),
                    ),
                  ],
                ).expand(),
                // Spacer(),

                // Load status & matching time
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(loadItem.loadOnhold) {
                            AppDialog.show(context, dismissible: true, child: CommonDialogView(
                            hideCloseButton: true,
                            child: Column(
                              children: [
                                Lottie.asset(AppJSON.alertRed, repeat: true, frameRate: FrameRate(200)),
                                Text(context.appText.unloadingHeld, style: AppTextStyle.h3.copyWith(fontSize: 26, color: AppColors.orangeTextColor)),
                                10.height,
                                Text(context.appText.yourShipmentIsHeld, textAlign: TextAlign.center, style: AppTextStyle.body3),
                                10.height,
                              ],
                            ),
                          ));
                          }
                        },
                        child: Container(
                          decoration: commonContainerDecoration(
                            color: loadItem.loadOnhold ? AppColors.red : LpHomeHelper.getColor(loadItem.loadStatusDetails?.statusBgColor ?? ''),
                          ),
                          // width: 80,
                          child: Text(
                            LpHomeHelper.getLoadTypeDisplayText(statusData),
                            style: AppTextStyle.body3.copyWith(
                              color: loadItem.loadOnhold ? AppColors.white : LpHomeHelper.getColor(loadItem.loadStatusDetails?.statusTxtColor ?? ''),
                            ),
                          ).center().paddingSymmetric(vertical: 4,horizontal: 10),
                        ),
                      ),
                      4.height,
                      if (status == LoadStatus.kycPending || status == LoadStatus.matching)
                        Text(_countDown, style: AppTextStyle.body4.copyWith(color: AppColors.greenColor)),
                      if(((status?.index ?? 0) >= LoadStatus.inTransit.index && loadItem.lpPaymentsData?.receivableAdvancePaidFlg == false))
                        Row(
                          children: [
                            const Icon(Icons.error, size: 16, color: AppColors.iconRed),
                            4.width,
                            Text(
                              context.appText.advanceUnpaid,
                              style: AppTextStyle.body.copyWith(fontSize: 10, color: AppColors.iconRed),
                            ).flexible(),
                          ],
                        ),
                      if((status == LoadStatus.completed && (loadItem.lpPaymentsData?.receivableBalancePaidFlg == false &&loadItem.lpPaymentsData?.receivableAdvancePaidFlg == true)))
                        Row(
                          children: [
                            const Icon(Icons.error, size: 16, color: AppColors.iconRed),
                            4.width,
                            Text(
                              context.appText.balanceUnpaid,
                              style: AppTextStyle.body.copyWith(fontSize: 10, color: AppColors.iconRed),
                            ).flexible(),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            )
          ],
        ).paddingAll(commonRadius),
      ),
    );
  }


  /// Support
  Widget buildFloatingWidget(status) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomWidgetMaxHeight = status == LoadStatus.matching ? screenHeight * 0.35 : screenHeight * 0.45;

    return Positioned(
        right: 5, bottom: bottomWidgetMaxHeight + 10,child: Column(
          children: [
            // if(status.index > LoadStatus.assigned.index)
            // IconButton(
            //     onPressed: () {
            //
            //     },
            //     icon: Container(
            //       padding: EdgeInsets.all(4),
            //       decoration: commonContainerDecoration(shadow: true,shadowColor: AppColors.secondaryButtonColor,borderRadius: BorderRadius.circular(20)),
            //       child: Icon(Icons.location_searching, color: AppColors.primaryColor),
            //     )
            // ),
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

  Widget buildSimConsentWidget(LoadData loadItem) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomWidgetMaxHeight = screenHeight * 0.45;
    final isTrackingAllowed = loadItem.driverConsent == 1;

    return Positioned(
      left: 15, bottom: bottomWidgetMaxHeight + 15,
      child: Container(
        decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Container(decoration: BoxDecoration(shape: BoxShape.circle, color: isTrackingAllowed ? AppColors.activeDarkGreenColor : AppColors.red), height: 12, width: 12),
            10.width,
            Text(context.appText.sim, style: AppTextStyle.h5 )
          ],
        ).paddingAll(8),
      ),
    );
  }
}

