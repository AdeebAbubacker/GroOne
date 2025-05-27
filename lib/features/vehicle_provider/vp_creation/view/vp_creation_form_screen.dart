import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/upload_rc_truck_file/upload_rc_truck_file_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:multi_dropdown/multi_dropdown.dart';


class VpCreationFormScreen extends StatefulWidget {
  final String id;
  const VpCreationFormScreen({super.key,required this.id});

  @override
  State<VpCreationFormScreen> createState() => _VpCreationFormScreenState();
}

class _VpCreationFormScreenState extends State<VpCreationFormScreen> {

  final vpCreationBloc = locator<VpCreationBloc>();
  final uploadRcTruckFileBloc = locator<UploadRcTruckFileBloc>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final mobileNumberTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final ownedTruckTextController = TextEditingController();
  final attachedTruckTextController = TextEditingController();
  final pinCodeTextController = TextEditingController();

  final MultiSelectController<String> truckTypeController = MultiSelectController<String>();
  final MultiSelectController<String>  preferredLanesTypeController = MultiSelectController<String>();


  String? truckTypeDropDownValue;
  String? preferredLanesDropDownValue;
  String? uploadedRcFile;


  List<dynamic> multiFilesList = [];

  final List<DropdownItem<String>> truckTypeItems = [
    DropdownItem(label: 'Open Truck', value: 'Open Truck'),
    DropdownItem(label: 'Close Truck', value: 'Close Truck'),
  ];

  final List<DropdownItem<String>> preferredLanesList = [
    DropdownItem(label: 'Chennai - Mumbai', value: '1'),
    DropdownItem(label: 'Chennai -  Pune', value: '2'),
    DropdownItem(label: 'Chennai - Delhi', value: '3'),
    DropdownItem(label: 'Mumbai - Pune', value: '4'),
    DropdownItem(label: 'Mumbai - Bangalore', value: '5'),
  ];


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
    CustomLog.debug(this, ApiUrls.baseUrl);
    CustomLog.debug(this, ApiUrls.createLpAccount);
    CustomLog.debug(this, ApiUrls.createVpAccount);
  });

  void disposeFunction() => addPostFrameCallback(() {

  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.createAccount),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildNameAndPhoneNumberWidget(),
              30.height,
          
              buildBusinessDetailsWidget(context),
              30.height,
          
              buildBusinessProofWidget(),
              30.height,
          
              buildSubmitButton()
            ],
          ).withScroll(padding: EdgeInsets.all(commonSafeAreaPadding)),
        ),
      ),
    );
  }

  // Name and Phone Number
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

  // Business Details
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
        AppMultiSelectionDropdown<String>(
          labelText: context.appText.truckType,
          hintText: context.appText.selectTruckType,
          controller: truckTypeController,
          items: truckTypeItems,
          onSelectionChange: (selected) {
            CustomLog.debug(this, 'Selected Trucks: $selected');
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${context.appText.truckType} ${context.appText.pinCode}";
            }
            return null;
          },
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
              thenUploadFileToSever: ()  {
                if (multiFilesList.isNotEmpty) {
                  uploadRcTruckFileBloc.add(UploadRcTruckFileRequested(file: File(multiFilesList.first['path'])));
                  if (state is UploadRcTruckFileSuccess) {
                    if (state.fileModel.data != null && state.fileModel.data!.url.isNotEmpty){
                      uploadedRcFile = state.fileModel.data!.url;
                    } else {
                      multiFilesList.clear();
                    }
                  }
                  if(state is UploadRcTruckFileError){
                    multiFilesList.clear();
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

  // Submit Button
  Widget buildSubmitButton() {
    return BlocConsumer<VpCreationBloc, VpCreationState>(
      bloc: vpCreationBloc,
      listener: (context, state) {
        if (state is VpCreationSuccess) {
          addPostFrameCallback(() {
            showSuccessDialog(
              onTap: () {
                addPostFrameCallback(() => context.go(AppRouteName.vpBottomNavigationBar));
              },
              context,
              text: context.appText.accountCreatedSuccessfully,
              subheading: context.appText.accountCreatedSuccessfullySubHeading,
            );
          });
        } else if (state is VpCreationError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      builder: (context, state) {
        final isLoading = state is VpCreationLoading;
        return AppButton(
          title: context.appText.submit,
          isLoading: isLoading,
          onPressed: isLoading ? null : () {
            if (formKey.currentState!.validate()){

              final request = VpCreationApiRequest(
                  customerName: nameTextController.text,
                  mobileNumber: mobileNumberTextController.text,
                  companyName: companyNameTextController.text,
                  truckType: truckTypeDropDownValue,
                  ownedTrucks: ownedTruckTextController.text,
                  attachedTrucks: attachedTruckTextController.text,
                  preferredLanes: preferredLanesDropDownValue,
                  uploadRc: uploadedRcFile ?? "",
              );

              vpCreationBloc.add(VpCreationRequested(apiRequest: request, id: widget.id));
            }
          },
        );
      },
    );
  }


}
