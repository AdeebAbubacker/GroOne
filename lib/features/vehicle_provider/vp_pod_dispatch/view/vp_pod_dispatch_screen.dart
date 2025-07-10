import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class VpPodDispatchScreen extends StatefulWidget {
  const VpPodDispatchScreen({super.key});

  @override
  State<VpPodDispatchScreen> createState() => _VpPodDispatchScreenState();
}

class _VpPodDispatchScreenState extends State<VpPodDispatchScreen> {
  String? companyTypeDropDownValue;
  TextEditingController courierCompany = TextEditingController();
  TextEditingController awbNumber = TextEditingController();
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
      appBar: CommonAppBar(title: context.appText.podDispatch),
      body: Padding(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            // Courier Company
            AppTextField(
              controller: courierCompany,
              labelText: context.appText.courierCompany,
              hintText: "LED TV 42”",
            ),
            // AWB Number
            AppTextField(
              controller: awbNumber,
              labelText: context.appText.awbNumber,

              hintText: "54678765436898",
            ),

            orDivider(),
            AppDropdown(
              labelText: context.appText.podCenter,
              hintText: context.appText.selectCompanyType,
              dropdownValue: companyTypeDropDownValue,
              decoration: commonInputDecoration(fillColor: Colors.white),
              dropDownList: [
                DropdownMenuItem(
                  value: '1',
                  child: Text('Private Limited', style: AppTextStyle.body),
                ),
                DropdownMenuItem(
                  value: '2',
                  child: Text('Partnership', style: AppTextStyle.body),
                ),
                DropdownMenuItem(
                  value: '3',
                  child: Text('Sole Proprietorship', style: AppTextStyle.body),
                ),
              ],
              onChanged: (onChangeValue) {
                setState(() {
                  companyTypeDropDownValue = onChangeValue;
                });
              },
            ),
            Spacer(),
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
 // Or Divider
  Widget orDivider() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            context.appText.or,
            style: AppTextStyle.textGreyDetailColor14w400.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF003CFF),
              ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2,
          color: Color(0xFF003CFF),
          ),
        ),
      ],
    );
  }
}
