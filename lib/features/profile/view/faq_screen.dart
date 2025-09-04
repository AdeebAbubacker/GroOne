import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key, required this.searchController});

  final profileCubit = locator<ProfileCubit>();
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final uiState = state.faqUIState;

        if (uiState == null || uiState.status == Status.LOADING) {
          return CircularProgressIndicator().center().expand();
        }

        if (uiState.status == Status.ERROR) {
          return genericErrorWidget(error: uiState.errorType, onRefresh: () => profileCubit.fetchFaq()).expand();
        }

        final faqList = uiState.data?.data?.data ?? [];

        final isSearching = searchController.text.isNotEmpty;

        if (faqList.isEmpty) {
          final message =
          isSearching
              ? context.appText.noSearchResults
              : context.appText.noFAQFound;
          return Text(message).center().expand();
        }

        return Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                context.read<ProfileCubit>().fetchFaq(loadMore: true);
              }
              return false;
            },
            child: ListView.separated(
              itemCount: faqList.length,
              separatorBuilder: (_, __) => 12.height,
              itemBuilder: (context, index) {
                final faq = faqList[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: commonContainerDecoration(
                    borderColor: AppColors.lightGrey200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(faq.question, style: AppTextStyle.body2),
                      6.height,
                      Divider(color: AppColors.borderColor),
                      6.height,
                      Text(
                        faq.answer,
                        style: AppTextStyle.body4.copyWith(
                          color: AppColors.textGreyDetailColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
