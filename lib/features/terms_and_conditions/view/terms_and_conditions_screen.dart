import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/terms_and_conditions/bloc/terms_and_conditions_bloc.dart';
import 'package:gro_one_app/features/terms_and_conditions/model/terms_and_conditions_model.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final termsAndConditionsBloc = locator<TermsAndConditionsBloc>();

  @override
  void initState() {
    initFunction();
    super.initState();
  }


  void initFunction() => frameCallback(() async {
    termsAndConditionsBloc.add(TermsAndConditionsRequested());
  });

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: BlocBuilder<TermsAndConditionsBloc, TermsAndConditionsState>(
        builder: (context, state) {
          if (state is TermsAndCondtionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TermsAndCondtionsSuccess) {
            return buildBodyWidget(state.termsAndconditionsModel?.data ?? []);
          } else if (state is TermsAndCondtionsError) {
            return const Center(child: Text("Failed to load Terms and Conditions."));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  // appbar
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      backgroundColor: Colors.transparent,
      actions: [
        translateWiget(
          onTap: () {
            Navigator.push(
              context,
              commonRoute(ChooseLanguageScreen(isCloseButton: true)),
            );
          },
        ),
        20.width,
        customerSupportWidget(
          onTap: () {
            showCustomerCareBottomSheet(context);
          },
        ),
        20.width,
        Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
        30.width,
      ],
    );
  }
 
  // Terms and Conditions Body
  Widget buildBodyWidget(List<TermsAndConditionsDetails> termsData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Terms and Conditions",
          style: AppTextStyle.textBlackColor30w500,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: termsData.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final item = termsData[index];
              final hasTitle = (item.sectionTitle ?? '').trim().isNotEmpty;
              final hasContent = (item.content ?? '').trim().isNotEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasTitle)
                    Text(
                      "${item.sectionIdentifier ?? ''} ${item.sectionTitle ?? ''}".trim(),
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
