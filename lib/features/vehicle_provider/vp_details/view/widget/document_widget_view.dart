import 'package:dotted_border/dotted_border.dart' show DottedBorder, BorderType;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/preview_document_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/view_others_document.dart';

import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/upload_file_and_image_bottom_sheet.dart';

import '../../../../../utils/app_icons.dart';
import '../../../vp-helper/vp_helper.dart';

class DocumentWidgetView extends StatelessWidget {
  final String? hintText;
  final Function(String)? onGetFile;
  final DocumentEntity? documentEntity;
  final LoadDetailsCubit? loadDetailsCubit;
  final int index;
  const DocumentWidgetView({
    super.key,
    this.hintText,
    this.onGetFile,
    this.documentEntity,
    this.loadDetailsCubit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return documentEntity?.loadDocument  != null && (documentEntity?.loadDocument??[]).isNotEmpty
        ? PreviewDocumentWidget(

       onClickViewMoreIcon: () {
        Navigator.push(context, commonRoute(ViewOtherDocuments(

          documentEntity:documentEntity ,
          cubit:loadDetailsCubit,
        )));
      },
        showViewMoreButton:documentEntity?.documentType==DocumentFileType.uploadOtherDocument.documentType,
        showAddMoreButton: documentEntity?.documentType==DocumentFileType.uploadOtherDocument.documentType && (loadDetailsCubit?.isVisibleAddMoreDocument()??false) && loadDetailsCubit?.state.loadStatus==LoadStatus.loading,
      showDeleteIcon:  loadDetailsCubit?.state.loadStatus==LoadStatus.unloading && documentEntity?.documentType== DocumentFileType.proofOfDelivery.documentType || loadDetailsCubit?.state.loadStatus==LoadStatus.loading && documentEntity?.documentType!=DocumentFileType.uploadOtherDocument.documentType ,
      showDeleteLoader: documentEntity?.deleteLoading,
      onClickDeleteIcon: () {
        loadDetailsCubit?.deleteLoadDocument(documentEntity?.loadDocument?.first.loadDocumentId??"",index);
      },
        onClickDownload: ()  {
         loadDetailsCubit?.downloadDocument(documentEntity?.loadDocument?.first.documentId??"", index);
      },
        onClickAddMoreButton: () {
          pickFile(context);
        },
       isLoading: documentEntity?.isLoading??false,
        documentEntity: documentEntity!,
        loadDocument: documentEntity!.loadDocument!.first).paddingTop(15)
        : Visibility(
      visible: documentEntity?.visible??false,
          child: GestureDetector(
            onTap: () {
              pickFile(context);
            },

            child: DottedBorder(
              color: Colors.black26,
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
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    Spacer(),
                    if(documentEntity?.isLoading??false)
                      CircularProgressIndicator()
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
          ).paddingTop(
            10
          ),
        );
  }

  void pickFile(BuildContext context){
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
      onGetFile!(value['path']);
    });
  }
}
