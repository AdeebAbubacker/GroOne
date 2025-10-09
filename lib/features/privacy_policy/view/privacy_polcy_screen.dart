import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/privacy_policy/bloc/privacy_policy_bloc.dart';
import 'package:gro_one_app/features/privacy_policy/model/privacy_policy_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
   final privacyPolicyBloc = locator<PrivacyPolicyBloc>();

  @override
  void initState() {
    initFunction();
    super.initState();
  }


  void initFunction() => frameCallback(() async {
    privacyPolicyBloc.add(PrivacyPolicyRequested());
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonOnboardingAppbar(),
      body: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
        builder: (context, state) {
          if (state is PrivacyPolicyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrivacyPolicySuccess) {
            return buildBodyWidget(state.privacyDetailsModel?.data ?? []);
          } else if (state is PrivacyPolicyError) {
            return  Center(child: Text(context.appText.failedToLoadPrivacyPolicy));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  // Privacy Policy Body
  Widget buildBodyWidget(List<PrivacyPolicyDetails> privacyData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.appText.privacyPolicy.upperCaseWords,
          style: AppTextStyle.textBlackColor30w500,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: privacyData.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final item = privacyData[index];
              final hasTitle = (item.title ?? '').trim().isNotEmpty;
              final hasContent = (item.content ?? '').trim().isNotEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasTitle)
                    Text(
                      item.title!,
                      style: AppTextStyle.textBlackColor16w500,
                    ),
                  if (hasContent)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Html(
                        data: item.content ?? '',
                        style: {
                          'body': Style.fromTextStyle(
                        AppTextStyle.textBlackColor14w400.copyWith(
                       fontSize: 14,
                       fontWeight: FontWeight.w400,
                       color: AppTextStyle.textBlackColor14w400.color,
                         ),
                        ),
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
 }
}