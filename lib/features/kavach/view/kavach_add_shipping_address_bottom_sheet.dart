import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../data/model/result.dart';
import '../../../service/location_service.dart';
import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/constant_variables.dart';
import '../../../utils/toast_messages.dart';
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
  final customerNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final gstNoController = TextEditingController();
  final countryController = TextEditingController();
  final _locationService = LocationService();

  Future<void> useMyCurrentLocation() async {
    final placemarkResult =
        await _locationService.getPlacemarkFromCurrentLocation();
    if (placemarkResult is Success<Placemark>) {
      final place = placemarkResult.value;
      setState(() {
        addressLine1Controller.text = place.street ?? '';
        addressLine2Controller.text = place.subLocality ?? '';
        cityController.text = place.locality ?? '';
        stateController.text = place.administrativeArea ?? '';
        pinCodeController.text = place.postalCode ?? '';
        countryController.text = place.country ?? '';
      });
    }else if (placemarkResult is Error) {
      final error = placemarkResult as Error;
      final errorMessage = error.type is ErrorWithMessage
          ? (error.type as ErrorWithMessage).message
          : "Failed to get location.";
      ToastMessages.error(message: errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: widget.title, // Use the passed title
      body: BlocListener<
        KavachCheckoutAddAddressBloc,
        KavachCheckoutAddAddressState
      >(
        listener: (context, state) {
          if (state is KavachCheckoutAddressAdded) {
            Navigator.of(context).pop();
            ToastMessages.success(message: 'Address added successfully!');
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
      height: 500.h,
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: customerNameController,
                      hintText: context.appText.name,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Name is required'
                                  : null,
                    ),
                    10.height,
                    AppTextField(
                      controller: mobileNoController,
                      hintText: context.appText.mobileNumber,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mobile number is required';
                        } else if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        } else if (value.startsWith('0')) {
                          return 'Mobile number should not start with 0';
                        }
                        return null;
                      },
                    ),
                    10.height,
                    AppTextField(
                      controller: addressLine1Controller,
                      hintText: '${context.appText.addressLine} 1',
                      maxLength: 200,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Address Line 1 is required'
                                  : null,
                    ),
                    10.height,
                    AppTextField(
                      controller: addressLine2Controller,
                      hintText: '${context.appText.addressLine} 2',
                      maxLength: 200,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Address Line 2 is required'
                                  : null,
                    ),
                    10.height,
                    AppTextField(
                      controller: cityController,
                      hintText: context.appText.city,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'City is required'
                                  : null,
                    ),
                    10.height,
                    AppTextField(
                      controller: stateController,
                      hintText: context.appText.state,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'State is required'
                                  : null,
                    ),
                    10.height,
                    AppTextField(
                      controller: countryController,
                      hintText: 'Country',
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Country is required'
                                  : null,
                    ),
                    10.height,
                    AppTextField(
                      controller: pinCodeController,
                      hintText: context.appText.pinCode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 6,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pincode is required';
                        } else if (value.length != 6) {
                          return 'Pincode must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    10.height,
                    AppTextField(
                      controller: gstNoController,
                      hintText:
                          '${context.appText.gstKavach} (${context.appText.optional})',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }

                        final gstRegEx = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                        if (!gstRegEx.hasMatch(value.trim().toUpperCase())) {
                          return 'Enter valid GSTIN';
                        }

                        return null;
                      },
                    ),
                    15.height,
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(commonButtonRadius),
                        ),
                      ),
                      onPressed: useMyCurrentLocation,
                      label: Text(
                        context.appText.useMyCurrentLocation,
                        style: AppTextStyle.bodyWhiteColorW500,
                      ),
                      icon: Icon(Icons.my_location, color: AppColors.white),
                    ),
                    40.height,
                  ],
                ),
              ),
            ),
          ),
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
                    customerName: customerNameController.text.trim(),
                    mobileNumber: mobileNoController.text.trim(),
                    addr1: addressLine1Controller.text.trim(),
                    addr2: addressLine2Controller.text.trim(),
                    city: cityController.text.trim(),
                    state: stateController.text.trim(),
                    pincode: pinCodeController.text.trim(),
                    addrType: widget.addrType,
                    country: countryController.text.trim(),
                    gstIn: gstNoController.text.trim()
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
    );
  }
}
// class KavachAddShippingAddressBottomSheet extends StatefulWidget {
//   const KavachAddShippingAddressBottomSheet({super.key});
//
//   @override
//   State<KavachAddShippingAddressBottomSheet> createState() => _KavachAddShippingAddressBottomSheetState();
// }
//
// class _KavachAddShippingAddressBottomSheetState extends State<KavachAddShippingAddressBottomSheet> {
//   final formKey = GlobalKey<FormState>();
//   final customerNameController = TextEditingController();
//   final mobileNoController = TextEditingController();
//   final addressLine1Controller = TextEditingController();
//   final addressLine2Controller = TextEditingController();
//   final cityController = TextEditingController();
//   final stateController = TextEditingController();
//   final pinCodeController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBottomSheetBody(
//       title: context.appText.shippingAddress,
//       body: BlocListener<KavachCheckoutAddAddressBloc, KavachCheckoutAddAddressState>(
//         listener: (context, state) {
//           if (state is KavachCheckoutAddressAdded) {
//             // Address successfully added
//             Navigator.of(context).pop(); // Close the bottom sheet
//             ToastMessages.success(message: 'Address added successfully!'); // Optional: Show a success toast
//
//           } else if (state is KavachCheckoutAddressError) {
//             ToastMessages.error(message: state.error); // Show error message
//           }
//         },
//         child: _buildBody(context: context),
//       ),
//     );
//   }
//
//   Widget _buildBody({required BuildContext context}){
//     return Form(
//       key: formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppTextField(
//               controller: customerNameController,
//               hintText: context.appText.name,
//               validator: (value) => value == null || value.trim().isEmpty ? 'Name is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: mobileNoController,
//               hintText: context.appText.mobileNumber,
//               maxLength: 10,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Mobile number is required';
//                 } else if (value.length != 10) {
//                   return 'Mobile number must be 10 digits';
//                 } else if (value.startsWith('0')) {
//                   return 'Mobile number should not start with 0';
//                 }
//                 return null;
//               },
//             ),
//             10.height,
//             AppTextField(
//               controller: addressLine1Controller,
//               hintText: '${context.appText.addressLine} 1',
//               validator: (value) => value == null || value.trim().isEmpty ? 'Address Line 1 is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: addressLine2Controller,
//               hintText: '${context.appText.addressLine} 2',
//               validator: (value) => value == null || value.trim().isEmpty ? 'Address Line 2 is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: cityController,
//               hintText: context.appText.city,
//               validator: (value) => value == null || value.trim().isEmpty ? 'City is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: stateController,
//               hintText: context.appText.state,
//               validator: (value) => value == null || value.trim().isEmpty ? 'State is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: pinCodeController,
//               hintText: context.appText.pinCode,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               maxLength: 6,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Pincode is required';
//                 } else if (value.length != 6) {
//                   return 'Pincode must be 6 digits';
//                 }
//                 return null;
//               },
//             ),
//             10.height,
//
//             30.height,
//             Row(
//               children: [
//                 AppButton(
//                   onPressed: ()=> context.pop(),
//                   title: context.appText.cancel,
//                   style: AppButtonStyle.outline,
//                 ).expand(),
//                 20.width,
//                 AppButton(
//                   onPressed: (){
//                     if(!formKey.currentState!.validate())return;
//                     final request = KavachAddAddressApiRequest(
//                       customerName: customerNameController.text,
//                       mobileNumber: mobileNoController.text,
//                       addr1: addressLine1Controller.text,
//                       addr2: addressLine2Controller.text,
//                       city: cityController.text,
//                       state: stateController.text,
//                       pincode: pinCodeController.text,
//                       addrType: 1,
//                     );
//
//                     context.read<KavachCheckoutAddAddressBloc>().add(AddKavachAddress(request));
//                   },
//                   title: context.appText.submit,
//                   style: AppButtonStyle.primary,
//                 ).expand()
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }

