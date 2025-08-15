import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart'
    hide DataTruckType;
import 'package:gro_one_app/features/kavach/view/kavach_support_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/tracking_progress_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/payment_information_dialogue.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/source_destination_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/vp_damages_and_shortages_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/vp_settlements_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/added_damage_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/document_widget_view.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/information_view.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/vp_added_damage.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/view/vp_pod_dispatch_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/trip_schedule_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/view/vp_tripstatement_screen.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';

import 'package:path_provider/path_provider.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

import '../../../../trip_tracking/widgets/payment_information_dialogue.dart';

class LoadDetailsWidget extends StatelessWidget {
  final LoadDetailsCubit cubit;
  final LPHomeCubit lpHomeCubit;
  final VpHomeBloc vpHomeBloc;
  final List<dynamic> documentList;
  // final Future Function() onRefresh;

  const LoadDetailsWidget({
    super.key,
    required this.cubit,
    required this.lpHomeCubit,
    required this.vpHomeBloc,
    // required this.onRefresh,
    this.documentList = const [],
  });

  changeLoadStatus(BuildContext context, String? id, {int? loadStatus}) async {
    if (cubit.state.loadStatus == LoadStatus.accepted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TripScheduleScreen(loadId: id)),
      ).then((value) {
        cubit.getLoadDetails(id ?? "0");
      });
      return;
    }

    String? userId = await vpHomeBloc.getUserId();
    await cubit
        .changedLoadStatus(
          id ?? "0",
          customerId: userId,
          loadStatus: loadStatus ?? 3,
        )
        .then((value) {
          if (cubit.state.loadStatus == LoadStatus.accepted &&
              cubit.state.vpLoadStatus?.status == Status.SUCCESS) {
            AppDialog.show(
              navigatorKey.currentState!.context,
              child: SuccessDialogView(
                message: context.appText.loadAcceptedSuccessfully,
                afterDismiss: () {
                  if (navigatorKey.currentState?.canPop() ?? false) {
                    navigatorKey.currentState?.pop();
                  }
                },
              ),
            );
          }
          getLoadDetails(id ?? "");
        });
  }

  getLoadDetails(String id) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => cubit.getLoadDetails(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
      buildWhen: (previous, current) => current != previous,
      listener: (context, state) {},
      bloc: cubit,
      builder: (context, state) {
        LoadDetailModelData? loadDetails;
        if (state.loadDetailsUIState?.status == Status.LOADING) {
          return CircularProgressIndicator().center();
        }
        if (state.loadDetailsUIState?.status == Status.ERROR) {
          return genericErrorWidget(error: state.loadDetailsUIState?.errorType);
        }
        if (state.loadDetailsUIState?.status == Status.SUCCESS) {
          final loads = state.loadDetailsUIState?.data;

          if (loads?.data == null) {
            return genericErrorWidget(error: NotFoundError());
          }
          loadDetails = loads?.data;

          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              decoration: commonContainerDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                shadow: true,
              ),
              child: Column(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      return getLoadDetails(loadDetails?.loadId ?? "");
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRequestWidget(
                            (state.loadStatus == LoadStatus.accepted),
                            loadDetails,
                            state.loadStatus,
                            context,
                          ),
                          10.height,
                          _simTrackingConsent(
                            loadDetails?.driverConsent == 0 &&
                                ((state.loadStatusId ?? 0) > 4),
                            context,
                          ),
                          commonDivider(thickness: 3, height: 15),
                          12.height,
                          if (((state.loadStatusId ?? 0) > 4)) ...[
                            Builder(
                              builder: (context) {
                                final trackingData =
                                    state.trackingDistance?.data;
                                if (trackingData == null) {
                                  return SizedBox();
                                }
                                return TrackingProgress(
                                  progressPercentage:
                                      trackingData.coverPercentage ?? 0,
                                  remainingDistance:
                                      trackingData.currentdistance ?? '--',
                                  totalDistance:
                                      trackingData.overalldistance ?? '--',
                                  eta: trackingData.durationValue,
                                ).paddingSymmetric(horizontal: 15);
                              },
                            ),
                            20.height,
                          ],
                          SourceDestinationWidget(
                            pickUpLocation:
                                loadDetails?.loadRoute?.pickUpLocation,
                            dropLocation: loadDetails?.loadRoute?.dropLocation,
                          ).paddingSymmetric(horizontal: 15),

                          15.height,
                          _buildQuotedPriceWidget(
                            (state.loadStatusId ?? 0) >= 4,
                            loadDetails?.loadPrice?.rate,
                            loadDetails?.loadPrice?.vpRate,
                            loadDetails?.loadPrice?.vpMaxRate,
                            context,
                            state.loadStatusId ?? 0,
                            loadDetails?.paymentEntry,
                            loadDetails?.loadMemo,
                            loadDetails?.loadStatusValue,
                          ),
                          15.height,
                          _buildLoadEntityWidget(
                            loadDetails,
                            state.locationDistance,
                            context,
                          ),
                          15.height,
                          if ((state.loadStatusId ?? 0) > 4) ...[
                            _buildConsigneeDetail(
                              context: context,
                              isVisible: loadDetails?.consignee != null,
                              name: loadDetails?.consignee?.name,
                              email: loadDetails?.consignee?.email,
                              phoneNo: loadDetails?.consignee?.mobileNumber,
                              isUpdatable: false,
                              isTextField: false,
                            ),
                            20.height,
                            commonDivider(thickness: 3, height: 15),
                            8.height,
                            Text(
                              context.appText.tripDocument,
                              style: AppTextStyle.h4,
                            ).paddingSymmetric(horizontal: 15),

                            buildAttachmentView(
                              context,
                              loadDetails?.loadId,
                              state,
                            ),

                            _buildDispatchedDetails(
                              loadDetails?.podDispatch,
                              context,
                            ),

                            if ((loadDetails?.loadStatusId ?? 0) >= 7) ...[
                              20.height,
                              _buildAdableSectionHeader(
                                showAddButton:
                                    state.loadStatus != LoadStatus.completed &&
                                    state.loadStatus !=
                                        LoadStatus.podDispatched,
                                context: context,
                                title: context.appText.damageAndShortage,
                                onAdd: () async {
                                  await Navigator.push(
                                    context,
                                    commonRoute(
                                      VpDamagesAndShortagesScreen(
                                        vehicleId:
                                            loadDetails
                                                ?.scheduleTripDetails
                                                ?.vehicleId,
                                        loadId: loadDetails?.loadId,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value) {
                                      getLoadDetails(loadDetails?.loadId ?? "");
                                    }
                                  });
                                },
                              ),

                              Visibility(
                                visible:
                                    (loadDetails?.damageShortage ?? [])
                                        .isNotEmpty,
                                child: Column(
                                  children: [
                                    20.height,
                                    VpAddedDamageWidget(
                                      imageList: state.allDamageImageList,
                                      damageReport: loadDetails?.damageShortage,
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 20),
                              ),

                              _approvedDamageInformation(loadDetails?.loadSettlement,context),

                              20.height,
                              _buildAdableSectionHeader(
                                context: context,
                                showAddButton:
                                    state.loadStatus != LoadStatus.completed &&
                                    loadDetails?.loadSettlement == null,
                                title: context.appText.settlement,
                                onAdd: () async {
                                  await Navigator.push(
                                    context,
                                    commonRoute(
                                      VpSettlementsScreen(
                                        loadId: loadDetails?.loadId,
                                        vehicleID:
                                            loadDetails
                                                ?.scheduleTripDetails
                                                ?.vehicleId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _submittedSettlementInfoWidget(
                                loadDetails?.loadSettlement,
                                context,
                              ),
                            ],
                          ],

                          if ((state.loadStatusId ?? 0) >= 4) ...[
                            20.height,
                            commonDivider(thickness: 3, height: 15),
                            8.height,
                            Text(
                              context.appText.timeLine,
                              style: AppTextStyle.h4w500,
                            ).paddingSymmetric(horizontal: 15),
                            20.height,
                            LoadTimelineWidget(
                              timelineList: loadDetails?.timeline ?? [],
                            ).paddingSymmetric(horizontal: 15),
                          ],
                        ],
                      ),
                    ),
                  ).expand(),
                  if (loadDetails?.loadOnHold == false)
                    _buildBottomButtonWidget(loadDetails, state, context),
                ],
              ).paddingTop(15),
            ),
          );
        }
        return genericErrorWidget(error: GenericError());
      },
    );
  }

  /// DriverSimTrackingConsent
  Widget _simTrackingConsent(bool visible, BuildContext context) {
    return Visibility(
      visible: visible,
      child: Center(
        child: Text(
          context.appText.noSimTracking,
          style: AppTextStyle.h3w500.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w100,
            color: AppColors.iconRed,
          ),
        ),
      ).paddingTop(15),
    );
  }

  /// Build Request Widget
  Widget _buildRequestWidget(
    bool isAccepted,
    LoadDetailModelData? loadDetails,
    LoadStatus? loadStatus,
    BuildContext context,
  ) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Image.asset(
            AppImage.png.dummyTruckLoad,
            width: 57,
            height: 42,
          ).expand(flex: 2),
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if ((loadDetails?.loadStatusId ?? 0) >= 4)
                _buildAssignedTruckDetails(
                  loadDetails?.scheduleTripDetails?.vehicle,
                  loadDetails?.truckType,
                )
              else
                Text(
                  context.appText.requested,
                  style: AppTextStyle.body1GreyColor.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff979797),
                  ),
                ),
              if ((loadDetails?.loadStatusId ?? 0) >= 4)
                _buildAssignedDriverDetails(
                  loadDetails?.scheduleTripDetails?.driver,
                  context,
                )
              else
                Text(
                  "${loadDetails?.truckType?.type} - ${loadDetails?.truckType?.subType}",
                  style: AppTextStyle.body1BlackColor.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.textBlackDetailColor,
                  ),
                ),
            ],
          ).expand(flex: 7),
          if ((loadStatus?.index ?? 0) >= LoadStatus.assigned.index)
            GestureDetector(
              onTap:
                  () => callRedirect(
                    loadDetails?.scheduleTripDetails?.driver?.mobile ?? "",
                  ),
              child: SvgPicture.asset(AppIcons.svg.phoneCall),
            ).expand(flex: 1),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  /// assigned truck details
  Widget _buildAssignedTruckDetails(
    ScheduleTripDetailsVehicle? vehicle,
    DataTruckType? truckType,
  ) {
    final truckDetails =
        "${truckType?.type ?? ""} (${truckType?.subType ?? ""})";
    return Row(
      children: [
        Container(
          decoration: commonContainerDecoration(
            color: Color(0xffFFC100),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            vehicle?.truckNo ?? "",
          ).paddingSymmetric(vertical: 2, horizontal: 5),
        ),
        5.width,
        Text(
          truckDetails,
          style: AppTextStyle.body3.copyWith(color: AppColors.thinLightGray),
          overflow: TextOverflow.ellipsis,
        ).expand(),
        5.width,
      ],
    );
  }

  /// show trip assigned driver details
  Widget _buildAssignedDriverDetails(Driver? driver, BuildContext context) {
    return Row(
      children: [
        Text(
          "${context.appText.driver}:",
          style: AppTextStyle.body3.copyWith(color: AppColors.thinLightGray),
        ),
        Text(
          " ${driver?.name.capitalizeFirst}",
          style: AppTextStyle.h3w500.copyWith(
            fontSize: 13,
            color: AppColors.textBlackDetailColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuotedPriceWidget(
    bool isAccepted,
    String? rate,
    String? vpRate,
    String? vpMaxRate,
    BuildContext context,
    int loadStatusID,
    LoadPaymentDetails? paymentEntity,
    MemoDetails? loadMemo,
    LoadStatus? loadStatus,
  ) {
    final vpLoadPrice =
        (vpMaxRate == null || vpMaxRate.isEmpty || vpMaxRate == "0")
            ? PriceHelper.formatINR(vpRate)
            : '${PriceHelper.formatINR(vpRate)} - ${PriceHelper.formatINR(vpMaxRate)}';

    final agreedPrice = paymentEntity?.payableAgreedPrice ?? "";

    /// This is for advanced Payment
    final advancedPayment = paymentEntity?.payableAdvancePaid ?? "";
    final advancedPaymentPercentage = paymentEntity?.payableAdvancePercentage ?? "";
    final isAdvancedPaid = paymentEntity?.payableAdvancedPaidFlag ?? false;

    /// This is for balance Payment
    final balancePayment = paymentEntity?.payableBalancePaid;
    final isBalancePaid = paymentEntity?.payableBalancePaidFlag ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: commonContainerDecoration(
        color: AppColors.lightBlueColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Visibility(
            visible: loadMemo == null && agreedPrice.isEmpty,
            child: Row(
              mainAxisAlignment:
                  isAccepted
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAccepted
                      ? context.appText.tripPrice
                      : context.appText.quotedPrice,
                  style: AppTextStyle.body2.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlackColor,
                  ),
                ),
                Text(
                  vpLoadPrice,
                  style: AppTextStyle.h1PrimaryColor.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),

          ...[
            5.height,
            _buildLoadProviderAdvancePaymentCardViewOnly(
              context: context,
              showViewMore: paymentEntity?.vpLogs?.isNotEmpty ??false,
              advancePayment: isAdvancedPaid ? PriceHelper.formatINR(advancedPayment) : "",
              agreedPrice:
                  agreedPrice.isNotEmpty
                      ? PriceHelper.formatINR(agreedPrice)
                      : "",
              advancedPaymentPer: advancedPaymentPercentage,
              balancePayment:isBalancePaid ?   PriceHelper.formatINR(balancePayment):"",
              onViewTap: () {
                showPaymentView(
                  vpLogs: paymentEntity?.vpLogs,
                  context,
                  tripCost:
                      agreedPrice.isNotEmpty
                          ? PriceHelper.formatINR(agreedPrice)
                          : "",
                  advanceAmount: PriceHelper.formatINR(advancedPayment),
                  advancePercentage: advancedPaymentPercentage,
                );
              },
              // tripPrice: "1000",
            ),
          ],
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildLoadEntityWidget(
    LoadDetailModelData? loadDetails,
    String? locationDistance,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 15,

      children: [
        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppIcons.svg.package, height: 24, width: 24),
            Text(
              loadDetails?.commodity?.name ?? "",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.svg.kgWeight,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),

            Text(
              "${loadDetails?.weight?.value} ${context.appText.ton}",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.svg.locationDistance,
              height: 24,
              width: 24,
            ),
            Text(
              cubit.state.locationDistance ?? '',
              style: AppTextStyle.body3.copyWith(
                color: AppColors.veryLightGreyColor,
              ),
            ),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildBottomButtonWidget(
    LoadDetailModelData? loadDetails,
    LoadDetailsState state,
    BuildContext context,
  ) {
    bool isPriceIntoRange = checkPriceIntoRange(
      loadDetails?.loadPrice?.vpRate ?? "0",
      loadDetails?.loadPrice?.vpMaxRate ?? "0",
    );
    return Container(
      decoration: commonContainerDecoration(
        color: Colors.white,
        blurRadius: 30,
        shadow:
            state.loadStatus == LoadStatus.accepted ||
            state.loadStatus == LoadStatus.assigned,
      ),
      child: Row(
        spacing: 10,
        children: [
          ...[
            if (state.loadStatus == LoadStatus.matching && !isPriceIntoRange)
              AppButton(
                title: context.appText.support,
                style: AppButtonStyle.outline.copyWith(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () {
                  commonSupportDialog(context);
                },
                textStyle: TextStyle(fontSize: 14),
              ).expand(),
            if (state.loadStatus == LoadStatus.matching ||
                state.loadStatus == LoadStatus.accepted ||
                state.loadStatus == LoadStatus.completed)
              AppButton(
                isLoading: state.vpLoadStatus?.status == Status.LOADING,
                title: getButtonText(
                  state.loadStatus ?? LoadStatus.matching,
                  priceIntoRange: isPriceIntoRange,
                ),
                style: AppButtonStyle.primary.copyWith(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (isPriceIntoRange) {
                    await callRedirect(SUPPORT_NUMBER);
                    return;
                  }

                  if (state.loadStatus == LoadStatus.completed) {
                    Navigator.push(
                      context,
                      commonRoute(
                        VpTripStatementScreen(
                          loadDetailModelData: loadDetails,
                          loadId: loadDetails?.loadId,
                        ),
                      ),
                    );
                    return;
                  }
                  changeLoadStatus(context, loadDetails?.loadId.toString());
                },
                textStyle: TextStyle(fontSize: 14, color: AppColors.white),
              ).expand(),
            if ((state.loadStatusId ?? 0) >= 4 &&
                state.loadStatus != LoadStatus.completed)
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.90,
                child: CustomSwipeButton(
                  padding: 0,
                  price: 0,
                  loadId: "",
                  enable: cubit.isNextProcessButtonEnabled(
                    documentEntity: state.tripDocumentList ?? [],
                    driverConsent: loadDetails?.driverConsent ?? 0,
                    loadStatus: state.loadStatus,
                    memo: loadDetails?.loadMemo,
                  ),
                  text: getSwipeButtonTitle(
                    state.loadStatus ?? LoadStatus.matching,
                    loadDetails?.podDispatch
                  ),
                  onSubmit: () async {
                    if (state.loadStatus == LoadStatus.podDispatched && loadDetails?.podDispatch==null) {
                      await  Navigator.push(
                        context,
                        commonRoute(
                          VpPodDispatchScreen(loadId: loadDetails?.loadId),
                        ),
                      );
                      getLoadDetails(loadDetails?.loadId??"");
                      return;
                    }

                    return changeLoadStatus(
                      context,
                      loadDetails?.loadId.toString(),
                      loadStatus: (state.loadStatusId ?? 0) + 1,
                    );
                  },
                ),
              ),
          ],
        ],
      ).paddingSymmetric(horizontal: 15, vertical: 12),
    );
  }

   showPaymentView(
    BuildContext context, {
    String? advancePercentage,
    String? advanceAmount,
    String? tripCost, List<VpLog>? vpLogs,
  }) {
    Navigator.push(context, commonRoute(VpPaymentSummary(
      vpLogs: vpLogs,
      advancedPercentage: advancePercentage,
      advanceAmount: advanceAmount,
      balancePayout: PriceHelper.formatINR("4000"),
      isAdvanceCompleted: true,
      isBalancePending: false,
      onProceed: () {},
      paymentMode: "",
      receivedOn: "",
      transactionId: "467898765432",
      tripCost: tripCost,
    ),));
  }

  Widget buildAttachmentView(
    BuildContext context,
    String? loadId,
    LoadDetailsState state,
  ) {
    final tripDocumentList = state.tripDocumentList ?? [];
    return Column(
      children: List.generate(
        tripDocumentList.length,
        (index) => DocumentWidgetView(
          index: index,
          loadDetailsCubit: cubit,
          hintText: tripDocumentList[index].title,
          documentEntity: tripDocumentList[index],
          onGetFile: (p0) {
            cubit.uploadDocument(
              File(p0),
              tripDocumentList[index].fileType ?? "",
              tripDocumentList[index].title,
              tripDocumentList[index].documentTypeId,
              loadId ?? "",
              index,
            );
          },
        ).paddingSymmetric(horizontal: 15),
      ),
    );
  }

  Widget _buildDispatchedDetails(
    PodDispatch? podDispatched,
    BuildContext context,
  ) {
    if (podDispatched == null) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonDivider(),
        _buildHeading(text: context.appText.podDispatch),
        15.height,
        InformationView(
          title: context.appText.courierCompany,
          amount: podDispatched.courierCompany,
        ).paddingSymmetric(horizontal: 15),
        10.height,
        InformationView(
          title: context.appText.awbNumber,
          amount: podDispatched.awbNumber,
        ).paddingSymmetric(horizontal: 15),
        10.height,
        commonDivider(thickness: 3, height: 15),
      ],
    );
  }
}

//Payment View only
Widget _buildLoadProviderAdvancePaymentCardViewOnly({
  required BuildContext context,
  String? agreedPrice,
  String? advancePayment,
  String? balancePayment,
  VoidCallback? onViewTap,
  String? advancedPaymentPer,
  bool? showViewMore,

}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if ((agreedPrice ?? "").isNotEmpty)
        _buildPriceRow(
          context.appText.agreedPrice,
          agreedPrice ?? '',
          context,
          highlight: true,
        ),
      if ((advancePayment ?? "" ).isNotEmpty) ...[
        8.height,
        _buildPriceRow(
          "${context.appText.advancedReceived}",
          advancePayment??"",
          context,
          highlight: true,
          showPercentage: true,
          percentage: advancedPaymentPer
        ),
      ],

      if ((balancePayment ?? "").isNotEmpty) ...[
        8.height,
        _buildPriceRow(
          context.appText.balanceReceived,
          balancePayment ?? "",
          context,
          highlight: true,
        ),

      ],

      if (showViewMore ?? false)
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: onViewTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.appText.view,
                    style: AppTextStyle.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
}

// Prcie Row
Widget _buildPriceRow(
  String label,
  String amount,

  BuildContext context, {
  bool highlight = false,
      bool ? showPercentage,
      String? percentage,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(
            label,
            style: AppTextStyle.body2.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: AppColors.textBlackColor,
            ),
          ),
          if(showPercentage??false)
            Text(
             " (${percentage??""}%)",
              style: AppTextStyle.body1GreyColor.copyWith(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                color:AppColors.textBlackColor,

              ),
            ),
        ],
      ),
      Flexible(
        child: Text(
          amount,
          style: AppTextStyle.body1GreyColor.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color:
                highlight
                    ? AppColors.primaryColor
                    : AppColors.textGreyDetailColor,
          ),
        ),
      ),
    ],
  );
}

