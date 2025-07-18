import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_multiline_textfield.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class FeedbackWidget extends StatefulWidget {
  final String loadId;

  const FeedbackWidget({super.key, required this.loadId});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  final lpLoadCubit = locator<LpLoadCubit>();
  final TextEditingController feedbackController = TextEditingController();
  final FocusNode feedbackFocusNode = FocusNode();

  @override
  void dispose() {
    feedbackController.dispose();
    feedbackFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LpLoadCubit, LpLoadState>(
      builder: (context, state) {
        final loadData = state.lpLoadById?.data?.data;
        if (loadData == null) return const SizedBox();

        if (feedbackController.text != loadData.notes) {
          feedbackController.text = loadData.notes;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${context.appText.feedback} / ${context.appText.remarks}",
                  style: AppTextStyle.body3.copyWith(
                    color: AppColors.textBlackColor,
                    fontSize: 14,
                  ),
                ),
                AppButton(
                  buttonHeight: 35,
                  title: state.isFeedbackAdded == false
                      ? context.appText.add
                      : context.appText.update,
                  style: AppButtonStyle.outlineShrink,
                  textStyle: AppTextStyle.buttonPrimaryColorTextColor,
                  onPressed: () async {
                    if (feedbackController.text.isNotEmpty) {
                      feedbackFocusNode.unfocus();
                      await lpLoadCubit.updateFeedback(
                        loadId: widget.loadId,
                        feedback: feedbackController.text,
                      );
                    }
                  },
                ),
              ],
            ),
            10.height,

            /// Multiline TextField
            AppMultilineTextField(
              controller: feedbackController,
              focusNode: feedbackFocusNode,
              hintText: context.appText.enterRemarks,
              onChanged: (val) {
                lpLoadCubit.updateFeedbackText(val);
              },
            ),
          ],
        );
      },
    );
  }
}

