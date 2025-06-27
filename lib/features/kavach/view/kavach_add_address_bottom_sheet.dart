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

class KavachAddAddressBottomSheet extends StatefulWidget {
  final int addrType;
  final String title;

  const KavachAddAddressBottomSheet({
    super.key,
    required this.addrType,
    required this.title,
  });

  @override
  State<KavachAddAddressBottomSheet> createState() =>
      _KavachAddAddressBottomSheetState();
}

class _KavachAddAddressBottomSheetState
    extends State<KavachAddAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  // final customerNameController = TextEditingController();
  // final mobileNoController = TextEditingController();
  final addressNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final gstNoController = TextEditingController();
  // final countryController = TextEditingController();
  final _locationService = LocationService();

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
      title: widget.title, // Use the passed title
      hideDivider: false,
      body: BlocListener<KavachCheckoutAddAddressBloc, KavachCheckoutAddAddressState>(
        listener: (context, state) {
          if (state is KavachCheckoutAddressAdded) {
            Navigator.of(context).pop();
            ToastMessages.success(message: context.appText.addressAddedSuccess);
          } else if (state is KavachCheckoutAddressError) {
            ToastMessages.error(message: state.error);
          }
        },
        child: _buildBody(context: context),
      ),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: addressNameController,
                labelText: context.appText.addressName,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,./#-]')),
                ],
                validator: (value) => Validator.fieldRequired(value,fieldName: context.appText.addressName),
              ),
              10.height,
              AppTextField(
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
                controller: cityController,
                labelText: context.appText.city,
                validator: (value) => Validator.alphabetsOnly(value,fieldName: context.appText.city),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],

              ),
              10.height,
              AppTextField(
                controller: stateController,
                labelText: context.appText.state,
                validator: (value) => Validator.alphabetsOnly(value,fieldName: context.appText.state),
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
                labelText:
                    '${context.appText.gstKavach} (${context.appText.optional})',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final gstRegEx = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                  if (!gstRegEx.hasMatch(value.trim().toUpperCase())) {
                    return  context.appText.enterValidGstin;
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
              Row(
                children: [
                  AppButton(
                    onPressed: () => context.pop(),
                    title: context.appText.cancel,
                    style: AppButtonStyle.outline,
                  ).expand(),
                  20.width,
                  AppButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      final request = KavachAddAddressApiRequest(
                        addr1: addressNameController.text.trim(),
                        addr2: addressController.text.trim(),
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
                    },
                    title: context.appText.submit,
                    style: AppButtonStyle.primary,
                  ).expand(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
