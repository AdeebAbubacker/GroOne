import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import '../../../../utils/app_bottom_sheet_body.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';

class GpsAddAddressBottomSheet extends StatefulWidget {
  final String addrType; // "1" for shipping, "2" for billing
  final String title;

  const GpsAddAddressBottomSheet({
    super.key,
    required this.addrType,
    required this.title,
  });

  @override
  State<GpsAddAddressBottomSheet> createState() => _GpsAddAddressBottomSheetState();
}

class _GpsAddAddressBottomSheetState extends State<GpsAddAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController addressNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  bool isDefault = false;
  bool isLoading = false;

  @override
  void dispose() {
    addressNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    gstinController.dispose();
    super.dispose();
  }

  Future<void> _addAddress() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Get customerId from user repository
      final userInfoRepo = locator<UserInformationRepository>();
      final customerId = await userInfoRepo.getUserID() ?? '';
      
      if (customerId.isEmpty) {
        ToastMessages.alert(message: 'Customer ID not found');
        return;
      }

      final request = GpsAddAddressRequest(
        customerId: customerId,
        addrName: addressNameController.text.trim(),
        addr: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        isDefault: isDefault,
        addrType: widget.addrType,
        country: 'India',
        gstIn: gstinController.text.trim().isNotEmpty ? gstinController.text.trim() : null,
      );

      final repository = locator<GpsOrderApiRepository>();
      final result = await repository.addGpsAddress(request);

      if (result is Success) {
        ToastMessages.success(message: 'Address added successfully');
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ToastMessages.alert(message: 'Failed to add address');
      }
    } catch (e) {
      ToastMessages.alert(message: 'Error adding address: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: widget.title,
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: addressNameController,
              labelText: 'Address Name',
              mandatoryStar: true,
              validator: (value) => Validator.fieldRequired(value, fieldName: 'Address Name'),
            ),
            15.height,
            AppTextField(
              controller: addressController,
              labelText: 'Address',
              mandatoryStar: true,
              maxLines: 3,
              validator: (value) => Validator.fieldRequired(value, fieldName: 'Address'),
            ),
            15.height,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: cityController,
                    labelText: 'City',
                    mandatoryStar: true,
                    validator: (value) => Validator.fieldRequired(value, fieldName: 'City'),
                  ),
                ),
                10.width,
                Expanded(
                  child: AppTextField(
                    controller: stateController,
                    labelText: 'State',
                    mandatoryStar: true,
                    validator: (value) => Validator.fieldRequired(value, fieldName: 'State'),
                  ),
                ),
              ],
            ),
            15.height,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: pincodeController,
                    labelText: 'Pincode',
                    mandatoryStar: true,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => Validator.pincode(value),
                  ),
                ),
                10.width,
                Expanded(
                  child: AppTextField(
                    controller: gstinController,
                    labelText: 'GSTIN (Optional)',
                    maxLength: 15,
                  ),
                ),
              ],
            ),
            15.height,
            Row(
              children: [
                Checkbox(
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value ?? false;
                    });
                  },
                ),
                Text(
                  'Set as default address',
                  style: AppTextStyle.textFiled,
                ),
              ],
            ),
            20.height,
            AppButton(
              title: isLoading ? 'Adding...' : 'Add Address',
              onPressed: isLoading ? (){} : _addAddress,
              style: AppButtonStyle.primary,
            ),
            20.height,
          ],
        ),
      ),
    );
  }
} 