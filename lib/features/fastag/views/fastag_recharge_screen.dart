import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_route.dart';
import 'fastag_list_screen.dart';

class FastagRechargeScreen extends StatefulWidget {
  const FastagRechargeScreen({super.key});

  @override
  State<FastagRechargeScreen> createState() => _FastagRechargeScreenState();
}

class _FastagRechargeScreenState extends State<FastagRechargeScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedAmount = '1000';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '₹1000';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // FASTag Details Card
                    _buildFastagDetailsCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Add Amount Section
                    _buildAddAmountSection(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Recharge Button
            _buildRechargeButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return CommonAppBar(
      title: const Text('Recharge'),
      centreTile: true,
    );
  }

  Widget _buildFastagDetailsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID
          Text(
            'ID - 8387123010',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Vehicle Information Row
          Row(
            children: [
              // IDFC Icon
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'IDFC',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Vehicle Number
              const Text(
                'TN12 BD 1234',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddAmountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Add Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Amount Input Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: AppTextField(
              controller: _amountController,
              hintText: '₹1000',
              keyboardType: TextInputType.number,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Select Buttons
          Row(
            children: [
              Expanded(
                child: _buildQuickSelectButton('₹1000', '1000'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickSelectButton('₹2000', '2000'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickSelectButton('₹5000', '5000'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSelectButton(String text, String value) {
    final isSelected = _selectedAmount == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAmount = value;
          _amountController.text = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.primaryColor : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRechargeButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: AppButton(
        onPressed: _isLoading ? (){} : _handleRecharge,
        title: 'Recharge ₹200',
        style: AppButtonStyle.primary,
        isLoading: _isLoading,
      ),
    );
  }

  void _handleRecharge() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success popup
    _showSuccessPopup();
  }

  void _showSuccessPopup() {
    AppDialog.show(
      context,
      child :SuccessDialogView(
          heading: 'Recharge Successful',
          message: 'FASTag Recharge Completed Successfully',
          afterDismiss: (){
            Navigator.pop(context);
            Navigator.push(context, commonRoute(FastagListScreen()));
          },
        ),
    );
  }
}