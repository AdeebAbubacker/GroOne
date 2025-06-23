import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/email_verification/view/email_verification_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/upload_rc_truck_file/upload_rc_truck_file_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
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
  final verifyEmailCubit = locator<EmailVerificationCubit>();

  final nameTextController = TextEditingController();
  final mobileNumberTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final ownedTruckTextController = TextEditingController();
  final attachedTruckTextController = TextEditingController();
  final pinCodeTextController = TextEditingController();


  final MultiSelectController<int> truckTypeController = MultiSelectController<int>();
  final MultiSelectController<String>  preferredLanesTypeController = MultiSelectController<String>();

  String? preferredLanesDropDownValue;
  String? truckTypeDropDownValue;
  String? uploadedRcFile;
  String? companyTypeDropDownValue;


  List<dynamic> multiFilesList = [];
  List<int> selectedTruckTypeList = [];

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

  void initFunction() => frameCallback(() {
    mobileNumberTextController.text = widget.mobileNumber;
    loadTruckTypeBloc.add(LoadTruckType());
    vpCreationBloc.add(VpCompanyTypeEvent());
    verifyEmailCubit.resetState();
  });

  void disposeFunction() => frameCallback(() {
    nameTextController.clear();
    mobileNumberTextController.clear();
    companyNameTextController.clear();
    ownedTruckTextController.clear();
    attachedTruckTextController.clear();
    pinCodeTextController.clear();
    truckTypeController.dispose();
    truckTypeController.dispose();
    emailTextController.clear();
    preferredLanesDropDownValue = null;
    uploadedRcFile = null;
    multiFilesList.clear();
    preferredLanesList.clear();
    vpCreationBloc.add(VpResetEvent());
    uploadRcTruckFileBloc.add(ResetUploadRcDocumentEvent());
    verifyEmailCubit.resetState();
  });


  // Vp Creation Api call
  void vpCreationApiCall(){
    if (formKey.currentState!.validate()){
      if(uploadedRcFile == null){
        ToastMessages.error(message: getErrorMsg(errorType: GenericError()));
        return;
      }
      if(!verifyEmailCubit.state.isVerifiedEmail && !kDebugMode){
        ToastMessages.alert(message: "Please verify your email");
        return;
      }
      final request = VpCreationApiRequest(
        customerName: nameTextController.text,
        mobileNumber: mobileNumberTextController.text,
        companyName: companyNameTextController.text,
        companyTypeId: companyTypeDropDownValue,
        truckType: selectedTruckTypeList,
        ownedTrucks: ownedTruckTextController.text,
        attachedTrucks: attachedTruckTextController.text,
        preferredLanes: preferredLanesDropDownValue,
        emailId: emailTextController.text,
        pincode: pinCodeTextController.text,
        uploadRc: uploadedRcFile,
      );
      vpCreationBloc.add(VpCreationRequested(apiRequest: request, id: widget.id));
    }
  }


  // Navigate to home screen
  void navigateToHomeScreen(BuildContext context) => frameCallback(() {
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
      appBar: CommonAppBar(title: context.appText.createAccount),
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

  // Name and Phone Number
  Widget buildNameAndPhoneNumberWidget(){
    return Column(
      children: [

        // Name
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: nameTextController,
          labelText: context.appText.fullName,
          hintText: context.appText.fullNameHint,
          mandatoryStar: true,
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
            fillColor: AppColors.lightGreyBackgroundColor,
            focusColor: AppColors.borderColor,
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

        // Email
        buildEmailTextFieldWidget(),
        20.height,

        // Pin code Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: pinCodeTextController,
          labelText: context.appText.pinCode,
          hintText: "${context.appText.enter} ${context.appText.pinCode}",
          mandatoryStar: true,
          maxLength: 6,
          keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],

        ),
      ],
    );
  }


  // Email Text Field
  Widget buildEmailTextFieldWidget() {
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
        bloc: verifyEmailCubit,
        listenWhen: (previous, current) =>  previous.sendOtpState != current.sendOtpState,
        listener:  (context, state) async {
          final status = state.sendOtpState?.status;

          if (status == Status.SUCCESS) {
            if (!context.mounted) return;
            final result = await Navigator.of(context).push(commonRoute(EmailVerificationScreen(userId: widget.id,emailAddress: emailTextController.text), isForward: true));
            verifyEmailCubit.setVerifiedEmail(result == true);
          }

          if (status == Status.ERROR) {
            final error = state.sendOtpState?.errorType;
            verifyEmailCubit.setVerifiedEmail(false);
            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
          }
        },
        builder: (context, state) {
          return AppTextField(
            validator: (value) => Validator.fieldRequired(value),
            controller: emailTextController,
            labelText: context.appText.email,
            mandatoryStar: true,
            keyboardType: TextInputType.emailAddress,
            decoration: commonInputDecoration(
                hintText: context.appText.emailHint,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(!(state.sendOtpState?.status ==  Status.LOADING) ? (state.isVerifiedEmail ? "Verified" :"Verify"): "Loading..", style: AppTextStyle.body3),
                    5.width,
                    Icon(Icons.verified, size: 15, color : state.isVerifiedEmail ? AppColors.greenColor : AppColors.greyIconColor),
                  ],
                ),
                suffixOnTap: () async {
                  final String? validation = Validator.email(emailTextController.text);
                  if(validation == null){
                    await verifyEmailCubit.sendOtp(emailTextController.text);
                  } else {
                    ToastMessages.alert(message: validation);
                  }
                }
            ),
          );
        }
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
          mandatoryStar: true,
        ),
        20.height,

        // Company Type
        BlocConsumer<VpCreationBloc, VpCreationState>(
          bloc: vpCreationBloc,
          buildWhen: (previous, current) => current is VpCompanyTypeSuccess,
          listener: (context, state) {
            if (state is VpCompanyTypeError) {
              ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
            }
          },
          builder: (context, state) {
            if(state is VpCompanyTypeSuccess){
              return Column(
                children: [
                  AppDropdown(
                    validator: (value) => Validator.fieldRequired(value),
                    labelText: context.appText.companyType,
                    hintText: context.appText.selectCompanyType,
                    mandatoryStar: true,
                    dropdownValue: companyTypeDropDownValue,
                    decoration: commonInputDecoration(fillColor: Colors.white),
                    dropDownList: state.companyType.data.map((e) => DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.companyType, style: AppTextStyle.body)),
                    ).toList(),
                    onChanged: (onChangeValue) {
                      companyTypeDropDownValue = onChangeValue;
                      setState(() {});
                    },
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
        20.height,




        // TrucK Type
        BlocConsumer<LoadTruckTypeBloc, LoadTruckTypeState>(
          bloc: loadTruckTypeBloc,
          buildWhen: (previous, current) => current is LoadTruckTypeSuccess,
          listener: (context, state) {
            if (state is LoadTruckTypeError) {
              ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
            }
          },
          builder: (context, state) {
            if (state is LoadTruckTypeSuccess) {
              return AppMultiSelectionDropdown<int>(
                labelText: context.appText.truckType,
                hintText: context.appText.selectTruckType,
                controller: truckTypeController,
                mandatoryStar: true,
                items: state.loadTruckTypeListModel.data.map((e) => DropdownItem<int>(
                  value: e.id,
                  label: "${e.type} ${e.subType}",
                )).toList(),
                onSelectionChange: (selected) {
                  if (selected.isNotEmpty) {
                    selectedTruckTypeList = selected; // already List<int>
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
        20.height,


        // Owned Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: ownedTruckTextController,
          labelText: context.appText.ownedTrucks,
          hintText: "${context.appText.enter} ${context.appText.ownedTrucks}",
          mandatoryStar: true,
          keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        20.height,

        // Attached Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: attachedTruckTextController,
          labelText: context.appText.attachedTrucks,
          hintText: "${context.appText.enter} ${context.appText.attachedTrucks}",
          mandatoryStar: true,
          keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        20.height,

        // Preferred Lane
        AppMultiSelectionDropdown<String>(
          labelText: context.appText.preferredLanes,
          hintText: context.appText.selectLaneType,
          controller: preferredLanesTypeController,
          mandatoryStar: true,
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


  // Business Proof
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
              if (state.fileModel.data != null && state.fileModel.data!.url.isNotEmpty){
                uploadedRcFile = state.fileModel.data!.url;
                uploadRcTruckFileBloc.add(ResetUploadRcDocumentEvent());
                ToastMessages.success(message: "File uploaded successfully");
              } else {
                multiFilesList.clear();
              }
            }
            if (state is UploadRcTruckFileError) {
              multiFilesList.clear();
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
