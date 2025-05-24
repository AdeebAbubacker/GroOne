import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/aadhaar_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';

class VpCreationFormScreen extends StatefulWidget {
  const VpCreationFormScreen({super.key});

  @override
  State<VpCreationFormScreen> createState() => _VpCreationFormScreenState();
}

class _VpCreationFormScreenState extends State<VpCreationFormScreen> {

  final vpCreationBloc = locator<VpCreationBloc>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final mobileNumberTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final ownedTruckTextController = TextEditingController();
  final attachedTruckTextController = TextEditingController();
  final pinCodeTextController = TextEditingController();

  String? truckTypeDropDownValue;
  String? preferredLanesDropDownValue;

  List<dynamic> multiFilesList = [];

  final List<String> truckTypeList = [
    'Open Truck',
    'Close Truck'
  ];

  final List<String> preferredLanesList = [
    'Chennai - Mumbai',
    'Chennai -  Pune',
    'Chennai - Delhi',
    'Chennai - Bangalore',
    'Mumbai - Hyderabad',
    'Mumbai - Chennai',
    'Mumbai - Pune',
    'Mumbai - Delhi',
    'Mumbai - Bangalore',
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
        AppDropdown(
          validator: (value)=> Validator.fieldRequired(value, fieldName: context.appText.truckType),
          labelText: context.appText.truckType,
          hintText: context.appText.selectTruckType,
          dropdownValue: truckTypeDropDownValue,
          decoration: commonInputDecoration(),
          dropDownList: truckTypeList.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: AppTextStyle.body),
          )).toList(),
          onChanged: (onChangeValue) {
            truckTypeDropDownValue = onChangeValue;
          },
        ),
        //MultiPickerSelection(labelText: context.appText.truckType, hintText: ""),
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
        AppDropdown(
          validator: (value)=> Validator.fieldRequired(value, fieldName: context.appText.preferredLanes),
          labelText: context.appText.preferredLanes,
          hintText: context.appText.selectLaneType,
          dropdownValue: preferredLanesDropDownValue,
          decoration: commonInputDecoration(),
          dropDownList: preferredLanesList.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: AppTextStyle.body),
          )).toList(),
          onChanged: (onChangeValue) {
            preferredLanesDropDownValue = onChangeValue;
          },
        ),
       // MultiPickerSelection(labelText: context.appText.preferredLanes, hintText: ""),
      ],
    );
  }


  Widget buildBusinessProofWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.businessProof, style: AppTextStyle.body1PrimaryColor),
        20.height,

        UploadAttachmentFiles(
          multiFilesList: multiFilesList,
          title: context.appText.uploadRC,
          isSingleFile: true,
        ),
        20.height,

        // Aadhaar Number
        // AppTextField(
        //   controller: aadhaarNumberTextController,
        //   labelText: context.appText.aadhaarNumber,
        //   hintText:  context.appText.aadhaarHint,
        //   inputFormatters: [
        //     AadhaarInputFormatter(),
        //   ],
        // ),
      ],
    );
  }

  // Submit Button
  Widget buildSubmitButton() {
    return BlocConsumer<VpCreationBloc, VpCreationState>(
      bloc: vpCreationBloc,
      listener: (context, state) {
        if (state is VpCreationSuccess) {
          var data = state.vpCreationModel.data;
          addPostFrameCallback(() => context.go(AppRouteName.vpBottomNavigationBar));
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
              );
              vpCreationBloc.add(VpCreationRequested(apiRequest: request));
            }
          },
        );
      },
    );
  }


}
