import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/upload_rc_truck_file/upload_rc_truck_file_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:multi_dropdown/multi_dropdown.dart';


class VpCreationFormScreen extends StatefulWidget {
  final String id;
  final String mobileNumber;
  const VpCreationFormScreen({super.key,required this.id, required this.mobileNumber});

  @override
  State<VpCreationFormScreen> createState() => _VpCreationFormScreenState();
}

class _VpCreationFormScreenState extends State<VpCreationFormScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final vpCreationBloc = locator<VpCreationBloc>();
  final uploadRcTruckFileBloc = locator<UploadRcTruckFileBloc>();
  final loadTruckTypeBloc = locator<LoadTruckTypeBloc>();

  final nameTextController = TextEditingController();
  final mobileNumberTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final ownedTruckTextController = TextEditingController();
  final attachedTruckTextController = TextEditingController();
  final pinCodeTextController = TextEditingController();

  final MultiSelectController<String> truckTypeController = MultiSelectController<String>();
  final MultiSelectController<String>  preferredLanesTypeController = MultiSelectController<String>();

  String? preferredLanesDropDownValue;
  String? truckTypeDropDownValue;
  String? uploadedRcFile;


  List<dynamic> multiFilesList = [];
  List<String> selectedTruckTypeList = [];
  final List<DropdownItem<String>> preferredLanesList = [
    DropdownItem(label: 'Chennai - Mumbai', value: '1'),
    DropdownItem(label: 'Chennai -  Pune', value: '2'),
    DropdownItem(label: 'Chennai - Delhi', value: '3'),
    DropdownItem(label: 'Mumbai - Pune', value: '4'),
    DropdownItem(label: 'Chennai - Bangalore', value: '5'),
  ];
  List<String> getUniqueTypes(List<TruckTypeData> dataList) {
    return dataList.map((e) => e.type).toSet().toList();
  }


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

  void initFunction() => addPostFrameCallback(() {
    mobileNumberTextController.text=widget.mobileNumber;
    loadTruckTypeBloc.add(LoadTruckType());
    vpCreationBloc.add(GetTruckTypeEvent());
  });

  void disposeFunction() => addPostFrameCallback(() {
    nameTextController.dispose();
    mobileNumberTextController.dispose();
    companyNameTextController.dispose();
    ownedTruckTextController.dispose();
    attachedTruckTextController.dispose();
    pinCodeTextController.dispose();
    truckTypeController.dispose();
    truckTypeController.dispose();
    preferredLanesDropDownValue = null;
    uploadedRcFile = null;
    multiFilesList.clear();
    preferredLanesList.clear();
    vpCreationBloc.add(VpResetEvent());
    uploadRcTruckFileBloc.add(ResetUploadRcDocumentEvent());
  });


  // Vp Creation Api call
  void vpCreationApiCall(){
    if (formKey.currentState!.validate()){
      if(uploadedRcFile == null){
        return;
      }
      final request = VpCreationApiRequest(
        customerName: nameTextController.text,
        mobileNumber: mobileNumberTextController.text,
        companyName: companyNameTextController.text,
        truckType: truckTypeDropDownValue,
        ownedTrucks: ownedTruckTextController.text,
        attachedTrucks: attachedTruckTextController.text,
        preferredLanes: preferredLanesDropDownValue,
        uploadRc: uploadedRcFile,
      );
      vpCreationBloc.add(VpCreationRequested(apiRequest: request, id: widget.id));
    }
  }


  // Navigate to home screen
  void navigateToHomeScreen(BuildContext context) => addPostFrameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.accountCreatedSuccessfully,
        heading: context.appText.accountCreatedSuccessfullySubHeading,
        afterDismiss: (){
          context.go(AppRouteName.vpBottomNavigationBar);
          disposeFunction();
        },
      ),
    );
  });



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.createAccount, scrolledUnderElevation: 0.0, backgroundColor: Colors.transparent),
      body: SafeArea(
        bottom: false,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildNameAndPhoneNumberWidget(),
              30.height,
              buildBusinessDetailsWidget(context),
              30.height,
              buildBusinessProofWidget(),
              50.height,
            ],
          ).withScroll(padding: EdgeInsets.all(commonSafeAreaPadding)),
        ),
      ),
      bottomNavigationBar: buildSubmitButton(),
    );
  }

  /// Name and Phone Number
  Widget buildNameAndPhoneNumberWidget(){
    return Column(
      children: [
        // Name
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: nameTextController,
          labelText: context.appText.name,
          hintText: "${context.appText.enter} ${context.appText.name}",
        ),
        20.height,

        // Phone Number
        AppTextField(
          readOnly: true,


          validator: (value)=> Validator.phone(value),
          controller: mobileNumberTextController,
          labelText: context.appText.phoneNumber,
          maxLength: 10,
          inputFormatters: [phoneNumberInputFormatter],
          keyboardType: TextInputType.phone,
          decoration: commonInputDecoration(
            hintText: "${context.appText.enter} ${context.appText.phoneNumber}",
            prefixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImage.png.flag),
                10.width,
                Text("+91", style: AppTextStyle.textBlackColor16w400),
              ],
            ).paddingOnly(left: 20, right: 5),
          ),
        ),
        20.height,

        // Pin code Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: pinCodeTextController,
          labelText: context.appText.pinCode,
          hintText: "${context.appText.enter} ${context.appText.pinCode}",
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }


  /// Business Details
  Widget buildBusinessDetailsWidget(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.businessName, style: AppTextStyle.body1PrimaryColor),
        20.height,

        // Company Name
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: companyNameTextController,
          labelText: context.appText.companyName,
          hintText: "${context.appText.enter} ${context.appText.companyName}",
        ),
        20.height,

        // TrucK Type
        BlocListener<VpCreationBloc, VpCreationState>(
          bloc: vpCreationBloc,
          listener: (context, state) {
            if (state is TruckTypeError) {
              ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
            }
          },
          child: BlocBuilder<VpCreationBloc, VpCreationState>(
            bloc: vpCreationBloc,
            builder: (context, state) {
              if (state is TruckTypeSuccess) {
                return AppMultiSelectionDropdown<String>(
                  labelText: context.appText.truckType,
                  hintText: context.appText.selectTruckType,
                  controller: truckTypeController,
                  items: state.truckTypeModel.data.map((e) => DropdownItem<String>(
                    value: e, // or e.id
                    label: e,
                  )).toList(),
                  onSelectionChange: (selected) {
                    if (selected.isNotEmpty) {
                      selectedTruckTypeList = selected.toSet().toList();
                      truckTypeDropDownValue = selected.first;
                    } else {
                      truckTypeDropDownValue = null;
                      selectedTruckTypeList.clear();
                    }
                    CustomLog.debug(this, 'Selected truck type: $selectedTruckTypeList');
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "${context.appText.truckType} ${context.appText.pinCode}";
                    }
                    return null;
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),


        20.height,

        // Owned Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: ownedTruckTextController,
          labelText: context.appText.ownedTrucks,
          hintText: "${context.appText.enter} ${context.appText.ownedTrucks}",
          keyboardType: TextInputType.number,
        ),
        20.height,

        // Attached Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: attachedTruckTextController,
          labelText: context.appText.attachedTrucks,
          hintText: "${context.appText.enter} ${context.appText.attachedTrucks}",
          keyboardType: TextInputType.number,
        ),
        20.height,

        // Preferred Lane
        AppMultiSelectionDropdown<String>(
          labelText: context.appText.preferredLanes,
          hintText: context.appText.selectLaneType,
          controller: preferredLanesTypeController,
          items: preferredLanesList,
          onSelectionChange: (selected) {
            CustomLog.debug(this, 'Selected lane: $selected');
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${context.appText.truckType} ${context.appText.pinCode}";
            }
            return null;
          },
        ),
      ],
    );
  }


  /// Business Proof
  Widget buildBusinessProofWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.businessProof, style: AppTextStyle.body1PrimaryColor),
        20.height,

        // Upload Rc Truck Document
        BlocConsumer<UploadRcTruckFileBloc, UploadRcTruckFileState>(
          bloc: uploadRcTruckFileBloc,
          listener: (context, state) {
            if (state is UploadRcTruckFileSuccess) {
              ToastMessages.success(message: "File uploaded successfully");
            } else if (state is UploadRcTruckFileError) {
              ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
            }
          },
          builder: (BuildContext context, UploadRcTruckFileState state) {
            return UploadAttachmentFiles(
              multiFilesList: multiFilesList,
              title: context.appText.uploadRC,
              isSingleFile: true,
              isLoading: state is UploadRcTruckFileLoading,
              thenUploadFileToSever: ()  {
                if (multiFilesList.isNotEmpty) {
                  uploadRcTruckFileBloc.add(UploadRcTruckFileRequested(file: File(multiFilesList.first['path'])));
                  if (state is UploadRcTruckFileSuccess) {
                    if (state.fileModel.data != null && state.fileModel.data!.url.isNotEmpty){
                      uploadedRcFile = state.fileModel.data!.url;
                      uploadRcTruckFileBloc.add(ResetUploadRcDocumentEvent());
                    } else {
                      multiFilesList.clear();
                    }
                  }
                  if(state is UploadRcTruckFileError){
                    multiFilesList.clear();
                    uploadedRcFile = null;
                    ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
                  }
                }
              },
            );
          },
        ),

      ],
    );
  }


  /// Submit Button
  Widget buildSubmitButton() {
    return BlocConsumer<VpCreationBloc, VpCreationState>(
      bloc: vpCreationBloc,
      listener: (context, state) async {
        if (state is VpCreationSuccess) {
          navigateToHomeScreen(context);
        } else if (state is VpCreationError) {
          vpCreationBloc.add(VpResetEvent());
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      builder: (context, state) {
        final isLoading = state is VpCreationLoading;
        return AppButton(
          title: context.appText.submit,
          isLoading: isLoading,
          onPressed: isLoading ? (){} : () => vpCreationApiCall(),
        );
      },
    ).bottomNavigationPadding();
  }


}
