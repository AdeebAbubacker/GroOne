import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/driver/driver_damages_and_shortages/view/driver_damages_and_shortages_screen.dart';
import 'package:gro_one_app/features/driver/driver_home/helper/driver_load_helper.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_document_widget_view.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_load_timeline_widget.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_source_destination_widget.dart';
import 'package:gro_one_app/features/driver/driver_pod/view/driver_pod_dispatch_screen.dart';
import 'package:gro_one_app/features/driver/driver_settlements/view/driver_settlements_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/tracking_progress_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/information_view.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/vp_added_damage.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../../data/ui_state/status.dart';

class DriverLoadBottomWidget extends StatefulWidget {
  final DriverLoadDetailsCubit cubit;
  final DriverLoadDetailsModel loadItem;
  const DriverLoadBottomWidget({
    super.key,
    required this.loadItem,
    required this.cubit,
  });

  @override
  State<DriverLoadBottomWidget> createState() => _DriverLoadBottomWidgetState();
}

class _DriverLoadBottomWidgetState extends State<DriverLoadBottomWidget> {
  final driverLoadDetailsCubit = locator<DriverLoadDetailsCubit>();

  Future<void> getLoadDetails() async {
    frameCallback(() async {
      await driverLoadDetailsCubit.getDriverLoadsById(
        loadId: widget.loadItem.data?.loadId ?? '',
      );
      final statusId =
          driverLoadDetailsCubit.state.lpLoadById?.data?.data?.loadStatusId;
      if (statusId != null) {
        driverLoadDetailsCubit.updatePODVisibilityBasedOnStatus(statusId);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentStatus = widget.loadItem.data?.loadStatusId;

      widget.cubit.updatePODVisibilityBasedOnStatus(currentStatus);
      widget.cubit.resetLoadStatuUpdateReset();
    });
  }

  List<dynamic> lorryReceiptFiles = [];
  List<String> uploadedLorryReceipts = [];

  List<dynamic> eWayBillFiles = [];
  List<String> uploadedEWayBills = [];

  List<dynamic> materialInvoiceFiles = [];
  List<String> uploadedMaterialInvoices = [];
  final loadDetailsCubit = locator<LoadDetailsCubit>();

  /// Update Load Status
  changeLoadStatus(
    BuildContext context, {
    required int loadStatus,
    required String loadId,
  }) async {
    // String? userId = await widget.cubit.getUserId();
    await widget.cubit
        .fupdateLoadStatus(
          customerId: widget.loadItem.data?.vpCustomer?.customerId ?? "",
          loadStatus: loadStatus,
          loadid: loadId,
        )
        .then((value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.cubit.getDriverLoadsById(loadId: loadId ?? "0");
            widget.cubit.updatePODVisibilityBasedOnStatus(loadStatus);
          });
        });
  }

  /// Check for button enabled
  bool isChangeStatusButtonEnabled({
    required int? loadStatus,
    required int driverConsent,
    required List<DocumentEntity>? tripDocumentList,
    required bool isMemoUploaded,
    required bool isLpgreed,
  }) {
    if (loadStatus == null) return false;
    if (loadStatus == 4) {
      return isMemoUploaded && isLpgreed;
    }

    if (loadStatus == 5) {
      if (tripDocumentList == null ||
          !widget.cubit.areRequiredDocsUploaded(
            tripDocumentList,
            DriverLoadHelper.getLoadStatus(widget.loadItem.data?.loadStatusId),
          ))
        return false;
    }

    if (loadStatus == 7) {
      if (tripDocumentList == null ||
          !widget.cubit.isPODUploaded(tripDocumentList))
        return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverLoadDetailsCubit, DriverLoadDetailsState>(
      bloc: widget.cubit,
      listener: (context, state) {
        final loadStatusState = state.loadStatusUIState;

        if (loadStatusState?.status == Status.SUCCESS) {
          widget.cubit.resetLoadStatuUpdateReset();

          // Refresh load details
          widget.cubit.getDriverLoadsById(
            loadId: widget.loadItem.data?.loadId ?? '',
          );
        } else if (loadStatusState?.status == Status.ERROR) {
          ToastMessages.error(
            message: getErrorMsg(
              errorType: loadStatusState?.errorType ?? GenericError(),
            ),
          );
          widget.cubit.resetLoadStatuUpdateReset();
        }
      },
      child: BlocConsumer<DriverLoadDetailsCubit, DriverLoadDetailsState>(
        bloc: widget.cubit,
        buildWhen: (previous, current) => current != previous,
        listener: (context, state) {},
        builder: (context, state) {
          DriverLoadDetailsModel? loadDetails;
          if (state.lpLoadById?.status == Status.LOADING) {
            return CircularProgressIndicator().center();
          }
          if (state.lpLoadById?.status == Status.ERROR) {
            return genericErrorWidget(
              error: state.loadStatusUIState?.errorType,
            );
          }
          if (state.lpLoadById?.status == Status.SUCCESS) {
            final loads = state.lpLoadById?.data;

            if (loads?.data == null) {
              return genericErrorWidget(error: NotFoundError());
            }
            loadDetails = loads;

            bool showButton(int status, bool onHold) {
              if (status == 9) return false;
              if (onHold) return false;
              return true;
            }

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
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          return getLoadDetails();
                        },
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.height,
                                if (loads!.data!.driverConsent == 0 &&
                                    loads!.data!.loadStatusId > 4)
                                  Center(
                                    child: Text(
                                      context.appText.noSimTrackingConsentFromDriver,
                                      style: AppTextStyle.textBlackColor16w400
                                          .copyWith(color: AppColors.iconRed),
                                    ),
                                  ),
                                20.height,
                                // Truck Type Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImage.png.dummyTruckLoad,
                                      width: 57,
                                      height: 42,
                                    ),
                                    12.width,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (loads!.data!.loadStatusId <
                                            LoadStatus.assigned.index) ...[
                                          Text(
                                            context.appText.requested,
                                            style: AppTextStyle.body3.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          4.height,
                                          Text(
                                            '${loads!.data!.truckType?.type ?? ''} - ${loads!.data!.truckType?.subType ?? ''}',
                                            style: AppTextStyle.body1.copyWith(
                                              fontSize: 14,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                        if (widget.loadItem.data!.loadStatusId >=
                                            LoadStatus.assigned.index) ...[
                                          5.height,
                                          Row(
                                            children: [
                                              Container(
                                                decoration:
                                                    commonContainerDecoration(
                                                      color: Color(0xffFFC100),
                                                      borderRadius:
                                                          BorderRadius.circular(4),
                                                    ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                ),
                                                child: Text(
                                                  widget
                                                          .loadItem
                                                          .data
                                                          ?.scheduleTripDetails
                                                          ?.vehicle?.vehicle?.truckNo ??
                                                      'N/A',
                                                  style: AppTextStyle.body3
                                                      .copyWith(
                                                        color: AppColors.black,
                                                      ),
                                                ),
                                              ),
                                              8.width,
                                              Text(
                                                '${loads!.data!.truckType?.type ?? ''} - ${loads!.data!.truckType?.subType ?? ''}',
                                                style: AppTextStyle.body3.copyWith(
                                                  color: AppColors.greyIconColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          5.height,
                                        ],
                                      ],
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 15),
    
                                20.height,
                                Divider(color: Color(0xffE1E1E1), thickness: 3),
                                20.height,
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
                                        coveredDistance:
                                            trackingData.covereddistance ?? '--',
                                        totalDistance:
                                            trackingData.overalldistance ?? '--',
                                        eta: trackingData.durationValue,
                                      ).paddingSymmetric(horizontal: 15);
                                    },
                                  ),
                                  20.height,
                                ],
                                DriverSourceDestinationWidget(
                                  pickUpLocation:
                                      loads!.data!.loadRoute?.pickUpLocation,
                                  dropLocation:
                                      loads!.data!.loadRoute?.dropLocation,
                                ).paddingSymmetric(horizontal: 15),
                                20.height,
                                15.height,
                                _buildLoadEntityWidget(
                                  commodities:
                                      loads?.data?.commodity?.name?.toString() ??
                                      '',
                                  weight:
                                      loads?.data?.weight?.value?.toString() ?? '',
                                  locationDistance: state.locationDistance,
                                  context: context,
                                ),
    
                                if (loads!.data!.consignees != null &&
                                    widget.loadItem.data!.consignees.isNotEmpty)
                                  _buildConsigneeDetail(
                                    context: context,
                                    email:
                                        widget
                                            .loadItem
                                            .data
                                            ?.consignees
                                            .last
                                            .email ??
                                        '',
                                    name:
                                        widget
                                            .loadItem
                                            .data
                                            ?.consignees
                                            .last
                                            .name ??
                                        '',
                                    phoneNo:
                                        widget
                                            .loadItem
                                            .data
                                            ?.consignees
                                            .last
                                            .mobileNumber ??
                                        '',
                                  ),
                                20.height,
                                if ((loads!.data!.loadStatusId ?? 0) > 4)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.loadItem.data!.loadStatusId >
                                          4) ...[
                                        20.height,
                                        Text(
                                          context.appText.tripDocument,
                                          style: AppTextStyle.h4,
                                        ).paddingSymmetric(horizontal: 15),
                                        15.height,
    
                                        buildAttachmentView(
                                          context,
                                          widget.loadItem?.data?.loadId,
                                          state,
                                          widget.cubit,
                                        ),
                                      ],
                                      20.height,
    
                                      if (widget.loadItem.data!.loadStatusId > 6)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            20.height,
                                            _buildAdableSectionHeader(
                                              showAddButton:
                                                  state.loadStatus !=
                                                      LoadStatus.completed &&
                                                  state.loadStatus !=
                                                      LoadStatus.podDispatched,
                                              context: context,
                                              title:
                                                  context.appText.damageAndShortage,
                                              onAdd: () {
                                                Navigator.push(
                                                  context,
                                                  commonRoute(
                                                    DriverDamagesAndShortagesScreen(
                                                      vehicleId:
                                                          widget
                                                              .loadItem
                                                              .data
                                                              ?.scheduleTripDetails
                                                              ?.vehicleId,
                                                      loadId: loads!.data!.loadId,
                                                      isDamageApprovedOrReject: loads.data?.loadApproval?.damageAndShortagesApproved,
                                                    ),
                                                    isForward: true,
                                                  ),
                                                ).then((value) {
                                                  if (mounted) {
                                                    getLoadDetails();
                                                  }
                                                });
                                              },
                                            ),
                                            Visibility(
                                              visible:
                                                  (loads!.data!.damageShortage ??
                                                          [])
                                                      .isNotEmpty,
                                              child: Column(
                                                children: [
                                                  20.height,
                                                  VpAddedDamageWidget(
                                                    imageList: state.allDamageImageList,
                                                    damageReport:
                                                        loads!.data!.damageShortage,
                                                  ),
                                                ],
                                              ).paddingSymmetric(horizontal: 20),
                                            ),
                                            20.height,
                                            _buildAdableSectionHeader(
                                              context: context,
                                              showAddButton:
                                                  state.loadStatus !=
                                                      LoadStatus.completed &&
                                                  loads?.data?.loadSettlement ==
                                                      null,
                                              title: context.appText.settlements,
                                              onAdd: () {
                                                Navigator.push(
                                                  context,
                                                  commonRoute(
                                                    DriverSettlementsScreen(
                                                      vehicleID:
                                                          loads!
                                                              .data!
                                                              ?.scheduleTripDetails
                                                              ?.vehicleId,
                                                      loadId: loads!.data!.loadId,
                                                    ),
                                                    isForward: true,
                                                  ),
                                                ).then((value) {
                                                  if (mounted) {
                                                    getLoadDetails();
                                                  }
                                                });
                                              },
                                            ),
                                            _submittedSettlementInfoWidget(
                                              loadDetails?.data?.loadSettlement,
                                              context,
                                            ),
                                          ],
                                        ),
                                      20.height,
                                    ],
                                  ),
                                if ((loads!.data!.loadStatusId ?? 0) > 7)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _submittedPodInfoWidget(
                                        loadDetails?.data?.podDispatch,
                                        context,
                                      ),
                                    ],
                                  ),
                                16.height,
    
                                Text(
                                  context.appText.timeLine,
                                  style: AppTextStyle.h4,
                                ).paddingSymmetric(horizontal: 15),
                                20.height,
                                DriverLoadTimelineWidget(
                                  timelineList: loads!.data!.timeline ?? [],
                                ).paddingSymmetric(horizontal: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (showButton(
                        loads!.data!.loadStatusId,
                        loads.data?.loadOnhold ?? false,
                      ))
                        BlocListener<
                          DriverLoadDetailsCubit,
                          DriverLoadDetailsState
                        >(
                          bloc: widget.cubit,
                          listener: (context, state) {
                            final loadStatusState = state.loadStatusUIState;
    
                            if (loadStatusState is Success) {
                              ToastMessages.success(
                                message: "Load status updated successfully",
                              );
                              widget.cubit.getDriverLoadsById(
                                loadId: loads!.data!.loadId ?? '',
                              );
                            }
                            if (loadStatusState is Error) {
                              ToastMessages.error(
                                message: "Failed to update load status",
                              );
                              widget.cubit.getDriverLoadsById(
                                loadId: loads!.data!.loadId ?? '',
                              );
                            }
                          },
                          child: SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: CustomSwipeButton(
                                      padding: 0,
                                      price: 0,
                                      loadId: loads.data!.loadId.toString(),
                                      enable: isChangeStatusButtonEnabled(
                                        isLpgreed:  loads.data?.isAgreed == 1,
                                        isMemoUploaded:
                                            loads.data?.loadMemo != null,
                                        loadStatus: loads.data?.loadStatusId,
                                        driverConsent:
                                            loads.data?.driverConsent ?? 0,
                                        tripDocumentList: state.tripDocumentList,
                                      ),
                                      text: DriverLoadHelper.getBottomButtonTitle(                             
                                        loads.data!.loadStatusId,
                                        loads.data?.podDispatch,
                                        loads.data?.isAgreed == 1,
                                        driverLoadDetailsCubit.state.iPodSkip,
                                      ),
                                      onSubmit: () {
                                         print("-----------------------------");
                                        // Check for sim consent and trip doc
                                        if (loads.data?.loadStatusId == 5) {
                                          final tripDocumentList =
                                              state.tripDocumentList ?? [];
                                          if (!widget.cubit.areRequiredDocsUploaded(
                                            tripDocumentList,
                                             DriverLoadHelper.getLoadStatus(
                                            widget.loadItem.data?.loadStatusId,
                                            ),
                                          )) {
                                            ToastMessages.error(
                                              message:
                                                  'Please upload Lorry Receipt, E-Way Bill, and Material Invoice',
                                            );
                                            return;
                                          }
                                        }
    
                                        // Check for POD doc
                                        if (loads.data?.loadStatusId == 7) {
                                          final tripDocumentList =
                                              state.tripDocumentList ?? [];
                                          if (!widget.cubit.isPODUploaded(
                                            tripDocumentList,
                                          )) {
                                            ToastMessages.error(
                                              message: 'Please upload POD document',
                                            );
                                            return;
                                          }
                                        }

                              if (loads.data?.loadStatusId == 8 &&
                                  state.iPodSkip != true &&
                                  loads.data?.podDispatch?.courierCompany ==
                                      null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DriverPodDispatchScreen(
                                          loadId: loads.data!.loadId ?? '',
                                        ),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    widget.cubit.getDriverLoadsById(
                                      loadId: loads.data!.loadId ?? '',
                                    );
                                  }
                                });
                                return;
                              }

                              final loadId = loads!.data!.loadId ?? '';
                              final currentStatus =
                                  loads!.data!.loadStatusId ?? 4;

                              if (currentStatus <= 8) {
                                changeLoadStatus(
                                  context,
                                  loadStatus: currentStatus + 1,
                                  loadId: loadId,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ).paddingTop(15),
              ),
            );
          }
          return genericErrorWidget(error: GenericError());
        },
      ),
    );
  }

  /// Document View Widget
  Widget buildAttachmentView(
    BuildContext context,
    String? loadId,
    DriverLoadDetailsState state,
    DriverLoadDetailsCubit cubit,
  ) {
    final tripDocumentList = state.tripDocumentList ?? [];
    return Column(
      children: List.generate(
        tripDocumentList.length,
        (index) => DriverDocumentWidgetView(
          index: index,
          driverLoadDetailsCubit: cubit,
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
}

/// Consignee Details
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
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      20.height,
      Text(context.appText.consigneeDetails, style: AppTextStyle.h4),
      20.height,
      // Contact Name
      _buildDetailWidget(text1: context.appText.name, text2: name ?? ""),

      20.height,

      // Contact Number
      _buildDetailWidget(
        text1: context.appText.contactNo,
        text2: phoneNo ?? "",
      ),
    
      // Email Id
      Visibility(
         visible: email != null && email.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             20.height,
            _buildDetailWidget(text1: context.appText.emailId, text2: email ?? ""),
          ],
        ),
      ),
    ],
  ).paddingSymmetric(horizontal: 15);
}

