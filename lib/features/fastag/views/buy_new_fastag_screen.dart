import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';
import '../../../routing/app_route_name.dart';
import '../../../utils/app_dialog.dart';
import 'fastag_list_screen.dart';
import '../../kavach/view/widgets/vehicle_selection_field.dart';
import '../../../utils/toast_messages.dart';

class BuyNewFastagScreen extends StatefulWidget {
  const BuyNewFastagScreen({super.key});

  @override
  State<BuyNewFastagScreen> createState() => _BuyNewFastagScreenState();
}

class _BuyNewFastagScreenState extends State<BuyNewFastagScreen> {
  final TextEditingController _vehicleNumberController = TextEditingController();
  bool _isLoading = false;
  bool _isVehicleVerified = false;

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: _buildContent(),
              ),
            ),
            
            // Bottom Button
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFE9F3FA), // Light blue background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Back Button
              AppIconButton(
                onPressed: () => Navigator.pop(context),
                icon:  Icon(Icons.arrow_back_ios, color: AppColors.black),
              ),
              
              const SizedBox(width: 16),
              
              // Title
              const Expanded(
                child: Text(
                  'Buy New FASTag',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(width: 40), // Balance for back button
            ],
          ),
          
          const SizedBox(height: 12),
          
          // NETC Logo
          Image.asset(AppIcons.png.fastagNetcIcon),

          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Number Section
          _buildSectionTitle('Vehicle Number'),
          const SizedBox(height: 8),
          
          // Vehicle Selection Field
          VehicleSelectionField(
            controller: _vehicleNumberController,
            hintText: context.appText.selectVehicleNumber,
            index: 0,
            isVerified: _isVehicleVerified,
            isVehicleAlreadySelected: false,
            onVehicleSelected: (selectedIndex, selectedVehicle) {
              setState(() {
                _vehicleNumberController.text = selectedVehicle;
                _isVehicleVerified = true;
              });
              ToastMessages.success(message: 'Vehicle selected successfully');
            },
            onVehicleVerified: (verifiedVehicle) {
              setState(() {
                _isVehicleVerified = verifiedVehicle.isNotEmpty;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Vehicle RC Section
          _buildSectionTitle('Vehicle RC (optional)'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildUploadBox('Front Side of RC'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUploadBox('Back Side of RC'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Issued by IDFC Bank Section
          _buildIdfcSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildUploadBox(String label) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.upload,
            color: AppColors.primaryColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            'Upload',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIdfcSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // IDFC Bank Logo
          Container(
            width: 40,
            height: 40,
           
            child: Image.asset(AppIcons.png.fastagIdfcIcon,
           ),
          ),
          
          const SizedBox(width: 12),
          
          // Text
          Text(
              'Issued by IDFC Bank',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          SizedBox(width: 10),
          // Info Icon
           Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey,
            )
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: AppButton(
        onPressed: _isLoading ? (){} : _handlePlaceRequest,
        title: 'Place FASTag Request',
        style: AppButtonStyle.primary,
        isLoading: _isLoading,
      ),
    );
  }

  void _handlePlaceRequest() async {
    // Validate vehicle selection
    if (_vehicleNumberController.text.trim().isEmpty) {
      ToastMessages.alert(message: 'Please select a vehicle');
      return;
    }

    if (!_isVehicleVerified) {
      ToastMessages.alert(message: 'Please verify the vehicle number');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success popup by default
    _showSuccessPopup(context);
  }

  void _showSuccessPopup(BuildContext context) {
    final currentContext = context;
    AppDialog.show(
      context,
       child: SuccessDialogView(
          heading: 'FASTag Request \nSubmitted Successfully!',
          message: 'Our Team will reach out in 48 hrs',
          afterDismiss: () {
          if (currentContext.mounted) {
               GoRouter.of(currentContext).go(AppRouteName.fastagList);
          }
          
           // Navigator.push(context, commonRoute(FastagListScreen()));
          },
        ),
    );
  }
 
  void _showFailurePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            20.height,
            AppIconButton(onPressed: ()=> Navigator.of(context).pop(), icon: Icons.close).align(Alignment.topRight),
            10.height,
            Text('FASTag Request', textAlign: TextAlign.center, style: AppTextStyle.h3.copyWith(color: AppColors.activeRedColor, fontSize: 25)),
            10.height,
            Text('Unsuccessful!', textAlign: TextAlign.center, style: AppTextStyle.h3.copyWith(color: AppColors.activeRedColor, fontSize: 25)),
            20.height,
            Text('Loreum ipsum dolor sit amet', textAlign: TextAlign.center, style: AppTextStyle.bodyGreyColor),
            20.height,
          ],
        ),
      ),
    );
  }
}
