import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class DriverSettlementsScreen extends StatefulWidget {
  const DriverSettlementsScreen({super.key});

  @override
  State<DriverSettlementsScreen> createState() =>
      _DriverSettlementsScreenState();
}

class _DriverSettlementsScreenState extends State<DriverSettlementsScreen> {
  TextEditingController noOfDays = TextEditingController();
  TextEditingController detentionAmount = TextEditingController();
  TextEditingController loadingAmount = TextEditingController();
  TextEditingController unloadingAmount = TextEditingController();
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
      appBar: CommonAppBar(title: context.appText.settlements),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            headingText(text: context.appText.detentions),

            // No. of Days
            AppTextField(
              controller: noOfDays,
              labelText: context.appText.noOfDays,
              hintText: "3",
            ),

            // Amount
            AppTextField(
              controller: detentionAmount,
              labelText: context.appText.amount,
              hintText: "2000",
            ),
            2.height,
            headingText(text: context.appText.loadingCharges),

            // Amount
            AppTextField(
              controller: loadingAmount,
              labelText: context.appText.amount,
              hintText: "2000",
            ),

            headingText(text: context.appText.unloadingCharges),

            // Amount
            AppTextField(
              controller: unloadingAmount,
              labelText: context.appText.amount,
              hintText: "2000",
            ),

            5.height,
            // Verify Button
            AppButton(
              title: "Submit",
              isLoading: false,
              style: AppButtonStyle.primary,
              onPressed: () {},
            ),
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
}
