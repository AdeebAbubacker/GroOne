import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_dialog.dart';
import 'fastag_list_screen.dart';

class BuyNewFastagScreen extends StatefulWidget {
  const BuyNewFastagScreen({super.key});

  @override
  State<BuyNewFastagScreen> createState() => _BuyNewFastagScreenState();
}

class _BuyNewFastagScreenState extends State<BuyNewFastagScreen> {
  final TextEditingController _vehicleNumberController = TextEditingController();
  bool _isLoading = false;

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
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                style: AppButtonStyle.circularIconButtonStyle,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'NETC',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.orange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'FASTag',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppTextField(
              controller: _vehicleNumberController,
              hintText: 'TN18 AB 5468',
            ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // IDFC Bank Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'IDFC\nFIRST\nBank',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Text
          const Expanded(
            child: Text(
              'Issued by IDFC Bank',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          
          // Info Icon
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey,
            ),
          ),
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
    AppDialog.show(
      context,
       child: SuccessDialogView(
          heading: 'FASTag Request \nSubmitted Successfully!',
          message: 'Our Team will reach out in 48 hrs',
          afterDismiss: () {
            Navigator.push(context, commonRoute(FastagListScreen()));
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
