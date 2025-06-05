import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/toast_messages.dart';
import '../api_request/kavach_add_address_api_request.dart';
import '../bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_bloc.dart';
import '../bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_event.dart';
import '../bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_state.dart';

class KavachAddAddressBottomSheet extends StatefulWidget { // Renamed for generality
  final int addrType; // 1 for shipping, 2 for billing
  final String title; // To set "Shipping Address" or "Billing Address"

  const KavachAddAddressBottomSheet({
    super.key,
    required this.addrType,
    required this.title,
  });

  @override
  State<KavachAddAddressBottomSheet> createState() => _KavachAddAddressBottomSheetState();
}

class _KavachAddAddressBottomSheetState extends State<KavachAddAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final customerNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: widget.title, // Use the passed title
      body: BlocListener<KavachCheckoutAddAddressBloc, KavachCheckoutAddAddressState>(
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
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: customerNameController,
              hintText: context.appText.name,
              validator: (value) => value == null || value.trim().isEmpty ? 'Name is required' : null,
            ),
            10.height,
            AppTextField(
              controller: mobileNoController,
              hintText: context.appText.mobileNumber,
              maxLength: 10,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
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
              validator: (value) => value == null || value.trim().isEmpty ? 'Address Line 1 is required' : null,
            ),
            10.height,
            AppTextField(
              controller: addressLine2Controller,
              hintText: '${context.appText.addressLine} 2',
              validator: (value) => value == null || value.trim().isEmpty ? 'Address Line 2 is required' : null,
            ),
            10.height,
            AppTextField(
              controller: cityController,
              hintText: context.appText.city,
              validator: (value) => value == null || value.trim().isEmpty ? 'City is required' : null,
            ),
            10.height,
            AppTextField(
              controller: stateController,
              hintText: context.appText.state,
              validator: (value) => value == null || value.trim().isEmpty ? 'State is required' : null,
            ),
            10.height,
            AppTextField(
              controller: pinCodeController,
              hintText: context.appText.pinCode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
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
            30.height,
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
                      customerName: customerNameController.text,
                      mobileNumber: mobileNoController.text,
                      addr1: addressLine1Controller.text,
                      addr2: addressLine2Controller.text,
                      city: cityController.text,
                      state: stateController.text,
                      pincode: pinCodeController.text,
                      addrType: widget.addrType, // Use the passed addrType
                    );
                    context.read<KavachCheckoutAddAddressBloc>().add(AddKavachAddress(request));
                  },
                  title: context.appText.submit,
                  style: AppButtonStyle.primary,
                ).expand()
              ],
            ),
          ],
        ),
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
