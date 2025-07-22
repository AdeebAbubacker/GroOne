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
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_damages_list_view.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_document_widget_view.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_load_timeline_widget.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/widget/driver_source_destination_widget.dart';
import 'package:gro_one_app/features/driver/driver_settlements/view/driver_settlements_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/trip_documents.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/vp_damages_and_shortages_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/added_damage_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/document_widget_view.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/view/vp_pod_dispatch_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';
import '../../../../../data/ui_state/status.dart';
import '../../../../load_provider/lp_home/helper/lp_home_helper.dart';

class DriverLoadBottomWidget extends StatefulWidget {
  final DriverLoadDetailsCubit cubit;
  final DriverLoadDetailsModel loadItem;
  final String kilometers;
  const DriverLoadBottomWidget({
    super.key,
    required this.loadItem,
    required this.kilometers,
    required this.cubit,
  });

  @override
  State<DriverLoadBottomWidget> createState() => _DriverLoadBottomWidgetState();
}

class _DriverLoadBottomWidgetState extends State<DriverLoadBottomWidget> {
  List<dynamic> lorryReceiptFiles = [];
  List<String> uploadedLorryReceipts = [];

  List<dynamic> eWayBillFiles = [];
  List<String> uploadedEWayBills = [];

  List<dynamic> materialInvoiceFiles = [];
  List<String> uploadedMaterialInvoices = [];
  final loadDetailsCubit = locator<LoadDetailsCubit>();

 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverLoadDetailsCubit, DriverLoadDetailsState>(
       buildWhen: (previous, current) => current!=previous,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
         DriverLoadDetailsModel? loadDetails;
        if (state.lpLoadById?.status == Status.LOADING) {
          return CircularProgressIndicator().center();
        }
        if (state.lpLoadById?.status == Status.ERROR) {
          return genericErrorWidget(
              error: state.loadStatusUIState?.errorType);
        }
        if (state.lpLoadById?.status == Status.SUCCESS) {
          final loads = state.lpLoadById?.data;

          if (loads?.data == null) {
            return genericErrorWidget(error: NotFoundError());
          }
          loadDetails= loads;
     
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            decoration: commonContainerDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   
                      // Truck Type Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.png.truck,
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
                                      decoration: commonContainerDecoration(
                                        color: Color(0xffFFC100),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        widget
                                                .loadItem
                                                .data
                                                ?.driverTrackingModel
                                                ?.truckNumber ??
                                            'TN AY 3467',
                                        style: AppTextStyle.body3.copyWith(
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
                      ),

                      20.height,
                     
                      DriverSourceDestinationWidget(
                        pickUpLocation:
                            loads!.data!.loadRoute?.pickUpLocation,
                        dropLocation:
                            loads!.data!.loadRoute?.dropLocation,
                      ),
                      20.height,
                      15.height,
                      _buildLoadEntityWidget(
                        commodities:
                            loads!.data!.commodity!.name.toString() ??
                            '',
                        weight:
                            loads!.data!.weight!.value.toString() ??
                            '',
                      ),
                      if ((loads!.data!.loadStatusId ?? 0) > 4)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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

                            
                            if (widget.loadItem.data!.loadStatusId > 4) ...[
                              20.height,
                              Text('Trip Documents', style: AppTextStyle.h4),
                              10.height,

                              buildAttachmentView(
                              context,
                              widget.loadItem?.data?.loadId,state,
                              widget.cubit,
                            ),
                             ],
                            20.height,

                       
                            if (widget.loadItem.data!.loadStatusId > 5)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  20.height,
                                  _buildAdableSectionHeader(
                                    showAddButton: true,
                                    context: context,
                                    title: 'Damages and Shortages',
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
                                            loadId:
                                                loads!.data!.loadId,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                   Visibility(
                                  visible:(loads!.data!.damageShortage??[]).isNotEmpty,
                                  child: Column(
                                    children: [
                                      20.height,
                                      AddedDamageWidget(
                                        damageReport: loads!.data!.damageShortage,
                                      ),
                                    ],
                                  )),
                                  20.height,
                                  _buildAdableSectionHeader(
                                    context: context,
                                    showAddButton: true,
                                    title: 'Settlements',
                                    onAdd: () {
                                      Navigator.push(
                                        context,
                                        commonRoute(
                                          DriverSettlementsScreen(
                                            vehicleID:
                                                loads!.data!
                                                    ?.scheduleTripDetails
                                                    ?.vehicleId,
                                            loadId:
                                                  loads!.data!.loadId,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            20.height,
                            Text("Timeline", style: AppTextStyle.h4),
                            20.height,
                            DriverLoadTimelineWidget(
                              timelineList:
                                  loads!.data!.timeline ?? [],
                            ),
                          ],
                        ),
                      if (  loads!.data!.loadStatusId != 8)
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
                              widget.cubit.getLpLoadsById(
                                loadId:   loads!.data!.loadId ?? '',
                              );
                            }
                                if (loadStatusState is Error) {
                                  ToastMessages.success(
                                    message: "Failed to update load status",
                                  );
                                  widget.cubit.getLpLoadsById(
                                    loadId:   loads!.data!.loadId ?? '',
                                  );
                                }
                              },
                              child: DriverLoadHelper.loadStatusButtonWidget(
                                statusId:   loads!.data!.loadStatusId ?? 4,
                                onPressed: () {


                                if (  loads!.data!.driverConsent == 0) {
                                  ToastMessages.error(message: "Cannot Update Status, SIM consent not given");
                                  return;
                                }
                                if (  loads!.data!.loadStatusId == 4 &&   loads!.data!.driverConsent == 0) {
                                  ToastMessages.error(message: "Cannot Update Status, SIM consent not given");
                                  return;
                                }
                                final List<List<LoadDocument>> nestedDocuments =   loads!.data!.loadDocument ?? [];
                                final allDocuments = nestedDocuments.expand((docList) => docList).toList();
                                bool hasLorryReceipt = allDocuments.any(
                                              (doc) => doc.documentDetails?.documentType == 'LORRY_RECEIPT',
                                            );
                                            bool hasEWayBill = allDocuments.any(
                                              (doc) => doc.documentDetails?.documentType == 'E_WAY_BILL',
                                            );
                                            bool hasMaterialInvoice = allDocuments.any(
                                              (doc) => doc.documentDetails?.documentType == 'MATERIAL_INVOICE',
                                            );

                                            // Add your condition to validate all documents are uploaded
                                            if (  loads!.data!.loadStatusId == 5 && !hasLorryReceipt || !hasEWayBill || !hasMaterialInvoice) {
                                              ToastMessages.error(
                                                message: "Please upload all required Trip Documents: Lorry Receipt, E-Way Bill, and Material Invoice.",
                                              );
                                              return;
                                            }        
                            
                              final customerId =
                                    loads!.data!.customer?.customerId ??
                                  '';
                              final loadId =   loads!.data!.loadId ?? '';
                              final currentStatus =
                                    loads!.data!.loadStatusId ?? 4;

                              if (currentStatus <= 7) {
                                widget.cubit.fupdateLoadStatus(
                                  customerId: customerId,
                                  loadid: loadId,
                                  loadStatus: currentStatus + 1,
                                );
                              }
                            },
                          ).paddingOnly(top: 5),
                        ),
                    ],
                  ).paddingAll(16),
                ).expand(),
              ],
            ),
          ),
        );
    
    
        } return genericErrorWidget(error: GenericError());
          },
    );
  }

  Widget buildUploadDocumentWidget({
    required String title,
    required List<dynamic> fileList,
    required List<String> uploadedFileList,
    required void Function(String path) uploadCallback,
    required void Function(int index) onDelete,
    required DriverLoadDetailsCubit cubit,
  }) {
    return BlocConsumer<DriverLoadDetailsCubit, DriverLoadDetailsState>(
      bloc: cubit,
      listenWhen:
          (previous, current) =>
              previous.uploadDamageUIState?.status !=
              current.uploadDamageUIState?.status,
      listener: (context, state) {
        final status = state.uploadDamageUIState?.status;
        if (status == Status.SUCCESS) {
          final url = state.uploadDamageUIState?.data?.url;
          if (url != null && url.isNotEmpty) {
            setState(() {
              uploadedFileList.add(url);
            });
          }
        }
        if (status == Status.ERROR) {
          final error = state.uploadDamageUIState?.errorType;
          fileList.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading: ${error.runtimeType}")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.uploadDamageUIState?.status == Status.LOADING;
        return UploadAttachmentFiles(
          title: title,
          multiFilesList: fileList,
          isMultipleSelectionFile: false,
          isSingleFile: false,
          isLoading: isLoading,
          thenUploadFileToSever: () {
            if (fileList.isNotEmpty) {
              final selected = fileList.last['path'];
              uploadCallback(selected);
            }
          },
          onDelete: onDelete,
        );
      },
    );
  }

 Widget buildAttachmentView(BuildContext context,String? loadId,DriverLoadDetailsState state, DriverLoadDetailsCubit cubit){

    final tripDocumentList=state.tripDocumentList??[];
    return Column(
        children: List.generate(tripDocumentList.length, (index) => DriverDocumentWidgetView(
       index: index,
       driverLoadDetailsCubit: cubit,
     hintText: tripDocumentList[index].title,
     documentEntity:tripDocumentList[index],
     onGetFile: (p0) {
       cubit.uploadDocument(File(p0),tripDocumentList[index].fileType??"",
           tripDocumentList[index].title,
           tripDocumentList[index].documentTypeId,
           loadId??"",
           index
       );
     },
   )));
  }

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
      20.height,

      // Email Id
      _buildDetailWidget(text1: context.appText.emailId, text2: email ?? ""),
    ],
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
  return Text(text, style: AppTextStyle.h4);
}

