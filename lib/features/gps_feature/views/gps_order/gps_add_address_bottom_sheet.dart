import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../data/model/result.dart';
import '../../../../service/location_service.dart';
import '../../../../utils/app_bottom_sheet_body.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/constant_variables.dart';
import '../../../../utils/toast_messages.dart';
import '../../../../utils/validator.dart';
import '../../gps_order_request/gps_order_api_request.dart';
import '../../gps_order_repo/gps_order_api_repository.dart';
import '../../models/gps_document_models.dart';
import '../../../../dependency_injection/locator.dart';
import '../../../../features/login/repository/user_information_repository.dart';

class GpsAddAddressBottomSheet extends StatefulWidget {
  final String title;

  const GpsAddAddressBottomSheet({
    super.key,
    required this.title,
  });

  @override
  State<GpsAddAddressBottomSheet> createState() =>
      _GpsAddAddressBottomSheetState();
}

class _GpsAddAddressBottomSheetState
    extends State<GpsAddAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final customerNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final gstNoController = TextEditingController();
  final _locationService = LocationService();
  final _repository = locator<GpsOrderApiRepository>();

  Future<void> useMyCurrentLocation() async {
    final placemarkResult =
        await _locationService.getPlacemarkFromCurrentLocation();
    if (placemarkResult is Success<Placemark>) {
      final place = placemarkResult.value;
      setState(() {
        addressController.text = '${place.street}, ${place.subLocality}';
        cityController.text = place.locality ?? '';
        stateController.text = place.administrativeArea ?? '';
        pinCodeController.text = place.postalCode ?? '';
      });
    }else if (placemarkResult is Error) {
      final error = placemarkResult as Error;
      final errorMessage = error.type is ErrorWithMessage
          ? (error.type as ErrorWithMessage).message
          : context.appText.failedToGetLocation;
      ToastMessages.error(message: errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: widget.title,
      hideDivider: false,
      body: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          minHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: customerNameController,
                  labelText: 'Address Name',
                  maxLength: 50,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,./#-]')),
                  ],
                  validator: (value) => Validator.fieldRequired(value, fieldName: 'Customer Name'),
                ),
                10.height,
                AppTextField(
                  controller: addressController,
                  labelText: context.appText.address,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,./#-]')),
                  ],
                  maxLength: 200,
                  validator: (value) => Validator.fieldRequired(value, fieldName: context.appText.address),
                ),
                10.height,
                AppTextField(
                  controller: cityController,
                  labelText: context.appText.city,
                  maxLength: 20,
                  validator: (value) => Validator.alphabetsOnly(value, fieldName: context.appText.city),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                ),
                10.height,
                AppTextField(
                  controller: stateController,
                  labelText: context.appText.state,
                  maxLength: 20,
                  validator: (value) => Validator.alphabetsOnly(value, fieldName: context.appText.state),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                ),
                10.height,
                AppTextField(
                  controller: pinCodeController,
                  labelText: context.appText.pinCode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  validator: (value) => Validator.pincode(value),
                ),
                10.height,
                AppTextField(
                  controller: gstNoController,
                  maxLength: 15,
                  labelText:
                      '${context.appText.gstKavach} (${context.appText.optional})',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final gstRegEx = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                    if (!gstRegEx.hasMatch(value.trim().toUpperCase())) {
                      return context.appText.enterValidGstin;
                    }
                    return null;
                  },
                ),
                15.height,
                AppButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(commonButtonRadius),
                    ),
                  ),
                  onPressed: useMyCurrentLocation,
                  title: context.appText.useMyCurrentLocation,
                ),
                15.height,
                // Add extra padding at bottom to ensure buttons are visible
                20.height,
                Row(
                  children: [
                    AppButton(
                      onPressed: () => context.pop(),
                      title: context.appText.cancel,
                      style: AppButtonStyle.outline,
                    ).expand(),
                    20.width,
                    AppButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        
                        // Get customer ID from user repository
                        final userRepository = locator<UserInformationRepository>();
                        final customerId = await userRepository.getUserID();
                        
                        if (customerId == null || customerId.isEmpty) {
                          ToastMessages.error(message: 'Unable to get customer ID');
                          return;
                        }

                        final request = GpsAddAddressRequest(
                          customerId: customerId,
                          addrName: customerNameController.text.trim(),
                          addr: addressController.text.trim(),
                          city: cityController.text.trim(),
                          state: stateController.text.trim(),
                          pincode: pinCodeController.text.trim(),
                          isDefault: true,
                          addrType: "1", // Default to general address type
                          country: "India",
                          gstIn: gstNoController.text.trim(),
                        );

                        print('🔍 GPS Add Address Request:');
                        print('  - Customer ID: $customerId');
                        print('  - Address Name: ${customerNameController.text.trim()}');
                        print('  - Address: ${addressController.text.trim()}');
                        print('  - City: ${cityController.text.trim()}');
                        print('  - State: ${stateController.text.trim()}');
                        print('  - Pincode: ${pinCodeController.text.trim()}');
                        print('  - Address Type: ${request.addrType}');
                        print('  - GST: ${gstNoController.text.trim()}');

                        final result = await _repository.addGpsAddress(request);
                        
                        print('🔍 GPS Add Address API Response:');
                        print('  - Result type: ${result.runtimeType}');
                        
                        if (result is Success) {
                          final response = (result as Success<GpsAddAddressResponse>).value;
                          print('  - Success response: $response');
                          print('  - Response success: ${response.success}');
                          print('  - Response message: ${response.message}');
                          print('  - Response data: ${response.data}');
                          print('  - Response data ID: ${response.data?.id}');
                          print('  - Response data address name: ${response.data?.addressName}');
                          Navigator.of(context).pop();
                          ToastMessages.success(message: context.appText.addressAddedSuccess);
                        } else if (result is Error<GpsAddAddressResponse>) {
                          print('  - Error response: ${result.type}');
                          print('  - Error type: ${result.type.runtimeType}');
                          if (result.type is ErrorWithMessage) {
                            print('  - Error message: ${(result.type as ErrorWithMessage).message}');
                          }
                          final errorMessage = result.type is ErrorWithMessage
                              ? (result.type as ErrorWithMessage).message
                              : 'Failed to add address';
                          ToastMessages.error(message: errorMessage);
                        }
                      },
                      title: context.appText.submit,
                      style: AppButtonStyle.primary,
                    ).expand(),
                  ],
                ),
                // Add extra padding at bottom for keyboard
                20.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
} 