// Status Details
Widget _buildStatusRow({
  required String title,
  required String amount,
  required String statusText,
  required Color statusColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyle.body.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.darkDividerColor,
        ),
      ),
      6.height,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            amount,
            style: AppTextStyle.body.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: AppTextStyle.textBlackColor12w400.copyWith(
                color: AppColors.textGreen,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// Consignee Details
Widget _buildConsigneeDetail({
  required BuildContext context,
  String? name,
  String? phoneNo,
  String? email,
  bool isTextField = false,
  bool isUpdatable = false,
  TextEditingController? nameController,
  TextEditingController? phoneController,
  TextEditingController? emailController,
  bool? isVisible,
}) {
  return Visibility(
    visible: isVisible ?? false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        commonDivider(thickness: 3, height: 15),
        Row(
          children: [
            Text(context.appText.consigneeDetails, style: AppTextStyle.h4),
            Spacer(),
            if (isUpdatable)
              AppButton(
                title: context.appText.update,
                style: AppButtonStyle.outlineShrink,
                textStyle: AppTextStyle.buttonPrimaryColorTextColor,
                onPressed: () {},
              ),
          ],
        ),
        if (isTextField)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              // Name
              AppTextField(
                validator: (value) => Validator.fieldRequired(value),
                controller: nameController,
                labelText: context.appText.name,
                mandatoryStar: true,
              ),
              20.height,
              // Contact Number
              AppTextField(
                validator: (value) => Validator.fieldRequired(value),
                controller: phoneController,
                labelText: context.appText.contactNumber,
                mandatoryStar: true,
              ),
              20.height,
              AppTextField(
                validator: (value) => Validator.fieldRequired(value),
                controller: emailController,
                labelText: context.appText.emailId,
                mandatoryStar: false,
              ),
            ],
          )
        else
          Column(
            children: [
              20.height,
              // Contact Name
              _buildDetailWidget(
                text1: context.appText.name,
                text2: name ?? "",
              ),

              20.height,

              // Contact Number
              _buildDetailWidget(
                text1: context.appText.contactNo,
                text2: phoneNo ?? "",
              ),
              20.height,

              // Email Id
              _buildDetailWidget(
                text1: context.appText.emailId,
                text2: email ?? "",
              ),
            ],
          ),
      ],
    ).paddingSymmetric(horizontal: 15),
  );
}

