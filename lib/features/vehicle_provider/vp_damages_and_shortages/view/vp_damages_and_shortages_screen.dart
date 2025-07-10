import 'package:flutter/material.dart';

import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_file_dropper.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class VpDamagesAndShortagesScreen extends StatefulWidget {
  const VpDamagesAndShortagesScreen({super.key});

  @override
  State<VpDamagesAndShortagesScreen> createState() =>
      _VpDamagesAndShortagesScreenState();
}

class _VpDamagesAndShortagesScreenState
    extends State<VpDamagesAndShortagesScreen> {
  String selectedFileName = "";
  TextEditingController itemName = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {});

  void disposeFunction() => frameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.damagesAndShortages),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            // Item Name
            AppTextField(
              controller: itemName,
              labelText: context.appText.itemName,

              hintText: "LED TV 42”",
            ),

            // Quantity
            AppTextField(
              controller: quantity,
              labelText: context.appText.quantity,

              hintText: "2",
            ),

           // Prodcut Photo
            AppFilePickerField(labelText: "Product Photo", mandatoryStar: true),
            
            // Description
            AppTextField(
              controller: description,
              labelText: context.appText.description,
              hintText: context.appText.tvCrackedScreenNote,
            ),

            // Submit Button
            AppButton(
              title: "Submit",
              isLoading: false,
              style: AppButtonStyle.primary,
              onPressed: () {},
            ),
            20.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appText.damagesRecorded,
                  style: AppTextStyle.body1.copyWith(color: Color(0xFF2B2B2B)),
                ),
                10.height,
                damageRecordCard(
                  imageUrl: "https://via.placeholder.com/150",
                  itemName: "LED TV 42”",
                  quantity: "2",
                  description: "One TV has a cracked screen",
                  onDelete: () {},
                ),
                20.height,
                damageRecordCard(
                  imageUrl: "https://via.placeholder.com/150",
                  itemName: "LED TV 42”",
                  quantity: "2",
                  description: "One TV has a cracked screen",
                  onDelete: () {},
                ),
                20.height,
                damageRecordCard(
                  imageUrl: "https://via.placeholder.com/150",
                  itemName: "LED TV 42”",
                  quantity: "2",
                  description: "One TV has a cracked screen",
                  onDelete: () {},
                ),
              ],
            ),

            // Verify Button
            20.height,
          ],
        ),
      ),
    );
  }

  detailWidget({required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: AppTextStyle.textGreyDetailColor14w400),
        Text(text2, style: AppTextStyle.textGreyDetailColor14w400),
      ],
    );
  }

// Damages record card
  Widget damageRecordCard({
    required String imageUrl,
    required String itemName,
    required String quantity,
    required String description,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 100,
      child: Row(
        children: [
          // Left-side Image with only left corners rounded
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Container(
              width: 90,
              height: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 20,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    itemName,
                    style: AppTextStyle.textBlackColor12w400.copyWith(
                      color: const Color(0xFF2B2B2B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Quantity: $quantity",
                    style: AppTextStyle.textGreyColor10w400,
                  ),
                  Text(description, style: AppTextStyle.textGreyColor10w400),
                ],
              ),
            ),
          ),

          // Delete button
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AppIconButton(
              onPressed: onDelete,
              icon: AppIcons.svg.delete,
              iconColor: AppColors.activeRedColor,
            ),
          ),
        ],
      ),
    );
  }
}
