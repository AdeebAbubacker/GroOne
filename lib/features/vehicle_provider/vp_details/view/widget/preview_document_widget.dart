import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/view_others_document.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';


import '../../../../../utils/app_icons.dart';

class PreviewDocumentWidget extends StatelessWidget {
  final LoadDocument loadDocument;
  final DocumentEntity documentEntity;
  final bool? isLoading;
  final Function() onClickDownload;
  final Function() onClickDeleteIcon;
  final Function() onClickAddMoreButton;
  final Function() onClickViewMoreIcon;
  final bool? showDeleteLoader;
  final bool? showDeleteIcon;
  final bool? showAddMoreButton;
  final bool? showViewMoreButton;
  const PreviewDocumentWidget({
    super.key,
    this.showDeleteLoader = false,
    this.showDeleteIcon,
    required this.onClickDeleteIcon,
    required this.onClickAddMoreButton,
    required this.onClickViewMoreIcon,
    required this.showViewMoreButton,
    required this.loadDocument,
    required this.documentEntity,
    this.isLoading,
    this.showAddMoreButton,
    required this.onClickDownload,
  });

  @override
  Widget build(BuildContext context) {

    return buildUploadedDocPreviewItem(
      onClickViewMoreIcon:onClickViewMoreIcon ,
      showDeleteIcon: showDeleteIcon,

      onClickDeleteIcon: onClickDeleteIcon,
      isLoading: isLoading ?? false,
      onClickDownload: onClickDownload,
      fileTitle: documentEntity.documentType ?? "",
      context: context,
      onClickAddMoreButton:onClickAddMoreButton ,
      showViewButton: showViewMoreButton,
      dateTime: formatDateTimeKavach(
        loadDocument.createdAt?.toString() ?? DateTime.now().toString(),
      ),
      fileUrl: "",
      isDownloadable: true,
      isFileAvailable: true,
      showAddMoreButton: showAddMoreButton??true,
      showDeleteLoader: showDeleteLoader ?? false,
    );
  }
}

Widget buildUploadedDocPreviewItem({
  required String fileTitle,
  required String dateTime,
  required bool isFileAvailable,
  required bool isDownloadable,
  required String fileUrl,
  required BuildContext context,
  bool isLoading = false,
  bool showDeleteLoader = false,
  bool? showDeleteIcon,
  bool? showAddMoreButton,
  bool? showViewButton,
  required VoidCallback onClickDownload,
  required VoidCallback onClickDeleteIcon,
  required VoidCallback onClickAddMoreButton,
  required VoidCallback onClickViewMoreIcon,
}) {
  final bool shouldShowAdd = showAddMoreButton ?? false;
  final bool shouldShowDelete = showDeleteIcon ?? false;
  final bool shouldShowView = showViewButton ?? false;




  final Widget loader = SizedBox(
    height: 15,
    width: 15,
    child: CircularProgressIndicator(strokeWidth: 1),
  );

  return Container(
    height: 55,
    width: double.infinity,
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
          colorFilter: AppColors.svg(
            isFileAvailable ? AppColors.primaryColor : AppColors.iconRed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFileAvailable
                    ? (fileTitle == context.appText.pod
                    ? context.appText.profOfDelivery
                    : fileTitle)
                    : context.appText.fileNotFound,
                style: AppTextStyle.body.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: isFileAvailable
                      ? AppColors.textBlackColor
                      : AppColors.iconRed,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateTime,
                style: AppTextStyle.body.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: AppColors.textGreyColor,
                ),
              ),
            ],
          ),
        ),

        // Add more button
        if (shouldShowAdd)
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: AppColors.primaryColor,
            ),
            onPressed: onClickAddMoreButton,
          ),

        // Delete icon or loader
        if (shouldShowDelete)
          showDeleteLoader
              ? loader
              : IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20,
              color: AppColors.primaryColor,
            ),
            onPressed: onClickDeleteIcon,
          ),

        // View or download button
        if (isFileAvailable && isDownloadable)
          isLoading
              ? loader
              : shouldShowView
              ? GestureDetector(
            onTap: onClickViewMoreIcon,
            child: Icon(
              Icons.remove_red_eye_outlined,
              size: 20,
              color: AppColors.primaryColor,
            ),
          )
              : IconButton(
            icon: Icon(
              Icons.file_download_outlined,
              size: 20,
              color: AppColors.primaryColor,
            ),
            onPressed: onClickDownload,
          ),
      ],
    ),
  );
}