// Detail Widget
Widget _buildDetailWidget({required String text1, required String text2}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text1,
        style: AppTextStyle.body2.copyWith(color: AppColors.textBlackColor),
      ),
      Text(
        text2,
        style: AppTextStyle.body2.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
      ),
    ],
  );
}

// Doc Preview

//submitted settlement

Widget _submittedSettlementInfoWidget(
  LoadSettlement? loadSettlement,
  BuildContext context,
) {
  if (loadSettlement == null) {
    return SizedBox.shrink();
  }
  final numberOfDays = loadSettlement.noOfDays ?? 1;
  final amount = loadSettlement.amountPerDay ?? 1;
  final detentionsAmount = PriceHelper.formatINR(
    (amount * numberOfDays).toString(),
  );

  return Padding(
    padding: EdgeInsets.only(top: 15),
    child: Column(
      spacing: 15,
      children: [
        InformationView(
          title:
              "${context.appText.detentions.capitalizeFirst} (${loadSettlement.noOfDays ?? 1} ${context.appText.days})",
          amount: detentionsAmount,
        ),

        InformationView(
          title: context.appText.loadingCharges,
          amount:
              PriceHelper.formatINR(loadSettlement.loadingCharge).toString(),
        ),

        InformationView(
          title: context.appText.unloadingCharges,
          amount:
              PriceHelper.formatINR(loadSettlement.unLoadingCharge).toString(),
        ),
      ],
    ).paddingSymmetric(horizontal: 15),
  );
}