// class KavachAddShippingAddressBottomSheet extends StatefulWidget {
//   const KavachAddShippingAddressBottomSheet({super.key});
//
//   @override
//   State<KavachAddShippingAddressBottomSheet> createState() => _KavachAddShippingAddressBottomSheetState();
// }
//
// class _KavachAddShippingAddressBottomSheetState extends State<KavachAddShippingAddressBottomSheet> {
//   final formKey = GlobalKey<FormState>();
//   final customerNameController = TextEditingController();
//   final mobileNoController = TextEditingController();
//   final addressLine1Controller = TextEditingController();
//   final addressLine2Controller = TextEditingController();
//   final cityController = TextEditingController();
//   final stateController = TextEditingController();
//   final pinCodeController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBottomSheetBody(
//       title: context.appText.shippingAddress,
//       body: _buildBody(context: context),
//     );
//   }
//
//   Widget _buildBody({required BuildContext context}){
//     return Form(
//       key: formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppTextField(
//               controller: customerNameController,
//               hintText: context.appText.name,
//               validator: (value) => value == null || value.trim().isEmpty ? 'Name is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: mobileNoController,
//               hintText: context.appText.mobileNumber,
//               maxLength: 10,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Mobile number is required';
//                 } else if (value.length != 10) {
//                   return 'Mobile number must be 10 digits';
//                 } else if (value.startsWith('0')) {
//                   return 'Mobile number should not start with 0';
//                 }
//                 return null;
//               },
//             ),
//             10.height,
//             AppTextField(
//               controller: addressLine1Controller,
//               hintText: '${context.appText.addressLine} 1',
//               validator: (value) => value == null || value.trim().isEmpty ? 'Address Line 1 is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: addressLine2Controller,
//               hintText: '${context.appText.addressLine} 2',
//               validator: (value) => value == null || value.trim().isEmpty ? 'Address Line 2 is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: cityController,
//               hintText: context.appText.city,
//               validator: (value) => value == null || value.trim().isEmpty ? 'City is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: stateController,
//               hintText: context.appText.state,
//               validator: (value) => value == null || value.trim().isEmpty ? 'State is required' : null,
//             ),
//             10.height,
//             AppTextField(
//               controller: pinCodeController,
//               hintText: context.appText.pinCode,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               maxLength: 6,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Pincode is required';
//                 } else if (value.length != 6) {
//                   return 'Pincode must be 6 digits';
//                 }
//                 return null;
//               },
//             ),
//             10.height,
//
//             30.height,
//             Row(
//               children: [
//                 AppButton(
//                   onPressed: ()=> context.pop(),
//                   title: context.appText.cancel,
//                   style: AppButtonStyle.outline,
//                 ).expand(),
//                 20.width,
//                 AppButton(
//                   onPressed: (){
//                     if(!formKey.currentState!.validate())return;
//                     final request = KavachAddAddressApiRequest(
//                       customerName: customerNameController.text,
//                       mobileNumber: mobileNoController.text,
//                       addr1: addressLine1Controller.text,
//                       addr2: addressLine2Controller.text,
//                       city: cityController.text,
//                       state: stateController.text,
//                       pincode: pinCodeController.text,
//                       addrType: 1,
//                     );
//
//                     context.read<KavachCheckoutAddAddressBloc>().add(AddKavachAddress(request));
//                   },
//                   title: context.appText.submit,
//                   style: AppButtonStyle.primary,
//                 ).expand()
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
