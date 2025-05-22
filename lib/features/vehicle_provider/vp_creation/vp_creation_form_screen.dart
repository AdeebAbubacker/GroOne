import 'package:flutter/material.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/widgets/multi_picker_selection.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/aadhaar_input_formatter.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';

class VpCreationFormScreen extends StatefulWidget {
  const VpCreationFormScreen({super.key});

  @override
  State<VpCreationFormScreen> createState() => _VpCreationFormScreenState();
}

class _VpCreationFormScreenState extends State<VpCreationFormScreen> {

  final nameTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final companyNameTextController = TextEditingController();
  final ownedTruckTextController = TextEditingController();
  final attachedTruckTextController = TextEditingController();
  final aadhaarNumberTextController = TextEditingController();

  List<dynamic> multiFilesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.createAccount),
      body: SafeArea(
        child: Column(
          children: [
            buildNameAndPhoneNumberWidget(),
            30.height,

            buildBusinessDetailsWidget(context),
            30.height,

            buildBusinessProofWidget(),
            30.height,

            buildSubmitButton()
          ],
        ).withScroll(padding: EdgeInsets.all(commonSafeAreaPadding)),
      ),
    );
  }

  // Name and Phone Number
  Widget buildNameAndPhoneNumberWidget(){
    return Column(
      children: [
        // Name
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: nameTextController,
          labelText: context.appText.name,
          hintText: "${context.appText.enter} ${context.appText.name}",
        ),
        20.height,

        // Phone Number
        AppTextField(
          validator: (value)=> Validator.phone(value),
          controller: phoneNumberTextController,
          labelText: context.appText.phoneNumber,
          maxLength: 10,
          inputFormatters: [phoneNumberInputFormatter],
          decoration: commonInputDecoration(
            hintText: "${context.appText.enter} ${context.appText.phoneNumber}",
            prefixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImage.png.flag),
                10.width,
                Text("+91", style: AppTextStyle.textBlackColor16w400),
              ],
            ).paddingOnly(left: 20, right: 5),
          ),
        )
      ],
    );
  }

  // Business Details
  Widget buildBusinessDetailsWidget(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.businessName, style: AppTextStyle.body1PrimaryColor),
        20.height,

        // Company Name
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: companyNameTextController,
          labelText: context.appText.companyName,
          hintText: "${context.appText.enter} ${context.appText.companyName}",
        ),
        20.height,

        // TrucK Type
        MultiPickerSelection(labelText: context.appText.truckType, hintText: ""),
        20.height,

        // Owned Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: ownedTruckTextController,
          labelText: context.appText.ownedTrucks,
          hintText: "${context.appText.enter} ${context.appText.ownedTrucks}",
        ),
        20.height,

        // Attached Truck
        AppTextField(
          validator: (value)=> Validator.fieldRequired(value),
          controller: attachedTruckTextController,
          labelText: context.appText.attachedTrucks,
          hintText: "${context.appText.enter} ${context.appText.attachedTrucks}",
        ),
        20.height,

        // TrucK Type
        MultiPickerSelection(labelText: context.appText.preferredLanes, hintText: ""),
      ],
    );
  }


  Widget buildBusinessProofWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.businessProof, style: AppTextStyle.body1PrimaryColor),
        20.height,

        UploadAttachmentFiles(
          multiFilesList: multiFilesList,
          title: context.appText.uploadRC,
          isSingleFile: true,
        ),
        20.height,

        // Aadhaar Number
        AppTextField(
          controller: aadhaarNumberTextController,
          labelText: context.appText.aadhaarNumber,
          hintText:  context.appText.aadhaarHint,
          inputFormatters: [
            AadhaarInputFormatter(),
          ],
        ),
      ],
    );
  }

  Widget buildSubmitButton(){
    return AppButton(title: context.appText.submit);
  }

}
