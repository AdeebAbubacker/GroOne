import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/master/helper/date_helper.dart';
import 'package:gro_one_app/features/master/view/master_screen.dart';
import 'package:gro_one_app/features/master/widget/master_driver_widget.dart';
import 'package:gro_one_app/features/profile/api_request/driver_request.dart';
import 'package:gro_one_app/features/profile/api_request/license_vahan_request.dart';
import 'package:gro_one_app/features/profile/cubit/masters/masters_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/helper/master_helper.dart';
import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:gro_one_app/features/profile/view/widgets/blood_category_dropdown.dart';
import 'package:gro_one_app/features/profile/view/widgets/license_category_dropdown.dart';
import 'package:gro_one_app/features/profile/view/widgets/master_dialogue_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/indian_licesne_fromatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/upper_case_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class buildDriverTab extends StatefulWidget {
  const buildDriverTab({super.key});

  @override
  State<buildDriverTab> createState() => _buildDriverTabState();
}

class _buildDriverTabState extends State<buildDriverTab> {
  final profileCubit = locator<ProfileCubit>();
  final mastersCubit = locator<MastersCubit>();
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final lpHomeCubit = locator<LPHomeCubit>();
  List<String> selectedCommodities = [];
  late TabController _tabController;
  final vehicleSearchController = TextEditingController();
  final addressSearchController = TextEditingController();
  final driverSearchController = TextEditingController();
  Timer? vehicleSearchDebounce;
  Timer? addressSearchDebounce;
  Timer? driverSearchDebounce;
  final kycCubit = locator<KycCubit>();
  String? selectedTruckType;
  String? selectedTruckLength;
  String? truckLengthDropdownValue;
  bool showValidationErrors = false;
  List<Map<String, dynamic>> vehicleDocList = [];
  String? insuranceValidityDate;
  String? fcExpiryDate;
  String? pucExpiryDate;
  String? registrationDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.height,
        // Search Bar
        AppSearchBar(
          searchController: driverSearchController,
          onChanged: (query) {
            driverSearchDebounce?.cancel();
            driverSearchDebounce = Timer(const Duration(milliseconds: 300), () {
              profileCubit.fetchDriver(search: query);
            });
          },
          onClear: () {
            setState(() {
              driverSearchController.text = '';
              driverSearchController.clear();
            });
            profileCubit.fetchDriver(search: '');
          },
        ).paddingSymmetric(horizontal: 20),
        Expanded(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final uiState = state.driverState;

              if (uiState == null || uiState.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              if (uiState.status == Status.ERROR) {
                return genericErrorWidget(error: uiState.errorType);
              }

              final driverList = uiState.data?.data ?? [];

              if (driverList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppImage.svg.noSearchFound,
                            height: 120,
                          ),
                          20.height,
                          Text(
                            context.appText.noDriversfound,
                            style: AppTextStyle.h5,
                          ),
                          10.height,
                          Text(
                            context.appText.startByAddingANewDriver,
                            style: AppTextStyle.body3,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // Reset page count if you are paginating
                  await profileCubit.fetchDriver(isLoading: true);
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      context.read<ProfileCubit>().fetchDriver(loadMore: true);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    itemCount: driverList.length,
                    itemBuilder: (context, index) {
                      DriverDetailsData driver = driverList[index];
                      return masterDriverInfoWidget(
                        name: driver.name,
                        phone: driver.mobile,
                        driverStatus: driver.driverStatus,
                        onEdit: () async {
                          mastersCubit.resetLicenseVerification();
                          await Future.delayed(
                            const Duration(milliseconds: 50),
                          );
                          showAddDriverPopup(context, driver: driver);
                        },
                        onDelete:
                            () => showDeletePopUp(
                              context: context,
                              confirmMessage:
                                  context.appText.areYouSureToDeleteThisDriver,
                              successMessage:
                                  context.appText.driverDeletedSuccessfully,
                              onDelete:
                                  () => profileCubit.deleteDriver(
                                    driverId: driver.driverId,
                                  ),
                            ),
                        context: context,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: AppButton(
            title: context.appText.addNewDriver,
            onPressed: () async {
              mastersCubit.resetLicenseVerification();
              await Future.delayed(const Duration(milliseconds: 50));
              showAddDriverPopup(context);
            },
          ),
        ),
        20.height,
      ],
    );
  }

  /// Add Driver Popup
  void showAddDriverPopup(
    BuildContext context, {
    DriverDetailsData? driver,
  }) async {
    mastersCubit.resetLicenseVerification();

    bool isLicenseVerified = driver != null;

    final formKey = GlobalKey<FormState>();
    final isEdit = driver != null;
    String? selectedlicenseExpiryDate =
        driver?.licenseExpiryDate != null
            ? DateFormat('dd/MM/yyyy').format(driver!.licenseExpiryDate!)
            : null;

    String? selectedDoB =
        driver?.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(driver!.dateOfBirth!)
            : null;
    final nameController = TextEditingController(text: driver?.name ?? "");
    final licenseNumberController = TextEditingController(
      text: driver?.licenseNumber ?? "",
    );
    final mobileController = TextEditingController(
      text: driver?.mobile.replaceFirst('+91', '') ?? "",
    );
    int? selectedLicneseId = driver?.licenseCategory;
    int? selectedBloodId = driver?.bloodGroup;
    final emailController = TextEditingController(text: driver?.email ?? "");
    final localLicenseDocList = <Map<String, dynamic>>[];
    if (driver?.licenseDocLink != null && driver!.licenseDocLink!.isNotEmpty) {
      final doc = createFileFromLink(driver.licenseDocLink!);
      if (doc != null) {
        localLicenseDocList.add(doc);
      }
    }
    bool isInitialized = false;
    String previousLicenseNo = licenseNumberController.text.trim();
    bool isActive = driver != null ? (driver.driverStatus == 1) : true;
    bool listenerAdded = false;
    String? selectedLicense;
    String? selectedBloodGroup;
    selectedBloodGroup = MasterHelper.mapBloodGroupIdToName(driver?.bloodGroup);
    selectedBloodId = driver?.bloodGroup;
    selectedLicense = MasterHelper.mapLicenseCategoryIdToName(
      driver?.licenseCategory,
    );
    selectedLicneseId = driver?.licenseCategory;
    MasterDialogueWidget.show(
      dismissible: true,
      context,
      child: StatefulBuilder(
        builder: (
          BuildContext context,
          void Function(void Function()) setState,
        ) {
          if (!listenerAdded) {
            licenseNumberController.addListener(() {
              final currentText = licenseNumberController.text.trim();
              if (currentText != previousLicenseNo) {
                previousLicenseNo = currentText;
                mastersCubit.resetLicenseVerification();
                setState(() {
                  isInitialized = false;
                  isLicenseVerified = false;
                });
              }
            });
            listenerAdded = true;
          }

          final licenseDocUpload =
              context.watch<ProfileCubit>().state.licenseDocUpload;
          final isUploading = licenseDocUpload?.status == Status.LOADING;

          if (!isInitialized && driver?.licenseDocLink?.isNotEmpty == true) {
            final doc = createFileFromLink(driver!.licenseDocLink!);
            if (doc != null) {
              localLicenseDocList
                ..clear()
                ..add(doc);
              vehicleDocList
                ..clear()
                ..add(doc);
            }
            isInitialized = true;
          }

          return MasterCommonDialogView(
            hideCloseButton: true,
            showYesNoButtonButtons: true,
            yesButtonText:
                isEdit ? context.appText.update : context.appText.save,
            noButtonText: context.appText.cancel,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit
                        ? context.appText.editDriver
                        : context.appText.addNewDriver,
                    style: AppTextStyle.h4,
                  ),
                  20.height,
                  buildLicenseVerificationFieldWidget(
                    licenseNoController: licenseNumberController,
                    selectedDoB: selectedDoB ?? "",
                    onDobChanged: (dob) {
                      setState(() {
                        selectedDoB = dob;
                      });
                    },
                    nameController: nameController,
                    onVerificationResult: (isVerified, licenseData) {
                      setState(() {
                        isLicenseVerified = isVerified || driver != null;
                        if (licenseData != null) {
                          print(
                            '--------------------${licenseData['expiry_date']}',
                          );
                          // Name
                          final nameRaw =
                              licenseData['name'] ??
                              licenseData['user_full_name'];
                          if (nameRaw != null) {
                            nameController.text = nameRaw;
                          }

                          final dobRaw =
                              licenseData['user_dob'] ??
                              licenseData['dateOfBirth'];
                          selectedDoB = DateHelper.parseDate(dobRaw);
                          final bloodGroupList =
                              context
                                  .read<ProfileCubit>()
                                  .state
                                  .bloodGroupResponseUIState
                                  ?.data ??
                              [];

                          final bloodMap = MasterDriverDropDownHelper.mapBloodGroup(
                            bloodGroupList,
                            licenseData['user_blood_group'] ??
                                licenseData['bloodGroup'],
                          );

                          if (bloodMap != null) {
                            selectedBloodId = bloodMap['id'];
                            selectedBloodGroup = bloodMap['name'];
                          } else {
                            selectedBloodId = null;
                            selectedBloodGroup = null;
                          }

                          // License category
                          final licenseCategoryList =
                              context
                                  .read<ProfileCubit>()
                                  .state
                                  .licneseCategoryResponseUIState
                                  ?.data ??
                              [];

                          final licenseMap = MasterDriverDropDownHelper.mapLicenseCategory(
                            licenseCategoryList,
                            licenseData['vehicle_category'] ??
                                licenseData['licenseCategory'],
                          );

                          if (licenseMap != null) {
                            selectedLicneseId = licenseMap['id'];
                            selectedLicense = licenseMap['name'];
                          } else {
                            selectedLicneseId = null;
                            selectedLicense = null;
                          }

                          // Expiry Date
                          final expiryRaw =
                              licenseData['expiry_date'] ??
                              licenseData['licenseExpiryDate'];
                          selectedlicenseExpiryDate = DateHelper.parseDate(
                            expiryRaw,
                          );
                          // Mobile
                          final mobileRaw = licenseData['mobile'];
                          if (mobileRaw != null && mobileRaw is String) {
                            mobileController.text = mobileRaw.replaceFirst(
                              '+91',
                              '',
                            );
                          }

                          // Email
                          final emailRaw = licenseData['email'];
                          if (emailRaw != null && emailRaw is String) {
                            emailController.text = emailRaw;
                          }

                          // Driver Status
                          if (licenseData['driverStatus'] != null) {
                            isActive = licenseData['driverStatus'] == 1;
                          }

                          // License Documents
                          if (licenseData['licenseDocLink'] != null &&
                              licenseData['licenseDocLink'] is String &&
                              licenseData['licenseDocLink']!.isNotEmpty) {
                            localLicenseDocList.clear();
                            final doc = createFileFromLink(
                              licenseData['licenseDocLink'],
                            );
                            if (doc != null) {
                              localLicenseDocList.add(doc);
                            }
                          }
                        }
                      });
                    },
                  ),

                  16.height,
                  UploadAttachmentFiles(
                    multiFilesList: localLicenseDocList,
                    isSingleFile: true,
                    uploadTextField: context.appText.uploadLicense,
                    isLoading: isUploading,
                    thenUploadFileToSever: () async {
                      final result = await _uploadLicenseCopy(
                        context,
                        localLicenseDocList,
                      );
                      if (result is Success) {
                        setState(() {
                          vehicleDocList.clear();
                          vehicleDocList.addAll(localLicenseDocList);
                        });
                      }
                    },
                  ),

                  16.height,

                  ///License Expiry date
                  InkWell(
                    onTap: () async {
                      final DateTime today = DateTime.now();
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: today,
                        firstDate: today,
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final formattedDate = DateFormat(
                          'dd/MM/yyyy',
                        ).format(pickedDate);
                        setState(() {
                          selectedlicenseExpiryDate = formattedDate;
                        });
                      }
                    },
                    child: buildReadOnlyField(
                      context.appText.licenseExpiryDate,
                      selectedlicenseExpiryDate ?? 'Select date',
                      fillColor: Colors.white,
                      mandatoryStar: true,
                    ),
                  ),
                  16.height,
                  AppTextField(
                    validator: (value) => Validator.phone(value),
                    controller: mobileController,
                    labelText: context.appText.phoneNumber,
                    maxLength: 10,
                    inputFormatters: [phoneNumberInputFormatter],
                    keyboardType: TextInputType.phone,
                    decoration: commonInputDecoration(
                      focusColor: AppColors.borderColor,
                      hintText:
                          "${context.appText.enter} ${context.appText.phoneNumber}",
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
                  16.height,
                  LicenseCategoryDropdown(
                    selected: selectedLicense,
                    onChanged: (LicenseCategoryResponseModel? category) {
                      setState(() {
                        selectedLicense = category?.categoryName;
                        selectedLicneseId = category?.id;
                        print("selected licesne id ${selectedLicneseId}");
                      });
                    },
                  ),
                  16.height,
                  BloodCategoryDropdown(
                    selected: selectedBloodGroup,
                    onChanged: (BloodGroupResponseModel? category) {
                      setState(() {
                        selectedBloodGroup = category?.groupName;
                        selectedBloodId = category?.id;
                        print("selected blood id ${selectedLicneseId}");
                      });
                    },
                  ),
                  16.height,
                  AppTextField(
                    labelText: '${context.appText.emailId}(optional)',
                    hintText: 'example@email.com',
                    controller: emailController,
                    validator: (value) {
                      return null;
                    },
                    decoration: commonInputDecoration(
                      hintText: 'example@email.com',
                    ),
                  ),

                  16.height,

                  /// Active Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.appText.active),
                      Switch(
                        value: isActive,
                        onChanged: (val) => setState(() => isActive = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onClickYesButton: () async {
              final String? validation = Validator.fieldRequired(
                licenseNumberController.text.trim(),
                fieldName: 'License No',
              );
              if (validation != null) {
                ToastMessages.alert(message: validation);
                return;
              }
              if (!isLicenseVerified) {
                ToastMessages.alert(
                  message: "Please verify the License before proceeding",
                );
                return;
              }
              if (formKey.currentState!.validate()) {
                if (licenseNumberController.text.trim().isEmpty) {
                  ToastMessages.alert(message: "Please enter License Number");
                  return;
                }

                if (selectedDoB == null || selectedDoB!.isEmpty) {
                  ToastMessages.alert(message: "Please select Date of Birth");
                  return;
                }

                if (nameController.text.trim().isEmpty) {
                  ToastMessages.alert(message: "Please enter Driver Name");
                  return;
                }

                if (selectedlicenseExpiryDate == null ||
                    selectedlicenseExpiryDate!.isEmpty) {
                  ToastMessages.alert(
                    message: "Please select License Expiry Date",
                  );
                  return;
                }

                if (mobileController.text.trim().isEmpty) {
                  ToastMessages.alert(message: "Please enter Mobile Number");
                  return;
                }

                if (localLicenseDocList.isEmpty) {
                  ToastMessages.alert(
                    message: "Please upload License Document",
                  );
                  return;
                }
                if (!formKey.currentState!.validate()) {
                  return;
                }
                final licenseExpiryIso =
                    selectedlicenseExpiryDate != null
                        ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
                          DateFormat(
                            'dd/MM/yyyy',
                          ).parse(selectedlicenseExpiryDate!),
                        )
                        : null;

                final dateOfBirthIso =
                    selectedDoB != null
                        ? DateFormat(
                          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                        ).format(DateFormat('dd/MM/yyyy').parse(selectedDoB!))
                        : null;
                final rcDocLink =
                    localLicenseDocList.isNotEmpty
                        ? localLicenseDocList.first['path']
                        : '';

                final request = DriverRequest(
                  customerId: profileCubit.userId ?? "",
                  name: nameController.text,
                  mobile: removeCountryFormatMobileNumber(
                    mobileController.text.trim(),
                  ),
                  email: emailController.text,
                  licenseNumber: licenseNumberController.text,
                  licenseDocLink: rcDocLink,
                  licenseExpiryDate: convertToYMD(licenseExpiryIso.toString())  ?? '',
                  dateOfBirth: convertToYMD(dateOfBirthIso.toString())  ?? '',
                  licenseCategory: selectedLicneseId,
                  bloodGroup: selectedBloodId,
                  driverStatus: isActive ? 1 : 2,
                );
                if (isEdit) {
                  await profileCubit.updateDriver(
                    driverId: driver.driverId,
                    request: request,
                  );
                } else {
                  await profileCubit.createDriver(request: request);
                }

                final state = profileCubit.state.createDriverState;
                if (state?.status == Status.SUCCESS) {
                  if (context.mounted) Navigator.pop(context);
                  profileCubit.fetchDriver(isLoading: false);
                  ToastMessages.success(
                    message:
                        isEdit
                            ? context.appText.driverUpdatedSuccessfully
                            : context.appText.driverAddedSuccess,
                  );
                } else {
                  ToastMessages.error(
                    message: getErrorMsg(
                      errorType: state?.errorType ?? GenericError(),
                    ),
                  );
                }
              }
            },
            onClickNoButton: () async {
              mastersCubit.resetLicenseVerification();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Map<String, dynamic>? createFileFromLink(String url) {
    if (url.trim().isEmpty) return null;

    final uri = Uri.parse(url);
    if (uri.pathSegments.isEmpty) return null;

    final fileName = uri.pathSegments.last;
    final extension = fileName.split('.').last;

    return {"fileName": fileName, "path": url, "extension": extension};
  }

  /// Delete Popup
  void showDeletePopUp({
    required BuildContext context,
    required String confirmMessage,
    required String successMessage,
    required Future<dynamic> Function() onDelete,
  }) {
    AppDialog.show(
      context,
      dismissible: true,
      child: CommonDialogView(
        hideCloseButton: true,
        showYesNoButtonButtons: true,
        noButtonText: context.appText.cancel,
        yesButtonText: context.appText.delete,
        yesButtonTextStyle: AppButtonStyle.deleteTextButton,
        child: Column(
          children: [
            Lottie.asset(
              AppJSON.alertRed,
              repeat: true,
              frameRate: FrameRate(200),
            ),
            Center(child: Text(confirmMessage, textAlign: TextAlign.center)),
          ],
        ),
        onClickYesButton: () async {
          final result = await onDelete();

          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop();
              ToastMessages.success(message: successMessage);
            }
          } else if (result is Error) {
            ToastMessages.error(message: getErrorMsg(errorType: result.type));
          }
        },
      ),
    );
  }

  String formatMobileNumber(String number) {
    if (!number.startsWith("+91") && number.length == 10) {
      return "$number";
    }
    return number;
  }

  String removeCountryFormatMobileNumber(String number) {
    number = number.trim();
    if (number.startsWith("+91")) {
      number = number.substring(3); // remove +91
    }
    return number;
  }

  String removeformatMobileNumber(String number) {
    if (!number.startsWith("+91") && number.length == 10) {
      return "$number";
    }
    return number;
  }

  /// Upload License Copy
  Future<Result<bool>> _uploadLicenseCopy(
    BuildContext context,
    List<Map<String, dynamic>> multiFilesList,
  ) async {
    final cubit = context.read<ProfileCubit>();
    await cubit.uploadLicenseDoc(File(multiFilesList.first['path']));
    final status = cubit.state.vehicleDocUpload!.status;

    if (status == Status.SUCCESS) {
      final url = cubit.state.vehicleDocUpload!.data?.data?.url ?? '';
      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    } else if (status == Status.ERROR) {
      final errorType = cubit.state.vehicleDocUpload!.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }
}

/// Verify License
Widget buildLicenseVerificationFieldWidget({
  required TextEditingController licenseNoController,
  required String selectedDoB,
  required void Function(String) onDobChanged,
  required TextEditingController nameController,
  required void Function(bool, Map<String, dynamic>?) onVerificationResult,
}) {
  return BlocBuilder<MastersCubit, MastersState>(
    buildWhen:
        (previous, current) =>
            previous.licenseVerification != current.licenseVerification,
    builder: (context, state) {
      final verificationState = state.licenseVerification;
      final isVerified = verificationState.status == Status.SUCCESS;
      final isLoading = verificationState.status == Status.LOADING;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// License No Field
          AppTextField(
            controller: licenseNoController,
            mandatoryStar: true,
            labelText: "License No",
            hintText: "License No",

            inputFormatters: [
              UpperCaseTextFormatter(),
              IndianLicenseFormatter(),
            ],
            validator:
                (value) => Validator.indianLicenseNumber(
                  value,
                  fieldName: "License No",
                ),
            readOnly: isVerified,
            decoration: commonInputDecoration(
              suffixIcon:
                  verificationState.status == Status.LOADING
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : isVerified
                      ? const Icon(Icons.verified, color: Colors.green)
                      : SizedBox.shrink(),
            ),
          ),
          16.height,

          /// Date of Birth Picker
          InkWell(
            onTap: () async {
              final DateTime today = DateTime.now();
              final DateTime eighteenYearsAgo = DateTime(
                today.year - 18,
                today.month,
                today.day,
              );

              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: eighteenYearsAgo,
                firstDate: DateTime(1900),
                lastDate: eighteenYearsAgo,
              );

              if (pickedDate != null) {
                final formattedDate = DateFormat(
                  'dd/MM/yyyy',
                ).format(pickedDate);
                onDobChanged(formattedDate);
              }
            },
            child: buildReadOnlyField(
              "Date of Birth",
              selectedDoB.isEmpty ? 'DOB' : selectedDoB,
              fillColor: Colors.white,
              mandatoryStar: true,
            ),
          ),
          16.height,

          /// Driver Name
          AppTextField(
            controller: nameController,
            labelText: "Driver Name",
            hintText: "Driver Name",
            mandatoryStar: true,
            validator: (value) => Validator.fieldRequired(value),
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
          ),
          16.height,

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 170,
                height: commonButtonHeight2,
                child: AppButton(
                  isLoading: isLoading,
                  title:
                      isVerified
                          ? context.appText.verified
                          : context.appText.verify,
                  onPressed:
                      isVerified
                          ? () {}
                          : () async {
                            // Call API
                            final licenseValidation =
                                Validator.indianLicenseNumber(
                                  licenseNoController.text,
                                  fieldName: "License No",
                                );
                            if (licenseValidation != null) {
                              ToastMessages.alert(message: licenseValidation);
                              return;
                            }
                            if (selectedDoB.isEmpty) {
                              ToastMessages.alert(
                                message: "Please select Date of Birth",
                              );
                              return;
                            }
                            if (nameController.text.trim().isEmpty) {
                              ToastMessages.alert(
                                message: "Please enter Driver Name",
                              );
                              return;
                            }
                            final result = await context
                                .read<MastersCubit>()
                                .fetchAndVerifyLicense(
                                  licensereq: LicenseVahanRequest(
                                    licenseNumber:
                                        licenseNoController.text.trim(),
                                    dob: selectedDoB,
                                    name: nameController.text.trim(),
                                  ),
                                );

                            if (result is Success<Map<String, dynamic>>) {
                              ToastMessages.success(
                                message: "License verified & data autofilled.",
                              );
                              onVerificationResult(true, result.value);
                            } else {
                              ToastMessages.alert(
                                message: "License verification failed",
                              );
                              onVerificationResult(false, null);
                            }
                          },
                  style:
                      isVerified
                          ? AppButtonStyle.primary
                          : AppButtonStyle.outline,
                ),
              ),
            ],
          ),
          16.height,
        ],
      );
    },
  );
}