/// damage information
Widget _approvedDamageInformation(
  LoadSettlement? loadSettlement,
  BuildContext context,
) {
  if (loadSettlement == null) {
    return SizedBox.shrink();
  }
  String debitDamages =  (loadSettlement.debitDamages??"").isNotEmpty && loadSettlement.debitDamages!.trim()!="0" ?  PriceHelper.formatINR(loadSettlement.debitDamages ?? "",):"";
  String debitShortage =  (loadSettlement.debitShortages ?? "").isNotEmpty  && loadSettlement.debitShortages!.trim() !="0" ?  PriceHelper.formatINR(loadSettlement.debitShortages ?? ""):"";
  String debitPenalties=  (loadSettlement.debitPenalities ?? "").isNotEmpty && loadSettlement.debitPenalities!.trim()!="0" ?  PriceHelper.formatINR(loadSettlement.debitPenalities ?? ""):"";


  return Column(
    spacing: 15,
    children: [
      if(debitDamages.isNotEmpty || debitShortage.isNotEmpty || debitPenalties.isNotEmpty)
      ...[
        10.height,
      ],
      if(debitDamages.isNotEmpty)
      InformationView(
        title: context.appText.damage,
        amount: debitDamages,
      ),
      if(debitShortage.isNotEmpty)
      InformationView(
        title: context.appText.shortage,
        amount: debitShortage
      ),
      if(debitPenalties.isNotEmpty)
      InformationView(
        title:context.appText.penalties,
        amount: debitPenalties
      ),
    ],
  ).paddingSymmetric(horizontal: 15);
}

// Addable Section Header
Widget _buildAdableSectionHeader({
  required BuildContext context,
  required String title,
  required VoidCallback onAdd,
  bool? showAddButton,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildHeading(text: title),
      Spacer(),
      Visibility(
        visible: (showAddButton ?? true),
        child: GestureDetector(
          onTap: onAdd,
          child: Text(
            '+ ${context.appText.add}',
            style: AppTextStyle.body2.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
      10.width,
    ],
  );
}

// Heading
Widget _buildHeading({required String text}) {
  return Text(
    text,
    style: AppTextStyle.h4w500.copyWith(fontSize: 18),
  ).paddingSymmetric(horizontal: 15);
}
