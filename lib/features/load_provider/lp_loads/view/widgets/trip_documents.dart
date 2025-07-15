import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/app_icons.dart';

class TripDocuments extends StatelessWidget {
  final String docName;
  final String docUrl;
  final String docId;
  final DateTime docDateTime;
  final String downloadKey;

  const TripDocuments({
    super.key,
    required this.docName,
    required this.docUrl,
    required this.docId,
    required this.docDateTime,
    required this.downloadKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LpLoadCubit, LpLoadState>(
      builder: (context, state) {
        final isDownloaded = state.downloadedFiles[downloadKey] ?? false;
        return InkWell(
          onTap: () async {
            await context.read<LpLoadCubit>().getDocumentById(docId: docId);

            final uiState = context.read<LpLoadCubit>().state.lpDocumentById;

            if (uiState?.status == Status.LOADING) {
            } else if (uiState?.status == Status.SUCCESS) {
              await context.read<LpLoadCubit>().downloadAndOpenDocument(downloadKey, uiState?.data?.filePath ?? '');
            } else if (uiState?.status == Status.ERROR) {
              final errorType = uiState?.errorType;
              ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
              return;
            }
          },
          child: Container(
            height: 55,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.docViewCardBgColor,
              borderRadius: BorderRadius.circular(commonTexFieldRadius),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.svg.documentView,
                  width: 22,
                  height: 22,
                  colorFilter: AppColors.svg(AppColors.primaryColor),
                ),
                10.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      docName.capitalizeFirst,
                      style: AppTextStyle.body.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.textBlackColor,
                      ),
                    ),
                    4.height,
                    Text(
                      DateTimeHelper.formatToDateTimeWithTime(
                        docDateTime.toString(),
                      ),
                      style: AppTextStyle.body4.copyWith(
                        color: AppColors.textGreyColor,
                      ),
                    ),
                  ],
                ).expand(),

                if (!isDownloaded)
                  SvgPicture.asset(
                    AppIcons.svg.download,
                    colorFilter: AppColors.svg(AppColors.primaryColor),
                  ),

              ],
            ),
          ),
        );
      },
    );
  }
}
