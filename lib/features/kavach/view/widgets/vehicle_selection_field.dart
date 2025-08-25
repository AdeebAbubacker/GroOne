import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/kavach/view/kavach_added_vehicles_bottom_sheet.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:gro_one_app/utils/app_route.dart';
import '../../../../dependency_injection/locator.dart';
import '../../repository/kavach_repository.dart';
import '../../../../data/model/result.dart';

class VehicleSelectionField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int index;
  final bool isVerified;
  final bool isVehicleAlreadySelected;
  final Function(int, String)? onVehicleSelected;
  final Function(String)? onVehicleVerified;
  final String? errorText;

  const VehicleSelectionField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.index,
    this.isVerified = false,
    this.isVehicleAlreadySelected = false,
    this.onVehicleSelected,
    this.onVehicleVerified,
    this.errorText,
  });

  @override
  State<VehicleSelectionField> createState() => _VehicleSelectionFieldState();
}

class _VehicleSelectionFieldState extends State<VehicleSelectionField> {
  bool isVerifying = false;
  final KavachRepository _repository = locator<KavachRepository>();
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text.trim();
    if (text.isEmpty && widget.isVerified) {
      // Reset verification status when text is completely cleared
      widget.onVehicleVerified?.call('');
    } else if (text.isNotEmpty && text != _previousText) {
      // Reset verification status when user manually changes the text
      widget.onVehicleVerified?.call('');
    }
    _previousText = text;
  }

  Future<void> _verifyVehicle() async {
    final vehicleNumber = widget.controller.text.trim().toUpperCase();
    if (vehicleNumber.isEmpty) {
      ToastMessages.alert(message: context.appText.pleaseEnterVehicleNumber);
      return;
    }

    setState(() => isVerifying = true);

    final result = await _repository.fetchVehicleData(vehicleNumber);

    setState(() => isVerifying = false);

    if (result is Success<Map<String, dynamic>>) {
      final data = result.value;

      // ✅ Autofill logic: truck make, model, capacity
      final makeModel = data['vehicle_make_model'] ?? data['modelNumber'];
      final capacity = data['vehicle_gross_weight'] ?? data['tonnage'];

      if (makeModel != null || capacity != null) {
        ToastMessages.success(message: "${context.appText.verified}: $makeModel, ${context.appText.capacity}: $capacity");
      }

      widget.onVehicleVerified?.call(vehicleNumber);
    } else {
      ToastMessages.alert(message: context.appText.vehicleVerificationFailed);
    }
  }


  Future<void> _openVehicleSelection() async {
    final selectedVehicle = await commonBottomSheet<String?>(
      context: context,
      screen: const KavachAddedVehiclesScreen(),
      barrierDismissible: true,
    );

    if (selectedVehicle != null) {
      // Call the callback first to check for duplicates
      widget.onVehicleSelected?.call(widget.index, selectedVehicle);
      // The parent will handle setting the controller text if no duplicates
    }
  }

  // Helper method to format vehicle number for display
  String formatVehicleNumberForDisplay(String vehicleNumber) {
    if (vehicleNumber.isEmpty) return '';
    
    // Remove any existing spaces and convert to uppercase
    String cleanNumber = vehicleNumber.replaceAll(RegExp(r'\s'), '').toUpperCase();
    
    // Format: MH12AB1234 -> MH 12 AB 1234
    if (cleanNumber.length >= 10) {
      return '${cleanNumber.substring(0, 2)} ${cleanNumber.substring(2, 4)} ${cleanNumber.substring(4, 6)} ${cleanNumber.substring(6)}';
    }
    
    // If not standard format, return as is
    return vehicleNumber.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;
    final isVerified = widget.isVerified;
    
    return Row(
      children: [
        // Text field on the left
        Expanded(
          child: Stack(
            children: [
              TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppTextStyle.textFieldHint,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
                    borderRadius: BorderRadius.circular(commonTexFieldRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
                    borderRadius: BorderRadius.circular(commonTexFieldRadius),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(commonTexFieldRadius),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(commonTexFieldRadius),
                  ),
                  errorText: widget.errorText,
                  contentPadding: EdgeInsets.only(
                    left: 12,
                    right: hasText && !isVerified ? 80 : 12, // Extra padding for verify text
                    top: 12,
                    bottom: 12,
                  ),
                ),
                inputFormatters: [
                  UpperCaseTextInputFormatter(),
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\s]')),
                ],
                onChanged: (value) {
                  // Reset verification status when text is completely cleared or changed
                  if (value.trim().isEmpty && widget.isVerified) {
                    widget.onVehicleVerified?.call('');
                  }
                },
              ),
              // Verify text positioned at left center
              if (hasText && !isVerified && !isVerifying)
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: _verifyVehicle,
                      child: Text(
                        context.appText.verify,
                        style: AppTextStyle.body3.copyWith(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              // Loading indicator positioned at right center
              if (hasText && isVerifying)
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              // Verified icon positioned at right center
              if (hasText && isVerified)
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: const Center(
                    child: Icon(Icons.verified, color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
        
        // Button on the right
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: InkWell(
            onTap: _openVehicleSelection,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor, width: 1),
                borderRadius: BorderRadius.circular(commonTexFieldRadius),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.lightBlueIconBackgroundColor2,
                    radius: 12,
                    child: SvgPicture.asset(
                      AppIcons.svg.truck,
                      width: 16,
                      height: 16,
                      colorFilter: AppColors.svg(AppColors.primaryColor),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.chevron_down,
                    color: AppColors.chevronGreyColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
     
      ],
    );
  }
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
} 