/// Detail Widget
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

/// Addable Section Header
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
  return Text(text, style: AppTextStyle.h4).paddingSymmetric(horizontal: 15);
}

/// Build Load Entity
Widget _buildLoadEntityWidget({
  required String commodities,
  required String weight,
  String? locationDistance,
  required BuildContext context,
}) {
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
            commodities,
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
            "${weight} Ton",
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
            "${locationDistance ?? ''}",
            style: AppTextStyle.bodyGreyColorW500.copyWith(
              color: AppColors.veryLightGreyColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ],
  ).paddingSymmetric(horizontal: 15);
}

/// Submitted settlement
Widget _submittedSettlementInfoWidget(
  DriverloadSettlement? loadSettlement,
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
              PriceHelper.formatINR(loadSettlement.unloadingCharge).toString(),
        ),
      ],
    ).paddingSymmetric(horizontal: 15),
  );
}

/// Submitted Pod
Widget _submittedPodInfoWidget(
  PodDispatchModel? loadSettlement,
  BuildContext context,
) {
  if (loadSettlement == null) {
    return SizedBox.shrink();
  }
  final courierCompany = loadSettlement.courierCompany ?? "1";
  final awbNumber = loadSettlement.awbNumber ?? "1";

  return Padding(
    padding: EdgeInsets.only(top: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonDivider(thickness: 3, height: 15),
        15.height,
        _buildHeading(text: context.appText.podDispatch),
        15.height,
        InformationView(
          title: context.appText.courierCompany,
          amount: courierCompany,
        ).paddingSymmetric(horizontal: 15),
        10.height,
        InformationView(
          title: context.appText.awbNumber,
          amount: awbNumber,
        ).paddingSymmetric(horizontal: 15),
        10.height,
        commonDivider(thickness: 3, height: 15),
      ],
    ),
  );
}
