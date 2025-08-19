import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/update_damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/view_file_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/vp_added_damage.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_count_selector.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';


class VpDamagesAndShortagesScreen extends StatefulWidget {
  final String? vehicleId;
  final String? loadId;
  const VpDamagesAndShortagesScreen({super.key, required this.vehicleId, required this.loadId});

  @override
  State<VpDamagesAndShortagesScreen> createState() => _VpDamagesAndShortagesScreenState();
}

class _VpDamagesAndShortagesScreenState extends BaseState<VpDamagesAndShortagesScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final cubit = locator<LoadDetailsCubit>();

  final String selectedFileName = "";

  List<dynamic> multiFilesList = [];
  List<String> uploadedDamageFileList = [];
  List<String> updateDamageFileList = [];

  Set<String> damageDocumentIds={};
  Set<String> updateDamageDocumentIds={};
  bool isDamageAdded=false;

 final TextEditingController itemNameTextController = TextEditingController();
 final TextEditingController quantityTextController = TextEditingController(text: '0');
 final TextEditingController descriptionTextController = TextEditingController();



  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await cubit.fetchDamageList(widget.loadId ?? "");

  });

  void disposeFunction() => frameCallback(() {
    multiFilesList.clear();
    uploadedDamageFileList.clear();
    updateDamageFileList.clear();
    itemNameTextController.clear();
    quantityTextController.clear();
    descriptionTextController.clear();
    updateDamageDocumentIds.clear();
    damageDocumentIds.clear();
    cubit.resetState();
  });


  void clearValues()=> frameCallback((){
    multiFilesList.clear();
    uploadedDamageFileList.clear();
    updateDamageFileList.clear();
    itemNameTextController.clear();
    quantityTextController.clear();
    descriptionTextController.clear();
    updateDamageDocumentIds.clear();
    damageDocumentIds.clear();
    cubit.resetUploadDamageFileUIState();
    cubit.resetSubmitDamageUIState();
    cubit.resetUpdateDamageUIState();
  });


  // Create Damage Api call
  void createDamageAndShortageApiCall() {
    if (widget.vehicleId == null && widget.loadId == null && widget.loadId!.isEmpty && widget.vehicleId!.isEmpty) {
      ToastMessages.error(message: "${context.appText.somethingWentWrong} - ${widget.vehicleId} - ${widget.loadId}");
      return;
    }
    if (formKey.currentState!.validate()) {
      if (uploadedDamageFileList.isEmpty) {
        ToastMessages.alert(message: context.appText.uploadProductPhoto);
        return;
      }
      if(int.parse(quantityTextController.text) == 0){
        ToastMessages.alert(message: context.appText.emptyQuantityValidation);
        return;
      }

      final request = DamageApiRequest(
          vehicleId: widget.vehicleId!,
          loadId: widget.loadId!,
          itemName: itemNameTextController.text,
          quantity: int.parse(quantityTextController.text),
          description: descriptionTextController.text,
          image: damageDocumentIds.toList()
      );

      cubit.createDamage(request);
      isDamageAdded=true;
    }
  }


  // Update Api call
  Future<void> updateDamageAndShortageApiCall(String damageId) async {
    if (widget.vehicleId == null && widget.loadId == null && widget.loadId!.isEmpty && widget.vehicleId!.isEmpty) {
      ToastMessages.error(message: "${context.appText.somethingWentWrong} - ${widget.vehicleId} - ${widget.loadId}");
      return;
    }
    if (formKey.currentState!.validate()) {
      if (updateDamageFileList.isEmpty) {
        ToastMessages.alert(message: context.appText.uploadProductPhoto);
        return;
      }
      if(int.parse(quantityTextController.text) == 0){
        ToastMessages.alert(message: context.appText.emptyQuantityValidation);
        return;
      }

      final apiRequest = UpdateDamageApiRequest(
        itemName: itemNameTextController.text,
        quantity: int.parse(quantityTextController.text),
        description: descriptionTextController.text,
        image: updateDamageDocumentIds.toList(),
      );
      await cubit.updateDamage(apiRequest, damageId);
    }
  }

  Future<void> callCreateDocument(UploadDamageFileModel damageFileData)async{
    final damageEntity=DocumentDataModel.damageDocumentEntity;
   final createDocumentResponse= await cubit.createDocument(damageEntity?.title??"", damageEntity?.documentTypeId??0, damageFileData);
   if(createDocumentResponse!=null){
     damageDocumentIds.add(createDocumentResponse.documentId??"");
     updateDamageDocumentIds.add(createDocumentResponse.documentId??"");
   }
  }


  // Success Damages Create Dialog
  void showSuccessDialog(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: context.appText.damageRecordedSuccessfully,
        message: context.appText.notifiedTheConcernTeam,
        onContinue: (){
          Navigator.of(context).pop(true);
          analyticsHelper.logEvent(AnalyticEventName.CREATE_DAMAGES_SUCCESSFULLY);
          cubit.fetchDamageList(widget.loadId ?? "");
        },
      ),
    );
  });



  // Confirm Delete Damage Dialog
  void confirmDeleteDamageDialog(BuildContext context, String damageId) => frameCallback(() {
    AppDialog.show(
      context,
      child: BlocBuilder<LoadDetailsCubit, LoadDetailsState>(
        bloc: cubit,
        builder: (context, state) {
          final isLoading = state.deleteDamageUIState?.status == Status.LOADING;
          final status = state.deleteDamageUIState?.status;

          return CommonDialogView(
            message: context.appText.sureToDeleteDamage,
            messageTextStyle: AppTextStyle.body2,
            hideCloseButton: true,
            showYesNoButtonButtons: true,
            yesButtonLoading: isLoading,
            onClickYesButton: () async {
              await cubit.deleteDamage(damageId);
              if (status == Status.SUCCESS) {
                cubit.resetDeleteDamageUIState();
                analyticsHelper.logEvent(AnalyticEventName.DELETE_DAMAGES);
              }
              if (status == Status.ERROR) {
                final error = state.deleteDamageUIState?.errorType;
                if (error is NotFoundError) {
                  ToastMessages.error(message: getErrorMsg(errorType: error));
                } else {
                  ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                }
              }
              if(!context.mounted) return;
              frameCallback((){
                Navigator.of(context).pop();
              });
            },
          );
        },
      )
    );
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onLeadingTap: () => Navigator.pop(context,isDamageAdded),
          title: context.appText.damagesAndShortages,
          actions: [
            BlocBuilder<LoadDetailsCubit, LoadDetailsState>(
                bloc: cubit,
                builder: (context, state) {
                  if(state.isUpdateDamage != null  && state.isUpdateDamage!){
                    return TextButton(
                      onPressed: (){
                        cubit.setIsUpdateDamage(false);
                        clearValues();
                        },
                      child: Text(context.appText.cancelEdit),
                    );
                  } else {
                    return Container();
                  }
                }
            ),
          ],
      ),
      body: _buildBodyWidget(context),
    );
  }

  /// Body
  Widget _buildBodyWidget(BuildContext context){
    return  SingleChildScrollView(
      padding: EdgeInsets.all(commonSafeAreaPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          // Damage And Shortage Form
          _buildDamageAndShortagesFormWidget(),
          10.height,

          // Damage Recorded List
          _buildDamageRecordListWidget(context),

          10.height,
        ],
      ),
    );
  }


  Widget _buildDamageAndShortagesFormWidget(){
    return Form(
      key: formKey,
      child: Column(
        children: [

          // Item Name
          AppTextField(
            mandatoryStar: true,
            validator: (value)=> Validator.fieldRequired(value),
            controller: itemNameTextController,
            labelText: context.appText.itemName,
            hintText: "LED TV 42”",
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
            ],
          ),
          10.height,

          // Quantity
          AppCountSelector(label: context.appText.quantity, controller: quantityTextController, isMandatory: true),
          10.height,

          // Upload Product Photo
          _buildUploadProductPhotoWidget(),
          _buildUpdateImageViewerListWidget(),
          20.height,

          // Description
          AppTextField(
            mandatoryStar: true,
            validator: (value)=> Validator.fieldRequired(value),
            controller: descriptionTextController,
            labelText: context.appText.description,
            hintText: context.appText.tvCrackedScreenNote,
            maxLines: 2,
            inputFormatters: [
              LengthLimitingTextInputFormatter(240),
            ],
          ),
          30.height,

          // Submit Damage Button
          BlocBuilder<LoadDetailsCubit, LoadDetailsState>(
              bloc: cubit,
              builder: (context, state) {
                if(state.isUpdateDamage != null  && state.isUpdateDamage!){
                  return _buildUpdateDamageButton();
                } else {
                  return _buildSubmitDamageButton();
                }
              }
          ),
        ],
      ),
    );
  }


  /// Upload Submit Damage Button
  Widget _buildSubmitDamageButton(){
    return BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
      bloc: cubit,
      listenWhen: (previous, current) =>  previous.createDamageUIState?.status != current.createDamageUIState?.status,
      listener: (context, state) async {
        final status = state.createDamageUIState?.status;
        if (status == Status.SUCCESS) {
          clearValues();
          showSuccessDialog(context);
        }
        if (status == Status.ERROR) {
          final error = state.createDamageUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        final isLoading = state.createDamageUIState?.status == Status.LOADING;
        return AppButton(
          title: context.appText.submit,
          isLoading: isLoading,
          onPressed: isLoading ? (){} : () => createDamageAndShortageApiCall(),
        );
      },
    );
  }


  /// Update Submit Damage Button
  Widget _buildUpdateDamageButton(){
    return BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
      bloc: cubit,
      listenWhen: (previous, current) =>  previous.updateDamageUIState?.status != current.uploadDamageUIState?.status,
      listener: (context, state) async {
        final status = state.updateDamageUIState?.status;
        if (status == Status.SUCCESS) {
          cubit.setIsUpdateDamage(false);
          clearValues();
          initFunction();
          ToastMessages.success(message: context.appText.damageUpdatesSuccessfully);
          analyticsHelper.logEvent(AnalyticEventName.UPDATE_DAMAGES);
        }
        if (status == Status.ERROR) {
          final error = state.updateDamageUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        final isLoading = state.updateDamageUIState?.status == Status.LOADING;
        return AppButton(
          title: context.appText.update,
          isLoading: isLoading,
          onPressed: isLoading ? (){} : (){
            if(state.damageId != null) {
              updateDamageAndShortageApiCall(state.damageId!);
            } else {
              ToastMessages.error(message: "Damage Id is null ${state.damageId}");
            }
          },
        );
      },
    );
  }


  /// Build Update Image viewer list
  Widget _buildUpdateImageViewerListWidget() {
    return BlocBuilder<LoadDetailsCubit, LoadDetailsState>(
        bloc: cubit,
        builder: (context, state) {
          if(state.isUpdateDamage != null  && state.isUpdateDamage!){
            return  Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: updateDamageFileList.length,
                  itemBuilder: (context, index) {
                    return  Stack(
                      children: [
                        commonCacheNetworkImage(
                          height: 120,
                          width: double.infinity,
                          path: updateDamageFileList[index],
                          errorImage: Icons.image_not_supported,
                        ),

                        AppIconButton(
                            onPressed: (){
                              updateDamageFileList.removeAt(index);
                              updateDamageDocumentIds.toList().removeAt(index);
                              setState(() {});
                            },
                            style: AppButtonStyle.circularIconButtonStyle,
                            icon: Icon(CupertinoIcons.clear, color: Colors.red, size: 20),
                        ).align(Alignment.topRight)
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => 15.height,
                ),
                20.height,
              ],
            );
          } else {
            return Container();
          }
        }
    );
  }


  /// Upload Product Photo
  Widget _buildUploadProductPhotoWidget(){
    return  BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
      bloc: cubit,
      listenWhen: (previous, current) =>  previous.uploadDamageUIState?.status != current.uploadDamageUIState?.status,
      listener: (context, state) {
        final status = state.uploadDamageUIState?.status;

        if (status == Status.SUCCESS) {
          if (state.uploadDamageUIState?.data != null &&  state.uploadDamageUIState!.data!.url.isNotEmpty){
            uploadedDamageFileList.add(state.uploadDamageUIState!.data!.url);
            updateDamageFileList.add(state.uploadDamageUIState!.data!.url);
            CustomLog.debug(this, "File List : ${uploadedDamageFileList.length}");
            callCreateDocument(state.uploadDamageUIState!.data!);
            cubit.resetUploadDamageFileUIState();
          }
        }

        if (status == Status.ERROR) {
          final error = state.uploadDamageUIState?.errorType;
          multiFilesList.clear();
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
        },
      builder: (context, state) {
        final isLoading = state.uploadDamageUIState?.status == Status.LOADING;
        return UploadAttachmentFiles(
          isdocSupportWithoutPdf: false,
          title: context.appText.productPhoto,
          multiFilesList: multiFilesList,
          isMultipleSelectionFile: false,
          isSingleFile: false,
          isLoading: isLoading,
          thenUploadFileToSever: ()  {
            if (multiFilesList.isNotEmpty) {
              cubit.uploadDamageFile(File(multiFilesList.length > 1 ? multiFilesList.last['path'] : multiFilesList.first['path']));
            } else {
              uploadedDamageFileList.clear();
              damageDocumentIds.clear();
            }
          },
          onDelete: (index) {
            uploadedDamageFileList.removeAt(index);
            damageDocumentIds.toList().removeAt(index);
          }
        );
      },
    );
  }


  Widget _buildDamageRecordListWidget(BuildContext context){
    return BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
      bloc: cubit,
      listenWhen: (previous, current) =>  previous.damageListUIState?.status != current.damageListUIState?.status || previous.allDamageImageList?.length!=current.allDamageImageList?.length,
      listener: (context, state) {
        final status = state.damageListUIState?.status;

        if (status == Status.ERROR) {
          final error = state.damageListUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }

      },
      builder: (context, state) {
        if(state.damageListUIState?.data != null && state.damageListUIState!.data!.data.isNotEmpty) {
          final imageList=state.allDamageImageList;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.appText.damagesRecorded, style: AppTextStyle.body1BlackColor),
              20.height,
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.damageListUIState!.data!.data.length,
                itemBuilder: (context, index) {
                  final data = state.damageListUIState!.data!.data[index];
                  return damageRecordCard(
                    context: context,
                    imageIds: data.image,
                    imageUrl: imageList?[index]??"",
                    itemName: data.itemName??"",
                    quantity:  data.quantity.toString(),
                    description:  data.description??"",
                    onDelete: () async {
                      await cubit.deleteDamage(data.damageId??"");
                      final status = state.deleteDamageUIState?.status;
                      if (status == Status.SUCCESS) {
                        cubit.resetDeleteDamageUIState();
                        ToastMessages.success(message:context.appText.damageDeletedSuccessfully);
                      }
                      if (status == Status.ERROR) {
                        final error = state.deleteDamageUIState?.errorType;
                        if (error is NotFoundError) {
                          ToastMessages.error(message: getErrorMsg(errorType: error));
                        } else {
                          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                        }
                      }
                      initFunction();
                    },
                    onEdit: () {
                      itemNameTextController.text = data.itemName??"";
                      quantityTextController.text = data.quantity.toString();
                      descriptionTextController.text = data.description??"";
                      updateDamageFileList = data.image??[];
                      cubit.setIsUpdateDamage(true);
                      cubit.setDamageId(data.damageId??"");
                      setState(() {});
                    }
                  );
                },
                separatorBuilder: (context, index) => 15.height,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  detailWidget({required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: AppTextStyle.textGreyDetailColor14w400),
        Text(text2, style: AppTextStyle.textGreyDetailColor14w400),
      ],
    );
  }

// Damages record card
  Widget damageRecordCard({
    required BuildContext context,
    required String imageUrl,
    required String itemName,
    required String quantity,
    required String description,
     List<String>? imageIds,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.extraLightBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 110,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          // Left-side Image with only left corners rounded
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 110,
              height: double.infinity,
              child: commonCacheNetworkImage(
                  path: imageUrl,
                  errorImage: Icons.image_not_supported,
                  radius: 0
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(itemName, style: AppTextStyle.body2),
                  5.height,
                  Text("${context.appText.quantity}: $quantity", style: AppTextStyle.body4GreyColor),
                   ExpandableText(
                    text: description,
                    style: AppTextStyle.body4GreyColor,
                  ),
                  5.height,
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(createRoute(ViewFileWidget(image: imageIds??[])));
                    },
                    child: Text(context.appText.viewFiles, style: AppTextStyle.body3PrimaryColor),
                  ),
                ],
              ),
            ),
          ),

          // Delete button
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconButton(
                onPressed: onDelete,
                icon: AppIcons.svg.delete,
                iconColor: AppColors.activeRedColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


