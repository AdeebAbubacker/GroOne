import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/views/widgets/referral_autocomplete_textfield.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../../../service/analytics/analytics_event_name.dart';
import '../../../service/analytics/analytics_service.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/validator.dart';
import '../../en-dhan_fuel/widgets/endhan_document_upload_widget.dart';
import '../cubit/fastag_cubit.dart';
import 'fastag_list_screen.dart';
import '../../kavach/view/widgets/vehicle_selection_field.dart';
import '../../../utils/toast_messages.dart';

class BuyNewFastagScreen extends StatefulWidget {
  const BuyNewFastagScreen({super.key});

  @override
  State<BuyNewFastagScreen> createState() => _BuyNewFastagScreenState();
}

class _BuyNewFastagScreenState extends State<BuyNewFastagScreen> {
  bool _isLoading = false;
  final TextEditingController _referralCodeController = TextEditingController();
  final List<TextEditingController> _vehicleControllers = [
    TextEditingController(),
  ];
  final List<bool> _vehicleVerifiedList = [false];
  final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  @override
  void dispose() {
    _referralCodeController.dispose();
    for (final controller in _vehicleControllers) {
      controller.dispose();
    }
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FastagCubit>().resetRcDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: AppColors.lightPrimaryColor,
        title: context.appText.buyFastTag,
      ),
      bottomNavigationBar:
          AppButton(
            onPressed: _isLoading ? () {} : _handlePlaceRequest,
            title: context.appText.continueText,
            style: AppButtonStyle.primary,
            isLoading: _isLoading,
          ).bottomNavigationPadding(),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildFasTagProductImageWidget(context),
            // Main Content
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildFasTagProductImageWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      color: AppColors.lightPrimaryColor,
      child: Center(
        child: Image.asset(
          AppIcons.png.fastagBuyIcon,
          height: MediaQuery.of(context).size.height * 0.09,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            ReferralAutoCompleteTextField(
              controller: _referralCodeController,
              labelText: context.appText.referralCodeOptional,
            ).paddingAll(commonSafeAreaPadding),
            15.height,

            // Vehicle Sections
            for (int i = 0; i < _vehicleControllers.length; i++) ...[
              _buildVehicleSection(i),
              const SizedBox(height: 24),
            ],

            Container(
              color: AppColors.white,
              width: double.infinity,
              padding: EdgeInsets.all(commonSafeAreaPadding),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _vehicleControllers.add(TextEditingController());
                    _vehicleVerifiedList.add(false);
                  });
                },
                child: Text(
                  '+ ${context.appText.addMoreVehicle}',
                  style: AppTextStyle.primaryColor16w400,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSection(int index) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(commonSafeAreaPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${context.appText.vehicle} ${index + 1}', style: AppTextStyle.h4),
              const Spacer(),
              if (_vehicleControllers.length > 1)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _vehicleControllers.removeAt(index);
                      _vehicleVerifiedList.removeAt(index);
                    });
                  },
                  child: const Icon(CupertinoIcons.delete, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 12),
          VehicleSelectionField(
            controller: _vehicleControllers[index],
            hintText: context.appText.selectVehicleNumber,
            index: index,
            isVerified: _vehicleVerifiedList[index],
            isVehicleAlreadySelected: false,
            onVehicleSelected: (selectedIndex, selectedVehicle) {
              final isDuplicate = _vehicleControllers.any((controller) =>
              controller.text.trim().toLowerCase() ==
                  selectedVehicle.trim().toLowerCase() &&
                  controller != _vehicleControllers[selectedIndex]);

              if (isDuplicate) {
                ToastMessages.alert(
                  message: context.appText.vehicleAlreadySelected,
                );
                return;
              }

              setState(() {
                _vehicleControllers[index].text = selectedVehicle;
                _vehicleVerifiedList[index] = true;
              });
              ToastMessages.success(message: context.appText.vehicleSelectedSuccess);
            },
            onVehicleVerified: (verifiedVehicle) {
              setState(() {
                _vehicleVerifiedList[index] = verifiedVehicle.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 16),
          Text(context.appText.vehicleRCOptional, style: AppTextStyle.textFiled),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<FastagCubit, FastagState>(
                  builder: (context, state) {
                    final cubit = context.read<FastagCubit>();

                    return Row(
                      children: [
                        Expanded(
                          child: EndhanDocumentUploadWidget(
                            feildTitle: context.appText.frontSideRC,
                            multiFilesList: state.frontRcDocuments,
                            isSingleFile: true,
                            onFilesChanged: (newList) async {
                              cubit.updateFrontRc(newList);
                              if (newList.isEmpty) {
                                cubit.setFrontRcUploaded(false);
                                return;
                              }
                              final filePath = newList.first['path'];
                              if (filePath != null) {
                                final uploadResponse = await cubit
                                    .uploadDocument(File(filePath));
                                if (uploadResponse?.data?.url != null) {
                                  cubit.updateFrontRc([
                                    {
                                      'fileName': uploadResponse!.data!.url,
                                      'path': uploadResponse.data!.url,
                                    },
                                  ]);
                                  cubit.setFrontRcUploaded(true);
                                  if (!context.mounted) return;
                                  ToastMessages.success(
                                    message: context.appText.fileUploadSuccessfully,
                                  );
                                } else {
                                  cubit.setFrontRcUploaded(false);
                                  if (!context.mounted) return;
                                  ToastMessages.alert(message: context.appText.uploadFailed,);
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: EndhanDocumentUploadWidget(
                            feildTitle: context.appText.backSideRC,
                            multiFilesList: state.backRcDocuments,
                            isSingleFile: true,
                            onFilesChanged: (newList) async {
                              cubit.updateBackRc(newList);
                              if (newList.isEmpty) {
                                cubit.setBackRcUploaded(false);
                                return;
                              }
                              final filePath = newList.first['path'];
                              if (filePath != null) {
                                final uploadResponse = await cubit
                                    .uploadDocument(File(filePath));
                                if (uploadResponse?.data?.url != null) {
                                  cubit.updateBackRc([
                                    {
                                      'fileName': uploadResponse!.data!.url,
                                      'path': uploadResponse.data!.url,
                                    },
                                  ]);
                                  cubit.setBackRcUploaded(true);
                                  if (!context.mounted) return;
                                  ToastMessages.success(
                                    message: context.appText.fileUploadSuccessfully,
                                  );
                                } else {
                                  cubit.setBackRcUploaded(false);
                                  if (!context.mounted) return;
                                  ToastMessages.alert(message: context.appText.uploadFailed);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handlePlaceRequest() {
    for (int i = 0; i < _vehicleControllers.length; i++) {
      if (_vehicleControllers[i].text.trim().isEmpty ||
          !_vehicleVerifiedList[i]) {
        ToastMessages.alert(message: '${context.appText.pleaseVerifyVehicle} ${i + 1}');
        return;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ContactAddressSheet(
            onSubmit: (addressName, address, city, state, pincode, contactNo) {
              _submitFastagRequest(
                addressName: addressName,
                address: address,
                city: city,
                state: state,
                pincode: pincode,
                contactNo: contactNo,
              );
            },
          ),
        );
      },
    );
  }

  void _submitFastagRequest({
    required String addressName,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String contactNo,
  }) async {
    setState(() => _isLoading = true);

    final cubit = context.read<FastagCubit>();

    List<Map<String, String>> vehiclesData = [
      for (int i = 0; i < _vehicleControllers.length; i++)
        {
          "vehicleNo": _vehicleControllers[i].text.trim(),
          "rcFrontPage":
              cubit.state.frontRcDocuments.isNotEmpty
                  ? cubit.state.frontRcDocuments.first['fileName']
                  : "",
          "rcBackPage":
              cubit.state.backRcDocuments.isNotEmpty
                  ? cubit.state.backRcDocuments.first['fileName']
                  : "",
        },
    ];

    final request = {
      "referralCode": _referralCodeController.text.trim(),
      "addressName": addressName,
      "address": address,
      "city": city,
      "stateName": state,
      "pincode": pincode,
      "contactNo": contactNo,
      "vehicles": vehiclesData.map((v) => v['vehicleNo']).join(","),
    };
    analyticsHelper.logEvent(AnalyticEventName.FLEET_ORDER_CREATION, request,);

    final result = await cubit.placeFastagOrder(
      referralCode: _referralCodeController.text.trim(),
      addressName: addressName,
      address: address,
      city: city,
      stateName: state,
      pincode: pincode,
      contactNo: contactNo,
      vehicles: vehiclesData,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (result is Success) {
      _showSuccessPopup(context);
    } else if (result is Error<bool>) {
      String errorMessage = context.appText.fastagRequestFailed;
      if (result.type is ErrorWithMessage) {
        errorMessage = (result.type as ErrorWithMessage).message;
      }
      // _showFailurePopup(errorMessage);
      ToastMessages.error(message: errorMessage);
    }

  }

  void _showSuccessPopup(BuildContext context) {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: context.appText.fastagRequestSubmitted,
        message: context.appText.fastagTeamReach,
        afterDismiss: () {
          context.read<FastagCubit>().resetRcDocuments();
          Navigator.pop(context);
          Navigator.pushReplacement(context, commonRoute(FastagListScreen()));
        },
      ),
    );
  }
}

class ContactAddressSheet extends StatefulWidget {
  final Function(String, String, String, String, String, String) onSubmit;

  const ContactAddressSheet({super.key, required this.onSubmit});

  @override
  State<ContactAddressSheet> createState() => _ContactAddressSheetState();
}

class _ContactAddressSheetState extends State<ContactAddressSheet> {
  final _formKey = GlobalKey<FormState>();

  final _addressNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _contactNoController = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      _addressNameController.text.trim(),
      _addressController.text.trim(),
      _cityController.text.trim(),
      _stateController.text.trim(),
      _pincodeController.text.trim(),
      _contactNoController.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.appText.contactAddress, style: AppTextStyle.h4),
                16.height,

                // Address Name
                AppTextField(
                  mandatoryStar: true,
                  controller: _addressNameController,
                  labelText: context.appText.addressName,
                  maxLength: 50,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9\s,./#-]'),
                    ),
                  ],
                  validator:
                      (value) => Validator.fieldRequired(
                        value,
                        fieldName: context.appText.addressName,
                      ),
                ),
                10.height,

                // Address
                AppTextField(
                  mandatoryStar: true,
                  controller: _addressController,
                  labelText: context.appText.address,
                  maxLength: 200,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9\s,./#-]'),
                    ),
                  ],
                  validator:
                      (value) => Validator.fieldRequired(
                        value,
                        fieldName: context.appText.address,
                      ),
                ),
                10.height,

                // City
                AppTextField(
                  mandatoryStar: true,
                  controller: _cityController,
                  labelText: context.appText.city,
                  maxLength: 20,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                  validator:
                      (value) => Validator.alphabetsOnly(
                        value,
                        fieldName: context.appText.city,
                      ),
                ),
                10.height,

                // State
                AppTextField(
                  mandatoryStar: true,
                  controller: _stateController,
                  labelText: context.appText.state,
                  maxLength: 20,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                  validator:
                      (value) => Validator.alphabetsOnly(
                        value,
                        fieldName: context.appText.state,
                      ),
                ),
                10.height,

                // Pincode
                AppTextField(
                  mandatoryStar: true,
                  controller: _pincodeController,
                  labelText: context.appText.pincode,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => Validator.pincode(value),
                ),
                10.height,

                // Contact Number
                AppTextField(
                  mandatoryStar: true,
                  controller: _contactNoController,
                  labelText: context.appText.contactNumber,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => Validator.phone(value),
                ),
                20.height,

                // Submit Button
                AppButton(
                  title: context.appText.createFastagRequest,
                  style: AppButtonStyle.primary,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
