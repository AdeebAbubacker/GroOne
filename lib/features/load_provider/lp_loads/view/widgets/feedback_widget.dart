import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
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

  bool _isEditing = false; // tracks if user clicked edit
  bool _hasSavedFeedback = false; // tracks if feedback already exists

  @override
  void initState() {
    super.initState();
    final loadData = lpLoadCubit.state.lpLoadById?.data?.data;
    if (loadData != null && loadData.notes.isNotEmpty) {
      feedbackController.text = loadData.notes;
      _hasSavedFeedback = true;
    }
  }

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
        final isEditable = state.isFeedBackUpdatble;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${context.appText.feedback} / ${context.appText.remarks}",
                  style: AppTextStyle.h4,
                ),
                // Edit icon only if feedback exists and not editing
                if (_hasSavedFeedback && !_isEditing)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                      lpLoadCubit.emit(state.copyWith(isFeedBackUpdatble: true));
                    },
                    icon: SvgPicture.asset(
                      AppIcons.svg.edit,
                      color: AppColors.black,
                    ),
                    splashRadius: 20,
                  ),
              ],
            ),
            20.height,

            AppTextField(
              maxLines: 5,
              decoration: commonInputDecoration(
                fillColor: (_hasSavedFeedback && !_isEditing)
                    ? AppColors.lightGreyColor
                    : AppColors.white,
              ),
              readOnly: _hasSavedFeedback && !_isEditing,
              enabled: !_hasSavedFeedback || _isEditing,
              controller: feedbackController,
              currentFocus: feedbackFocusNode,
              hintText: context.appText.enterRemarks,
              inputFormatters: [LengthLimitingTextInputFormatter(240)],
            ),
            20.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Add button: only when no feedback exists
                if (!_hasSavedFeedback)
                  AppButton(
                    buttonHeight: 35,
                    title: context.appText.add,
                    style: AppButtonStyle.outlineShrink,
                    textStyle: AppTextStyle.buttonPrimaryColorTextColor,
                    onPressed: () async {
                      feedbackFocusNode.unfocus();
                      await lpLoadCubit.updateFeedback(
                        loadId: widget.loadId,
                        feedback: feedbackController.text,
                      );
                      setState(() {
                        _hasSavedFeedback = true;
                        _isEditing = false;
                      });
                    },
                  ),

                // Update button: only when editing existing feedback
                if (_hasSavedFeedback && _isEditing)
                  AppButton(
                    buttonHeight: 35,
                    title: context.appText.update,
                    style: AppButtonStyle.outlineShrink,
                    textStyle: AppTextStyle.buttonPrimaryColorTextColor,
                    onPressed: () async {
                      feedbackFocusNode.unfocus();
                      await lpLoadCubit.updateFeedback(
                        loadId: widget.loadId,
                        feedback: feedbackController.text,
                      );
                      setState(() {
                        _isEditing = false;
                      });
                      lpLoadCubit.emit(state.copyWith(isFeedBackUpdatble: false));
                    },
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
