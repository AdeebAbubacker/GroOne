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
import '../../../data/model/result.dart';
import '../../../service/location_service.dart';
import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/constant_variables.dart';
import '../../../utils/toast_messages.dart';
import '../../../utils/validator.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_bloc.dart';
import '../bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_event.dart';
import '../bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_state.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_event.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_event.dart';
// Import GPS dependencies for GPS feature support
import '../../gps_feature/gps_order_request/gps_order_api_request.dart';
import '../../gps_feature/gps_order_repo/gps_order_api_repository.dart';
import '../../gps_feature/models/gps_document_models.dart';
import '../../../dependency_injection/locator.dart';
import '../../login/repository/user_information_repository.dart';

enum AddressFeature { kavach, gps }

class KavachAddAddressBottomSheet extends StatefulWidget {
  final int addrType;
  final String title;
  final AddressFeature feature;
  final VoidCallback? onAddressAdded; // Callback for GPS feature

  const KavachAddAddressBottomSheet({
    super.key,
    required this.addrType,
    required this.title,
    this.feature = AddressFeature.kavach,
    this.onAddressAdded,
  });

  @override
  State<KavachAddAddressBottomSheet> createState() =>
      _KavachAddAddressBottomSheetState();
}

class _KavachAddAddressBottomSheetState
    extends State<KavachAddAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final addressNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final gstNoController = TextEditingController();
  final _locationService = LocationService();
  
  // GPS-specific dependencies
  late final GpsOrderApiRepository _gpsRepository;
  late final UserInformationRepository _userRepository;

  @override
  void initState() {
    super.initState();
    if (widget.feature == AddressFeature.gps) {
      _gpsRepository = locator<GpsOrderApiRepository>();
      _userRepository = locator<UserInformationRepository>();
    }
  }

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

  Future<void> _submitAddress() async {
    if (!formKey.currentState!.validate()) return;

    if (widget.feature == AddressFeature.kavach) {
      // Use Kavach API
      final request = KavachAddAddressApiRequest(
        addressName: addressNameController.text.trim(),
        addr1: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pinCodeController.text.trim(),
        addrType: widget.addrType,
        country: "India",
        gstIn: gstNoController.text.trim(),
      );
      context.read<KavachCheckoutAddAddressBloc>().add(
        AddKavachAddress(request),
      );
    } else if (widget.feature == AddressFeature.gps) {
      // Use GPS API
      try {
        final customerId = await _userRepository.getUserID();
        if (customerId == null || customerId.isEmpty) {
          ToastMessages.error(message: context.appText.unableToGetCustomerId);
          return;
        }

        final request = GpsAddAddressRequest(
          customerId: customerId,
          addrName: addressNameController.text.trim(),
          addr: addressController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          pincode: pinCodeController.text.trim(),
          isDefault: true,
          addrType: widget.addrType.toString(), // Convert int to string
          country: "India",
          gstIn: gstNoController.text.trim(),
        );

        final result = await _gpsRepository.addGpsAddress(request);
        
        if (result is Success) {
          Navigator.of(context).pop();
          ToastMessages.success(message: context.appText.addressAddedSuccess);
          
          // Call the callback to refresh addresses
          if (widget.onAddressAdded != null) {
            widget.onAddressAdded!();
          }
        } else if (result is Error<GpsAddAddressResponse>) {
          final errorMessage = result.type is ErrorWithMessage
              ? (result.type as ErrorWithMessage).message
              : context.appText.failedToAddAddress;
          ToastMessages.error(message: errorMessage);
        }
      } catch (e) {
        ToastMessages.error(message: context.appText.failedToAddAddress);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBottomSheetBody(
      title: widget.title,
      hideDivider: false,
      body: widget.feature == AddressFeature.kavach
          ? BlocListener<KavachCheckoutAddAddressBloc, KavachCheckoutAddAddressState>(
              listener: (context, state) {
                if (state is KavachCheckoutAddressAdded) {
                  Navigator.of(context).pop();
                  ToastMessages.success(message: context.appText.addressAddedSuccess);
                  
                  // Refresh both billing and shipping address lists after successful addition
                  Future.delayed(Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      // Refresh billing addresses
                      context.read<KavachCheckoutBillingAddressBloc>().add(FetchKavachBillingAddresses());
                      // Refresh shipping addresses
                      context.read<KavachCheckoutShippingAddressBloc>().add(FetchKavachShippingAddresses());
                    }
                  });
                } else if (state is KavachCheckoutAddressError) {
                  ToastMessages.error(message: state.error);
                }
              },
              child: _buildBody(context: context),
            )
          : _buildBody(context: context),
    )
 );
  }

  Widget _buildBody({required BuildContext context}) {
    return Container(
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
                mandatoryStar: true,
                controller: addressNameController,
                labelText: context.appText.addressName,
                maxLength: 50,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,./#-]')),
                ],
                validator: (value) => Validator.fieldRequired(value,fieldName: context.appText.addressName),
              ),
              10.height,
              AppTextField(
                mandatoryStar: true,
                controller: addressController,
                labelText: context.appText.address,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,./#-]')),
                ],
                maxLength: 200,
                validator: (value) => Validator.fieldRequired(value,fieldName: context.appText.address),
              ),
              10.height,
              AppTextField(
                mandatoryStar: true,
                controller: cityController,
                labelText: context.appText.city,
                maxLength: 20,
                validator: (value) => Validator.alphabetsOnly(value,fieldName: context.appText.city),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
              ),
              10.height,
              AppTextField(
                mandatoryStar: true,
                controller: stateController,
                labelText: context.appText.state,
                maxLength: 20,
                validator: (value) => Validator.alphabetsOnly(value,fieldName: context.appText.state),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
              ),
              10.height,
              AppTextField(
                mandatoryStar: true,
                controller: pinCodeController,
                labelText: context.appText.pincode,
                maxLength: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
                    onPressed: _submitAddress,
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
    );
  }
}