// Build Load Entity
Widget _buildLoadEntityWidget({
  required String commodities,
  required String weight,
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
            "23 KM",
            style: AppTextStyle.bodyGreyColorW500.copyWith(
              color: AppColors.veryLightGreyColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ],
  );
}

// From Vp Side
Widget _buildBottomButtonWidget(BuildContext context) {
  return Container(
    decoration: commonContainerDecoration(color: Colors.white, blurRadius: 30),
    child: Row(
      spacing: 10,
      children: [
        ...[
          //   AppButton(
          //     title: "Support",
          //    style: AppButtonStyle.outline.copyWith(
          //      shape: WidgetStatePropertyAll(
          //        RoundedRectangleBorder(
          //          borderRadius: BorderRadius.circular(8),
          //        ),
          //      ),
          //    ),
          //    onPressed: () {
          //      commonSupportDialog(context);
          //    },
          //    textStyle: TextStyle(fontSize: 14),
          //  ).expand(),
          AppButton(
            title: "View Trip Settlement",

            style: AppButtonStyle.primary.copyWith(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            onPressed: () async {},
            textStyle: TextStyle(fontSize: 14, color: AppColors.white),
          ).expand(),

          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.90,
            child: CustomSwipeButton(
              padding: 0,
              price: 0,
              loadId: "",

              text: "Matching",
              onSubmit: () {},
            ),
          ),
        ],
      ],
    ),
  );
}
