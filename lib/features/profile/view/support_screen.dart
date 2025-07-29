import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/view/widgets/add_new_support_ticket.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class LpSupport extends StatefulWidget {
  const LpSupport({super.key, this.showBackButton = true});
  final bool showBackButton;

  @override
  State<LpSupport> createState() => _LpSupportState();
}

class _LpSupportState extends State<LpSupport> {
  int selectedTabIndex = 0;

  TextEditingController searchController = TextEditingController();
  final profileCubit = locator<ProfileCubit>();


  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(() async {
    await profileCubit.fetchFaq();
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.support,
        scrolledUnderElevation: 0,
        leading: SizedBox(),
          actions: [
            GestureDetector(
              onTap: () {
                commonSupportDialog(context, message: context.appText.callCustomerSupportSubtitle);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(AppImage.png.customerSupport, height: 28),
              ),
            )
          ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  toggleButton(context.appText.faqs, 0),
                  12.width,
                  toggleButton(context.appText.tickets, 1),
                ],
              ),
              18.height,

              AppSearchBar(searchController: searchController),

              18.height,

              // FAQ Cards
              if (selectedTabIndex == 0)
                BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final uiState = state.faqUIState;

                      if (uiState == null || uiState.status == Status.LOADING) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (uiState.status == Status.ERROR) {
                        ToastMessages.error(message: getErrorMsg(errorType: uiState.errorType ?? GenericError()));
                      }

                      final faqList = uiState.data?.faqs ?? [];


                  return Expanded(
                    child: ListView.separated(
                      itemCount: faqList.length,
                      separatorBuilder: (_, __) => 12.height,
                      itemBuilder: (context, index) {
                        final faq = faqList[index];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.lightGrey200)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                faq.question,
                                style: AppTextStyle.body2,
                              ),
                              6.height,
                              Divider(color: AppColors.borderColor),
                              6.height,
                              Text(
                                faq.answer,
                                style: AppTextStyle.body4.copyWith(color: AppColors.textGreyDetailColor),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                })
              else
                Expanded(
                  child: Column(
                    children: [
                      // 10.height,
                      Expanded(
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (_, index) {
                            final isCompleted = index % 2 == 0;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.lightGrey200)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ticket ID & Status
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Ticket #2024-CS123",
                                          style: AppTextStyle.h5),
                                      20.width,
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isCompleted ? "Completed" : "Pending",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isCompleted ? Colors.green : Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  commonDivider(height: 20),
                                  4.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Payment not Received",
                                          style: AppTextStyle.body3.copyWith(color: AppColors.textGreyDetailColor)),
                                      4.height,
                                      Text("27-04-25, 12:34 AM",
                                          style: AppTextStyle.body4.copyWith(color: AppColors.thinLightGray)),
                                    ],
                                  ),

                                  8.height,
                                  Text(
                                    "The invoice number is [#12345] and it’s due for payment on [15/03/2023]. I would be grateful if you could confirm that everything is on track for payment.",
                                    style: AppTextStyle.body4.copyWith(color: AppColors.thinLightGray),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      AppButton(onPressed: () {
                        Navigator.push(context, commonRoute(AddNewTicketScreen()));
                      }, title: context.appText.createNewTicket)
                    ],
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }

  Widget toggleButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : AppColors.greyContainerBg,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : AppColors.textGreyDetailColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
