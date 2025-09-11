import 'package:dotted_border/dotted_border.dart' show DottedBorder, BorderType;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/preview_document_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/upload_file_and_image_bottom_sheet.dart';
import '../../../../../utils/app_icons.dart';


class DriverDocumentWidgetView extends StatelessWidget {
  final String? hintText;
  final Function(String)? onGetFile;
  final DocumentEntity? documentEntity;
  final DriverLoadDetailsCubit? driverLoadDetailsCubit;
  final int index;

  const DriverDocumentWidgetView({
    super.key,
    this.hintText,
    this.onGetFile,
    this.documentEntity,
    this.driverLoadDetailsCubit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final hasDocuments = documentEntity?.loadDocument != null && documentEntity!.loadDocument!.isNotEmpty;

    if (hasDocuments) {
      // Show preview(s) of uploaded documents
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show preview widget for first or main document
          PreviewDocumentWidget(
            showViewMoreButton: documentEntity?.documentType == DocumentFileType.uploadOtherDocument.documentType,
            showAddMoreButton:    documentEntity?.documentType==DocumentFileType.uploadOtherDocument.documentType && (driverLoadDetailsCubit?.canAddMoreOtherDocuments()??false) && driverLoadDetailsCubit?.state.loadStatus==LoadStatus.loading,
            showDeleteIcon:  driverLoadDetailsCubit?.state.loadStatus==LoadStatus.unloading && documentEntity?.documentType== DocumentFileType.proofOfDelivery.documentType || driverLoadDetailsCubit?.state.loadStatus==LoadStatus.loading && documentEntity?.documentType!=DocumentFileType.uploadOtherDocument.documentType,
            showDeleteLoader: documentEntity?.deleteLoading,
            onClickDeleteIcon: () {
              // Delete first document; extend if needed to delete specific doc
               driverLoadDetailsCubit?.deleteLoadDocument(documentEntity?.loadDocument?.first.loadDocumentId??"",index,);
            },
            onClickDownload: () {
              // Download first document; extend if needed
              final firstDocId = documentEntity?.loadDocument?.first.documentDetails?.documentId ?? "";
              driverLoadDetailsCubit?.viewDocument(firstDocId, index);
            },
            onClickAddMoreButton: () {
              pickFile(context);
            },
            onClickViewMoreIcon: () {
              // Navigate to screen to view multiple other docs
              if (documentEntity == null) return;
              context.push(
                AppRouteName.driverViewOtherDocs,
                extra: {
                  "loadDocument": documentEntity!.loadDocument,
                  "documentEntity": documentEntity,
                },
              );  
            },
            isLoading: documentEntity?.isLoading ?? false,
            documentEntity: documentEntity!,
            loadDocument: documentEntity!.loadDocument!.first,
          ).paddingTop(15),
        ],
      );
    } else {
      // No documents uploaded yet; show upload button
      return Visibility(
        visible: documentEntity?.visible ?? true,
        child: GestureDetector(
          onTap: () {
            pickFile(context);
          },
          child: DottedBorder(
            color: AppColors.deActiveButtonColor,
            strokeWidth: 1,
            radius: const Radius.circular(commonTexFieldRadius),
            borderType: BorderType.RRect,
            child: Container(
              height: 50,
              color: AppColors.textFieldFillColor,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.width,
                  Text(
                    hintText ?? context.appText.uploadDocument,
                    style: AppTextStyle.textFiled.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  if (documentEntity?.isLoading ?? false)
                    const CircularProgressIndicator()
                  else
                    SvgPicture.asset(
                      AppIcons.svg.documentUpload,
                      width: 16,
                      colorFilter: AppColors.svg(AppColors.iconColor),
                    ),
                  10.width,
                ],
              ),
            ),
          ),
        ).paddingTop(10),
      );
    }
  }

  void pickFile(BuildContext context) {
    commonHideKeyboard(context);
    commonBottomSheet(
      context: context,
      barrierDismissible: true,
      screen: const UploadFileAndImageBottomSheet(
        isMultipleSelectionFile: true,
      ),
    ).then((value) {
      if (!context.mounted) return;
      commonHideKeyboard(context);
      if (onGetFile != null && value != null && value['path'] != null) {
        onGetFile!(value['path']);
      }
    });
  }
}
