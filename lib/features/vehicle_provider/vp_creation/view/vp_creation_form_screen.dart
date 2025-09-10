import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/email_verification/view/email_verification_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/login/bloc/login_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/preferLans_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/widgets/vp_company_type_dropdown.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_count_selector.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
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
import 'package:gro_one_app/utils/key_helper.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/remove_space_inpur_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class VpCreationFormScreen extends StatefulWidget {
  final String id;
  final String mobileNumber;
  final int roleId;
  const VpCreationFormScreen({
    super.key,
    required this.id,
    required this.mobileNumber,
    required this.roleId,
  });

  @override
  State<VpCreationFormScreen> createState() => _VpCreationFormScreenState();
}

class _VpCreationFormScreenState extends BaseState<VpCreationFormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final verifyEmailCubit = locator<EmailVerificationCubit>();
  final loginBloc = locator<LoginBloc>();
  final vpCreationCubit = locator<VpCreateAccountCubit>();

  final nameTextController = TextEditingController();
  final mobileNumberTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final ownedTruckTextController = TextEditingController(text: '0');
  final attachedTruckTextController = TextEditingController(text: '0');
  final pinCodeTextController = TextEditingController();

  final MultiSelectController<int> truckTypeController =
      MultiSelectController<int>();
  final MultiSelectController<int> preferredLanesTypeController =
      MultiSelectController<int>();

  String? preferredLanesDropDownValue;
  String? truckTypeDropDownValue;
  String? uploadedRcFile;
  String? companyTypeDropDownValue;

  List<dynamic> multiFilesList = [];
  List<int> selectedTruckTypeList = [];
  List<int> selectedPrefLanesTypeList = [];

  List<String> getUniqueTypes(List<LoadTruckTypeListModel> dataList) {
    return dataList.map((e) => e.type).toSet().toList();
  }

  @override
  void initState() {
    // TODO: implement initState

    initFunction();
    listenEmailChanges();
    super.initState();
  }



  @override
  void dispose() {

    disposeFunction();

    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    mobileNumberTextController.text = widget.mobileNumber;
    await vpCreationCubit.fetchCompanyType();
    await vpCreationCubit.fetchPrefLane(null,isInit: true);
    await vpCreationCubit.fetchTruckType();
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
    verifyEmailCubit.resetState();
    vpCreationCubit.resetState();
  });


  listenEmailChanges(){
    emailTextController.addListener(() {
      verifyEmailCubit.checkIfEmailChanged(emailTextController.text);
    });
  }


  // Vp Creation Api call
  Future<void> vpCreationApiCall(VpCreateAccountState state) async {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (uploadedRcFile == null) {
        ToastMessages.alert(message: context.appText.rcDocumentRequiredError);
        return;
      }
      if (!verifyEmailCubit.state.isVerifiedEmail && !kDebugMode) {
        ToastMessages.alert(message: context.appText.verifyEmailError);
        return;
      }
      if (int.parse(ownedTruckTextController.text) == 0) {
        ToastMessages.alert(message: context.appText.ownTruckValidation);
        return;
      }


      if(selectedPrefLanesTypeList.isEmpty){
        ToastMessages.alert(message: context.appText.preferredLanes);
        return;
      }

      final request = VpCreationApiRequest(
        customerName: nameTextController.text.trim(),
        mobileNumber: mobileNumberTextController.text,
        companyName: companyNameTextController.text.trim(),
        companyTypeId: int.parse(companyTypeDropDownValue ?? "0"),
        truckType: selectedTruckTypeList,
        ownedTrucks: ownedTruckTextController.text.trim(),
        attachedTrucks: attachedTruckTextController.text.trim(),
        preferredLanes: selectedPrefLanesTypeList,
        emailId: emailTextController.text,
        pincode: pinCodeTextController.text,
        uploadRc: uploadedRcFile,
        roleId: widget.roleId,
      );
      await vpCreationCubit.createAccount(request, widget.id);

      if (state.createAccountUIState?.status == Status.SUCCESS) {
        analyticsHelper.logEvent(
          AnalyticEventName.ONBOARD_VP_FORM_SUBMITTED,
          request.toJson(),
        );
      }
    }
  }

  // Navigate to home screen
  void navigateToHomeScreen(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: context.appText.accountCreatedSuccessfully,
        message: context.appText.accountCreatedSuccessfullySubHeading,
        afterDismiss: () {
          if(widget.roleId == 3){
            context.go(AppRouteName.lpBottomNavigationBar);
          } else {
            context.go(AppRouteName.vpBottomNavigationBar);
          }
          disposeFunction();
        },
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.createAccount),
      body: buildBodyWidget(context),
      bottomNavigationBar: buildSubmitButton(),
    );
  }

  Widget buildBodyWidget(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            buildNameAndPhoneNumberWidget(),
            30.height,
            buildBusinessDetailsWidget(context),
            10.height,
            buildBusinessProofWidget(),
            50.height,
          ],
        ).withScroll(padding: EdgeInsets.all(commonSafeAreaPadding)),
      ),
    );
  }

  // Name and Phone Number
  Widget buildNameAndPhoneNumberWidget() {
    return Column(
      children: [
        // Name
        AppTextField(
          key: AppKeys.txt('full_name'),
          validator: (value) => Validator.fieldRequired(value),
          controller: nameTextController,
          labelText: context.appText.fullName,
          hintText: context.appText.fullNameHint,
          mandatoryStar: true,
          keyboardType: TextInputType.name,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'\-]")),
            NoLeadingSpaceFormatter(),
            LengthLimitingTextInputFormatter(50),
          ],
        ),
        20.height,

        // Phone Number
        AppTextField(
          key: AppKeys.txt('mobile_number'),
          readOnly: true,
          validator: (value) => Validator.phone(value),
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
                Text("+91", style: AppTextStyle.textFiled),
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
          key: AppKeys.txt('pincode'),
          validator: (value) => Validator.pincode(value),
          controller: pinCodeTextController,
          labelText: context.appText.pinCode,
          hintText: "${context.appText.enter} ${context.appText.pinCode}",
          mandatoryStar: true,
          maxLength: 6,
          keyboardType: isAndroid ? TextInputType.number : iosNumberKeyboard,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  // Email Text Field
  Widget buildEmailTextFieldWidget() {
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      bloc: verifyEmailCubit,
      listenWhen:
          (previous, current) =>
              previous.sendOtpState?.status != current.sendOtpState?.status,
      listener: (context, state) async {
        final status = state.sendOtpState?.status;

        if (status == Status.SUCCESS) {
          if (!context.mounted) return;
          final result = await Navigator.of(context).push(
            commonRoute(
              EmailVerificationScreen(
                userId: widget.id,
                emailAddress: emailTextController.text,
              ),
              isForward: true,
            ),
          );
          verifyEmailCubit.setVerifiedEmail(result == true,email: result ? emailTextController.text:null);
        }

        if (status == Status.ERROR) {
          final error = state.sendOtpState?.errorType;
          verifyEmailCubit.setVerifiedEmail(false);
          ToastMessages.error(
            message: getErrorMsg(errorType: error ?? GenericError()),
          );
        }
      },
      builder: (context, state) {
        return AppTextField(
          key: AppKeys.txt('email'),
          validator: (value) => Validator.fieldRequired(value),
          controller: emailTextController,
          labelText: context.appText.email,
          mandatoryStar: true,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [
            LengthLimitingTextInputFormatter(50),
            FilteringTextInputFormatter.deny(RegExp(r'\+')),
          ],
          decoration: commonInputDecoration(
            hintText: context.appText.emailHint,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  !(state.sendOtpState?.status == Status.LOADING)
                      ? (state.isVerifiedEmail ? "Verified" : "Verify")
                      : "Loading..",
                  style: AppTextStyle.body3.copyWith(
                    color: AppColors.primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                  ),
                ),
                5.width,
                Icon(
                  Icons.verified,
                  size: 15,
                  color:
                      state.isVerifiedEmail
                          ? AppColors.greenColor
                          : AppColors.greyIconColor,
                ),
              ],
            ),
            suffixOnTap: () async {
              if (state.isVerifiedEmail) return;

              final String? validation = Validator.email(
                emailTextController.text,
              );
              if (validation == null) {
                await verifyEmailCubit.sendOtp(
                  emailTextController.text,
                  widget.id,
                );
              } else {
                ToastMessages.alert(message: validation);
              }
            },
          ),
        );
      },
    );
  }

  // Business Details
  Widget buildBusinessDetailsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.appText.businessName,
          style: AppTextStyle.body1PrimaryColor,
        ),
        20.height,

        // Company Name
        AppTextField(
          key: AppKeys.txt('company_name'),
          inputFormatters: [
            NoLeadingSpaceFormatter(),
            LengthLimitingTextInputFormatter(50),
          ],
          validator: (value) => Validator.fieldRequired(value),
          controller: companyNameTextController,
          labelText: context.appText.companyName,
          hintText: "${context.appText.enter} ${context.appText.companyName}",
          mandatoryStar: true,

        ),
        20.height,
        
         // Company Type
          BlocConsumer<VpCreateAccountCubit, VpCreateAccountState>(
  bloc: vpCreationCubit,
  listener: (context, state) {
    final status = state.companyTypeUIState?.status;
    if (status == Status.ERROR) {
      final error = state.companyTypeUIState?.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: error ?? GenericError()),
      );
    }
  },
  builder: (context, state) {
    final status = state.companyTypeUIState?.status;
    final isSuccess = status == Status.SUCCESS;

    if (isSuccess) {
      return Column(
        children: [
          VpCompanyTypeSearchableDropdown(
          key: AppKeys.ddl('company_type'),
          selectedCompanyTypeId: companyTypeDropDownValue,
          onCompanyTypeChanged: (newVal) {
            if (!mounted) return;
            setState(() {
              companyTypeDropDownValue = newVal;
            });
          },
          fetchCompanyTypes: (page, searchKey) async {
            // Use the already fetched company types
            final companyList = vpCreationCubit.state.companyTypeUIState?.data ?? [];

            // Optional: filter by search key
            final filtered = searchKey == null || searchKey.isEmpty
                ? companyList
                : companyList
                    .where((c) =>
                        c.companyType.toLowerCase().contains(searchKey.toLowerCase()))
                    .toList();

            return filtered;
          },
          labelText: context.appText.companyType,
          hintText: context.appText.selectCompanyType,
          mandatoryStar: true,
        ),

          20.height,
        ],
      );
    } else {
      // Loading or initial empty state
      return const SizedBox();
    }
  },
),


        // TrucK Type
        BlocConsumer<VpCreateAccountCubit, VpCreateAccountState>(
          bloc: vpCreationCubit,
          listenWhen:
              (previous, current) =>
                  previous.truckTypeUIState?.status !=
                  current.truckTypeUIState?.status,
          listener: (context, state) {
            final status = state.truckTypeUIState?.status;
            if (status == Status.ERROR) {
              final error = state.truckTypeUIState?.errorType;
              ToastMessages.error(
                message: getErrorMsg(errorType: error ?? GenericError()),
              );
            }
          },
          builder: (context, state) {
            final data = state.truckTypeUIState?.data;
            if (data != null) {
              return Column(
                children: [
                  AppMultiSelectionDropdown<int>(
                    key: AppKeys.ddl('truck_type'),
                    labelText: context.appText.truckType,
                    hintText: context.appText.selectTruckType,
                    controller: truckTypeController,

                    mandatoryStar: true,
                    items:
                        state.truckTypeUIState!.data!
                            .map(
                              (e) => DropdownItem<int>(
                                value: e.id ?? 1,
                                label: "${e.type} ${e.subType}",
                              ),
                            )
                            .toList(),

                    onSelectionChange: (selected) {
                      if (selected.isNotEmpty) {
                        selectedTruckTypeList = selected; // already List<int>
                      } else {
                        truckTypeDropDownValue = null;
                        selectedTruckTypeList.clear();
                      }
                      CustomLog.debug(
                        this,
                        'Selected truck type: $selectedTruckTypeList',
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${context.appText.truckType} ${context.appText.pinCode}";
                      }
                      return null;
                    },
                  ),
                  20.height,
                ],
              );
            }
            return const SizedBox();
          },
        ),

        // Preferred Lane
        BlocConsumer<VpCreateAccountCubit, VpCreateAccountState>(
          bloc: vpCreationCubit,
          listenWhen:
              (previous, current) =>
                  previous.prefLaneUIState?.status !=
                  current.prefLaneUIState?.status,
          listener: (context, state) {
            final status = state.prefLaneUIState?.status;
            if (status == Status.ERROR) {
              final error = state.prefLaneUIState?.errorType;
              ToastMessages.error(
                message: getErrorMsg(errorType: error ?? GenericError()),
              );
            }
          },
          builder: (context, state) {
            if (state.prefLaneUIState?.data?.data != null &&
                state.prefLaneUIState!.data!.data!.items.isNotEmpty) {
              final preferredLaneItems = state.selectedPreferLanes;
              if((preferredLaneItems??[]).isNotEmpty){
                selectedPrefLanesTypeList=preferredLaneItems?.map((e) => e.masterLaneId??0,).toList()??[];
              }else{
                selectedPrefLanesTypeList=[];
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        context.appText.preferredLanesText,
                        style: AppTextStyle.textFiled,
                      ),
                      Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                    ],
                  ),
                  8.height,
                  GestureDetector(
                    onTap: () async {
                    await  Navigator.push(context, commonRoute(PreferLensScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        top: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      constraints: BoxConstraints(
                        minHeight: 50
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                        color: AppColors.textFieldFillColor,
                        borderRadius: BorderRadius.circular(
                          commonTexFieldRadius,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            (preferredLaneItems ?? []).isEmpty
                                ? Text(
                                  context.appText.selectLaneType,
                                  style: AppTextStyle.textFieldHint,
                                )
                                : Wrap(
                                  children: List.generate(
                                    preferredLaneItems?.length ?? 0,
                                    (index) => Chip(

                                      label: Text(
                                        '${preferredLaneItems?[index].fromLocation?.name ?? ""} - ${preferredLaneItems?[index].toLocation?.name ?? ""}',
                                      ),
                                      backgroundColor: AppColors.primaryColor,
                                      labelStyle: AppTextStyle.body3WhiteColor,
                                      deleteIcon:  Icon(Icons.clear, color: Colors.white, size: 18),
                                      deleteIconColor: Colors.red,
                                      onDeleted: () =>  vpCreationCubit.selectLanes(
                                        selected: false,
                                        id: preferredLaneItems?[index].masterLaneId,
                                      )
                                     , shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),

        10.height,

        // Owned Trucks
        AppCountSelector(
          key: AppKeys.cnt('owned_trucks'),
          label: context.appText.ownedTrucks,
          controller: ownedTruckTextController,
          isMandatory: true,
        ),

        // Attached Trucks
        AppCountSelector(
          key: AppKeys.cnt('attached_trucks'),
          label: context.appText.attachedTrucks,
          controller: attachedTruckTextController,
        ),
      ],
    );
  }

  // Business Proof
  Widget buildBusinessProofWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.appText.businessProof,
          style: AppTextStyle.body1PrimaryColor,
        ),
        20.height,

        // Upload Rc Truck Document
        BlocConsumer<VpCreateAccountCubit, VpCreateAccountState>(
          bloc: vpCreationCubit,
          listenWhen:
              (previous, current) =>
                  previous.uploadRcFileUIState?.status !=
                  current.uploadRcFileUIState?.status,
          listener: (context, state) {
            final status = state.prefLaneUIState?.status;

            if (status == Status.SUCCESS) {
              if (state.uploadRcFileUIState?.data != null &&
                  state.uploadRcFileUIState?.data?.data != null &&
                  state.uploadRcFileUIState!.data!.data!.url.isNotEmpty) {
                uploadedRcFile = state.uploadRcFileUIState!.data!.data!.url;
                vpCreationCubit.resetUploadRcFileUIState();
                ToastMessages.success(
                  message: context.appText.fileUploadSuccessfully,
                );
              }
            }

            if (status == Status.ERROR) {
              final error = state.prefLaneUIState?.errorType;
              multiFilesList.clear();
              ToastMessages.error(
                message: getErrorMsg(errorType: error ?? GenericError()),
              );
            }
          },
          builder: (BuildContext context, VpCreateAccountState state) {
            final isLoading =
                state.uploadRcFileUIState?.status == Status.LOADING;
            return UploadAttachmentFiles(
              onDelete: (p0) {
                uploadedRcFile=null;
              },
              allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
              multiFilesList: multiFilesList,
              title: context.appText.uploadRC,
              isMandatory: true,
              isSingleFile: true,

              isLoading: isLoading,
              thenUploadFileToSever: () {
                if (multiFilesList.isNotEmpty) {
                  vpCreationCubit.uploadRcTruckFile(
                    File(multiFilesList.first['path']),
                    widget.id,
                  );
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
    return BlocConsumer<VpCreateAccountCubit, VpCreateAccountState>(
      bloc: vpCreationCubit,
      listenWhen:
          (previous, current) =>
              previous.createAccountUIState?.status !=
              current.createAccountUIState?.status,
      listener: (context, state) async {
        final status = state.createAccountUIState?.status;

        if (status == Status.SUCCESS) {
          loginBloc.add(SaveDeviceToken(widget.id));
          navigateToHomeScreen(context);
        }
        if (status == Status.ERROR) {
          final error = state.createAccountUIState?.errorType;
          ToastMessages.error(
            message: getErrorMsg(errorType: error ?? GenericError()),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state.createAccountUIState?.status == Status.LOADING;
        return AppButton(
          key: AppKeys.btn('submit'),
          title: context.appText.submit,
          isLoading: isLoading,
          onPressed:
              isLoading ? () {} : () async => await vpCreationApiCall(state),
        );
      },
    ).bottomNavigationPadding();
  }
}
