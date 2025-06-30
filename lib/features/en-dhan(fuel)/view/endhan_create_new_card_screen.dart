import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/view/endhan_card_screen.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/view/endhan_new_user_and_card_screen.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_with_icon.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/mobile_number_text_filed.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/app_button_style.dart';

class EndhanCreateNewCardScreen extends StatelessWidget {
  const EndhanCreateNewCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = locator<EnDhanCubit>();

    return BlocConsumer<EnDhanCubit, EnDhanState>(
      bloc: cubit,
      listener: (context, state) {
        // Handle any state changes if needed
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backGroundBlue,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Header with blue background, title, and card image
                    Container(
                      width: double.infinity,
                      decoration: commonContainerDecoration(
                        color: const Color(0xFFD6EEFB),
                      ),
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        children: [
                          CommonAppBar(
                            title: "NEW eN-Dhan Card Request",
                            backgroundColor: Color(0xFFD6EEFB),),
                          8.height,
                          Image.asset(AppImage.png.endhanCard, width: 140, height: 90),
                          8.height,
                        ],
                      ),
                    ),

                   
                    const Text(
                      'Virtual Card', 
                    style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)
                    ).paddingSymmetric(horizontal: 20, vertical: 20),

                    // Billing Address Card
                    Container(
                       padding: const EdgeInsets.all(16),
                      decoration: commonContainerDecoration(
                        color: Colors.white,
                        shadow: true
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Billing Address', style: TextStyle(fontWeight: FontWeight.bold)),
                          12.height,
                          AppTextField(
                            hintText: 'Customer Name', 
                            onChanged: (value) => cubit.setCustomerName(value),
                          ),
                          12.height,
                          AppTextField(
                            hintText: 'Mobile Number', 
                            keyboardType: TextInputType.phone,
                            onChanged: (value) => cubit.setMobile(value),
                          ),
                          12.height,
                          AppTextField(
                            hintText: 'Address Line 1', 
                            onChanged: (value) => cubit.setAddress1(value),
                          ),
                          12.height,
                          AppTextField(
                            hintText: 'Address Line 2', 
                            onChanged: (value) => cubit.setAddress2(value),
                          ),
                          12.height,
                          AppTextField(
                            hintText: 'Pincode', 
                            keyboardType: TextInputType.number,
                            onChanged: (value) => cubit.setPincode(value),
                          ),
                          16.height,
                          const Text('Shipping Address (optional)', style: TextStyle(fontWeight: FontWeight.w500)),
                          8.height,
                          Row(
                            children: [
                              Checkbox(
                                value: state.saveAsShipping,
                                activeColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) => cubit.setSaveAsShipping(val ?? true),
                              ),
                              const Text('Same as Shipping Address', style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          if (!state.saveAsShipping)
                            AppTextField(
                              labelText: 'Shipping Address', 
                              onChanged: (value) => cubit.setShippingAddress(value),
                            ),
                        ],
                      ),
                    ),

                    10.height,
                    // Card Forms
                    ...state.cards.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cardData = entry.value;
                      return Container(
                         padding: const EdgeInsets.all(16),
                        decoration: commonContainerDecoration(
                          color: Colors.white,
                          shadow: true
                        ),
                        child: _CardForm(
                          key: ValueKey('card_form_$index'),
                          cardData: cardData,
                          index: index,
                          onRemove: state.cards.length > 1 ? () => cubit.removeCard(index) : null,
                          onUpdate: (updatedCardData) => cubit.updateCard(index, updatedCardData),
                        ),
                      );
                    }).toList(),

                    8.height,  

                    // Add Card button
                    Container(
                      decoration: commonContainerDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4), 
                      child: InkWell(
                        onTap: () => cubit.addCard(),
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          children: [
                            const Icon(Icons.add, color: AppColors.primaryColor),
                            6.width,
                            Text('Add Card', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),

                    8.height, 
                    // Regional Office & Address Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: commonContainerDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        shadow: true,

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Regional Office', style: TextStyle(fontWeight: FontWeight.bold)),
                          10.height,
                          AppTextField(
                            hintText: 'Regional Office', 
                            readOnly: true,
                            onChanged: (value) => cubit.setRegionalOffice(value),
                          ),
                          16.height,
                          const Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                          10.height,
                          AppTextField(
                            hintText: 'Address Line 1', 
                            readOnly: true,
                            onChanged: (value) => cubit.setRoAddress1(value),
                          ),
                          10.height,
                          AppTextField(
                            hintText: 'Address Line 2', 
                            readOnly: true,
                            onChanged: (value) => cubit.setRoAddress2(value),
                          ),
                          10.height,
                          AppTextField(
                            hintText: 'State', 
                            readOnly: true,
                            onChanged: (value) => cubit.setRoState(value),
                          ),
                          10.height,
                          AppTextField(
                            hintText: 'District', 
                            readOnly: true,
                            onChanged: (value) => cubit.setRoDistrict(value),
                          ),
                        ],
                      ),
                    ),
                    80.height, // For bottom button spacing
                  ],
                ),
                // Sticky bottom button
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: AppColors.backGroundBlue,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: AppButton(
                      title: 'Create Cards',
                      onPressed: () => _showSuccessDialog(context),
                      style: cubit.isCardCreationFormValid() ? AppButtonStyle.primary : AppButtonStyle.disableButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showSuccessDialogWithButton(
      context, 
      onTap: (){
         Navigator.pushReplacement(context,commonRoute(EndhanNewUserAndCardScreen()));
      },
      text: "Card Created!",
      subheading:"eN-Dhan Digital Card Created Successfully",
     );
  }
}

class _CardForm extends StatelessWidget {
  final CardFormData cardData;
  final int index;
  final VoidCallback? onRemove;
  final Function(CardFormData) onUpdate;

  const _CardForm({
    super.key, 
    required this.cardData, 
    required this.index, 
    this.onRemove,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Card ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Spacer(),
            if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onRemove,
              ),
          ],
        ),
        12.height,
        AppTextField(
          labelText: 'Vehicle Number', 
          onChanged: (value) => onUpdate(cardData.copyWith(vehicleNumber: value)),
        ),
        12.height,
        AppDropdown(
          labelText: 'Vehicle Type',
          dropdownValue: cardData.vehicleType,
          dropDownList: [
            const DropdownMenuItem(value: 'Select', child: Text('Select')),
            const DropdownMenuItem(value: 'Truck', child: Text('Truck')),
            const DropdownMenuItem(value: 'Tanker', child: Text('Tanker')),
            const DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (val) => onUpdate(cardData.copyWith(vehicleType: val)),
        ),
        12.height,
        AppTextField(
          labelText: 'VIN Number', 
          onChanged: (value) => onUpdate(cardData.copyWith(vinNumber: value)),
        ),
        12.height,
        AppTextField(
          labelText: 'Mobile Number', 
          keyboardType: TextInputType.phone,
          onChanged: (value) => onUpdate(cardData.copyWith(mobile: value)),
        ),
        12.height,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('RC document', style: TextStyle(fontWeight: FontWeight.w500)),
            SvgPicture.asset(AppIcons.svg.vahanVerify, height: 30, width: 24),
          ],
        ),
        
        10.height,

        // File row with edit/delete icons
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: commonContainerDecoration(
            color: AppColors.backGroundBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                cardData.rcDocuments.isNotEmpty ? cardData.rcDocuments[0]['fileName'] : '',
                style: const TextStyle(fontSize: 15),
              ).expand(),
              Icon(Icons.edit, color: AppColors.primaryColor, size: 18),
              8.width,
              Icon(Icons.delete, color: Colors.red, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}