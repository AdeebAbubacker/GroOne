import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class LegalDetailScreen extends StatelessWidget {
  final String type; // 'terms' or 'privacy'

  const LegalDetailScreen({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTerms = type == 'terms';
    final title = isTerms ? "Terms and Conditions" : "Privacy Policy";

    final List<String> terms = [
      'You must be at least 13 years old to use this app.',
      'You agree not to misuse the app in any unlawful or prohibited way.',
      'The app is provided "as is" without warranties of any kind.',
      'We reserve the right to update these terms at any time without prior notice.',
      'You are responsible for maintaining the confidentiality of your account information.',
      'We may suspend or terminate your access if you violate any of these terms.',
      'All content and materials in the app are the property of the company and protected by intellectual property laws.',
      'You agree not to reverse engineer, decompile, or otherwise attempt to extract the source code of the app.',
    ];

    final List<String> privacy = [
      'We collect only the data necessary for app functionality.',
      'Your data is never sold or shared with third parties.',
      'We use industry-standard encryption to protect your data.',
      'You may request your data to be deleted at any time.',
      'Some features require permissions like location or camera access.',
      'We comply with all applicable data privacy laws and regulations.',
    ];

    final List<String> content = isTerms ? terms : privacy;

    return Scaffold(
      appBar: CommonAppBar(
        // title: title,
        backgroundColor: Colors.transparent,
        actions: [
          translateWiget(onTap: () {   Navigator.push(context, commonRoute(ChooseLanguageScreen(isCloseButton: true,)));}),
          20.width,
          customerSupportWidget(
            onTap: () {
              showCustomerCareBottomSheet(context);
            },
          ),
          20.width,
          Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
          30.width,
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.textBlackColor30w500,
            ),
            20.height,
            ...content.asMap().entries.map(
                  (entry) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}. ',
                      style: AppTextStyle.textBlackColor16w400,
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTextStyle.textBlackColor16w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.height,
            Text(
              "For full legal information, please visit our website.",
              style: AppTextStyle.textGreyColor14w400,
            ),
          ],
        ),
      ),
    );
  }
}
