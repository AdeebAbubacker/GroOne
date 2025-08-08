import 'package:flutter/cupertino.dart';
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
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';
import '../../../routing/app_route_name.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_image.dart';
import 'fastag_list_screen.dart';
import '../../kavach/view/widgets/vehicle_selection_field.dart';
import '../../../utils/toast_messages.dart';

class BuyNewFastagScreen extends StatefulWidget {
  const BuyNewFastagScreen({super.key});

  @override
  State<BuyNewFastagScreen> createState() => _BuyNewFastagScreenState();
}

class _BuyNewFastagScreenState extends State<BuyNewFastagScreen> {
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  bool _isLoading = false;
  final bool _isVehicleVerified = false;

  final TextEditingController _referralCodeController = TextEditingController();
  final List<TextEditingController> _vehicleControllers = [TextEditingController()];
  final List<bool> _vehicleVerifiedList = [false];


  // @override
  // void dispose() {
  //   _vehicleNumberController.dispose();
  //   super.dispose();
  // }
  @override
  void dispose() {
    _referralCodeController.dispose();
    for (final controller in _vehicleControllers) {
      controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: AppColors.lightPrimaryColor,
        title: 'Buy New FASTag',
      ),
      bottomNavigationBar:
          AppButton(
            onPressed: _isLoading ? () {} : _handlePlaceRequest,
            title: 'Continue',
            style: AppButtonStyle.primary,
            isLoading: _isLoading,
          ).bottomNavigationPadding(),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildFasTagProductImageWidget(context),
            // Main Content
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildFasTagProductImageWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      color: AppColors.lightPrimaryColor,
      child: Center(
        child: Image.asset(
          AppIcons.png.fastagBuyIcon,
          height: MediaQuery.of(context).size.height * 0.09,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Container(
              color: AppColors.white,
              padding: EdgeInsets.all(commonSafeAreaPadding),
              child: AppTextField(
                labelText: 'Referral Code (Optional)',
                controller: _referralCodeController,
                hintText: 'Enter referral code',
              )
            ),
            15.height,

            // Vehicle Sections
            for (int i = 0; i < _vehicleControllers.length; i++) ...[
              _buildVehicleSection(i),
              const SizedBox(height: 24),
            ],

            Container(
              color: AppColors.white,
              width: double.infinity,
              padding: EdgeInsets.all(commonSafeAreaPadding),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _vehicleControllers.add(TextEditingController());
                    _vehicleVerifiedList.add(false);
                  });
                },
                child: Text(
                  '+ Add more Vehicle',
                  style: AppTextStyle.primaryColor16w400
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSection(int index) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(commonSafeAreaPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Vehicle ${index + 1}', style: AppTextStyle.h4),
              const Spacer(),
              if (_vehicleControllers.length > 1)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _vehicleControllers.removeAt(index);
                      _vehicleVerifiedList.removeAt(index);
                    });
                  },
                  child: const Icon(CupertinoIcons.delete, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 12),
          VehicleSelectionField(
            controller: _vehicleControllers[index],
            hintText: context.appText.selectVehicleNumber,
            index: index,
            isVerified: _vehicleVerifiedList[index],
            isVehicleAlreadySelected: false,
            onVehicleSelected: (selectedIndex, selectedVehicle) {
              setState(() {
                _vehicleControllers[index].text = selectedVehicle;
                _vehicleVerifiedList[index] = true;
              });
              ToastMessages.success(message: 'Vehicle selected successfully');
            },
            onVehicleVerified: (verifiedVehicle) {
              setState(() {
                _vehicleVerifiedList[index] = verifiedVehicle.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 16),
          Text('Vehicle RC (optional)', style:AppTextStyle.textFiled),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildUploadBox('Front Side of RC')),
              const SizedBox(width: 12),
              Expanded(child: _buildUploadBox('Back Side of RC')),
            ],
          ),
        ],
      ),
    );
  }



  // Widget _buildContent() {
  //   return SingleChildScrollView(
  //     padding: EdgeInsets.all(commonSafeAreaPadding),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Vehicle Number Section
  //         _buildSectionTitle('Vehicle Number'),
  //         const SizedBox(height: 8),
  //
  //         // Vehicle Selection Field
  //         VehicleSelectionField(
  //           controller: _vehicleNumberController,
  //           hintText: context.appText.selectVehicleNumber,
  //           index: 0,
  //           isVerified: _isVehicleVerified,
  //           isVehicleAlreadySelected: false,
  //           onVehicleSelected: (selectedIndex, selectedVehicle) {
  //             setState(() {
  //               _vehicleNumberController.text = selectedVehicle;
  //               _isVehicleVerified = true;
  //             });
  //             ToastMessages.success(message: 'Vehicle selected successfully');
  //           },
  //           onVehicleVerified: (verifiedVehicle) {
  //             setState(() {
  //               _isVehicleVerified = verifiedVehicle.isNotEmpty;
  //             });
  //           },
  //         ),
  //
  //         const SizedBox(height: 24),
  //
  //         // Vehicle RC Section
  //         _buildSectionTitle('Vehicle RC (optional)'),
  //         const SizedBox(height: 8),
  //         Row(
  //           children: [
  //             Expanded(child: _buildUploadBox('Front Side of RC')),
  //             const SizedBox(width: 12),
  //             Expanded(child: _buildUploadBox('Back Side of RC')),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 24),
  //
  //         // Issued by IDFC Bank Section
  //         _buildIdfcSection(),
  //       ],
  //     ),
  //   );
  // }


  Widget _buildUploadBox(String label) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: commonContainerDecoration(borderColor: AppColors.borderColor,color: AppColors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyle.bodyGreyColor,
            textAlign: TextAlign.center,
          ),
          5.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload, color: AppColors.primaryColor, size: 24),
              5.width,
              Text(
                'Upload',
                style: AppTextStyle.primaryColor12w400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void _handlePlaceRequest() async {
  //   // Validate vehicle selection
  //   if (_vehicleNumberController.text.trim().isEmpty) {
  //     ToastMessages.alert(message: 'Please select a vehicle');
  //     return;
  //   }
  //
  //   if (!_isVehicleVerified) {
  //     ToastMessages.alert(message: 'Please verify the vehicle number');
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  //
  //   // Show success popup by default
  //   _showSuccessPopup(context);
  // }

  void _handlePlaceRequest() async {
    // Validate all vehicle numbers
    for (int i = 0; i < _vehicleControllers.length; i++) {
      final vehicleNumber = _vehicleControllers[i].text.trim();
      final isVerified = _vehicleVerifiedList[i];

      if (vehicleNumber.isEmpty) {
        ToastMessages.alert(message: 'Please enter vehicle number for Vehicle ${i + 1}');
        return;
      }

      if (!isVerified) {
        ToastMessages.alert(message: 'Please verify Vehicle ${i + 1}');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

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
          // if (currentContext.mounted) {
          //      GoRouter.of(currentContext).go(AppRouteName.fastagList);
          // }
          Navigator.pop(context);
          Navigator.push(context, commonRoute(FastagListScreen()));
        },
      ),
    );
  }

  void _showFailurePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                20.height,
                AppIconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icons.close,
                ).align(Alignment.topRight),
                10.height,
                Text(
                  'FASTag Request',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.h3.copyWith(
                    color: AppColors.activeRedColor,
                    fontSize: 25,
                  ),
                ),
                10.height,
                Text(
                  'Unsuccessful!',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.h3.copyWith(
                    color: AppColors.activeRedColor,
                    fontSize: 25,
                  ),
                ),
                20.height,
                Text(
                  'Loreum ipsum dolor sit amet',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyGreyColor,
                ),
                20.height,
              ],
            ),
          ),
    );
  }
}
