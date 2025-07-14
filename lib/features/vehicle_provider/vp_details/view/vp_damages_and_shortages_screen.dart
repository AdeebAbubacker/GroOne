import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/view_file_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
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

class _VpDamagesAndShortagesScreenState extends State<VpDamagesAndShortagesScreen> {

  final cubit = locator<LoadDetailsCubit>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final String selectedFileName = "";

  List<dynamic> multiFilesList = [];
  List<String> uploadedDamageFileList = [];

 final TextEditingController itemNameTextController = TextEditingController();
 final TextEditingController quantityTextController = TextEditingController();
 final TextEditingController descriptionTextController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
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
    cubit.fetchDamageList(widget.loadId ?? "");
  });

  void disposeFunction() => frameCallback(() {
    multiFilesList.clear();
    uploadedDamageFileList.clear();
    itemNameTextController.clear();
    quantityTextController.clear();
    descriptionTextController.clear();
    cubit.resetState();
    cubit.resetUploadDamageFileUIState();
    cubit.resetSubmitDamageUIState();
  });


  void clearValues()=> frameCallback((){
    multiFilesList.clear();
    uploadedDamageFileList.clear();
    itemNameTextController.clear();
    quantityTextController.clear();
    descriptionTextController.clear();
    cubit.resetUploadDamageFileUIState();
    cubit.resetSubmitDamageUIState();
  });


  // Vp Creation Api call
  void createDamageAndShortageApiCall() {
    if (widget.vehicleId == null && widget.loadId == null && widget.loadId!.isEmpty && widget.vehicleId!.isEmpty) {
      ToastMessages.error(message: "Something went wrong - ${widget.vehicleId} - ${widget.loadId}");
      return;
    }
    if (formKey.currentState!.validate()) {
      if (uploadedDamageFileList.isEmpty) {
        ToastMessages.alert(message: "Please upload Product Photo");
        return;
      }
      if(int.parse(quantityTextController.text) == 0){
        ToastMessages.alert(message: "You can't add 0 quantity");
        return;
      }

      final request = DamageApiRequest(
          vehicleId: widget.vehicleId!,
          loadId: widget.loadId!,
          itemName: itemNameTextController.text,
          quantity: int.parse(quantityTextController.text),
          description: descriptionTextController.text,
          image: uploadedDamageFileList

      );
      cubit.createDamage(request);
    }
  }


  void showSuccessDialog(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: "Your damage has been recorded.",
        message: "We have notified the concerned team.",
        onContinue: (){
          Navigator.of(context).pop(true);
          cubit.fetchDamageList(widget.loadId ?? "");
        },
      ),
    );
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.damagesAndShortages),
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
            validator: (value)=> Validator.fieldRequired(value),
            controller: itemNameTextController,
            labelText: context.appText.itemName,
            hintText: "LED TV 42”",
          ),
          20.height,

          // Quantity
          AppTextField(
            validator: (value)=> Validator.fieldRequired(value),
            controller: quantityTextController,
            labelText: context.appText.quantity,
            hintText: "2",
            keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          20.height,

          // Upload Product Photo
          _buildUploadProductPhotoWidget(),
          20.height,

          // Description
          AppTextField(
            validator: (value)=> Validator.fieldRequired(value),
            controller: descriptionTextController,
            labelText: context.appText.description,
            hintText: context.appText.tvCrackedScreenNote,
            maxLines: 2,
          ),
          30.height,

          // Submit Damage Button
          BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
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
          )
        ],
      ),
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
            CustomLog.debug(this, "File List : $uploadedDamageFileList");
            cubit.resetUploadDamageFileUIState();
            ToastMessages.success(message: "File uploaded successfully");
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
        debugPrint("Multi File List : ${multiFilesList.length}");
        debugPrint("Upload Damage File List : ${uploadedDamageFileList.length}");
        return UploadAttachmentFiles(
          title: "Product Photo",
          multiFilesList: multiFilesList,
          isMultipleSelectionFile: false,
          isSingleFile: false,
          isLoading: isLoading,
          thenUploadFileToSever: ()  {
            if (multiFilesList.isNotEmpty) {
              cubit.uploadDamageFile(File(multiFilesList.length > 1 ? multiFilesList.last['path'] : multiFilesList.first['path']));
            } else {
              uploadedDamageFileList.clear();
            }
          },
          onDelete: (index) {
            uploadedDamageFileList.removeAt(index);
          }
        );
      },
    );
  }


  Widget _buildDamageRecordListWidget(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.damagesRecorded, style: AppTextStyle.body1BlackColor),
        20.height,

        BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
          bloc: cubit,
          listenWhen: (previous, current) =>  previous.damageListUIState?.status != current.damageListUIState?.status,
          listener: (context, state) {
            final status = state.damageListUIState?.status;

            if (status == Status.ERROR) {
              final error = state.damageListUIState?.errorType;
              ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
            }

          },
          builder: (context, state) {
            if(state.damageListUIState?.data != null && state.damageListUIState!.data!.data.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.damageListUIState!.data!.data.length,
                itemBuilder: (context, index) {
                  final data = state.damageListUIState!.data!.data[index];
                  return damageRecordCard(
                    context: context,
                    imageUrl: data.image,
                    itemName: data.itemName,
                    quantity:  data.quantity.toString(),
                    description:  data.description,
                    onDelete: () {
                      debugPrint("Deleted item at index $index");
                    },
                    onEdit: () {

                    }
                  );
                },
                separatorBuilder: (context, index) => 15.height,
              );
            }
            return Container();
          },
        ),
      ],
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
    required List<String> imageUrl,
    required String itemName,
    required String quantity,
    required String description,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    bool? showDeleteIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.extraLightBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 110,
      child: Row(
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
                  path: imageUrl.first,
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
                  Text(description, style: AppTextStyle.body4GreyColor),
                  5.height,
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(createRoute(ViewFileWidget(image: imageUrl)));
                    },
                    child: Text("View Files", style: AppTextStyle.body3PrimaryColor),
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
                onPressed: onEdit,
                icon: AppIcons.svg.edit,
                iconColor: AppColors.primaryColor,
              ),

    Visibility(
    visible: showDeleteIcon??true
                child: AppIconButton(
                  onPressed: onDelete,
                  icon: AppIcons.svg.delete,
                  iconColor: AppColors.activeRedColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


