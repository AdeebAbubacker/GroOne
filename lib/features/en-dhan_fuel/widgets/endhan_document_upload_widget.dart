import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/upload_file_and_image_bottom_sheet.dart';

@immutable
class EndhanDocumentUploadWidget extends StatefulWidget {
  final List multiFilesList;
  final bool? isSingleFile;
  final bool? isLoading;
  final bool? hideDeleteButton;
  final String? title;
  final Function? thenUploadFileToSever;
  final Function(List)? onFilesChanged;
  final String? feildTitle;
  
  const EndhanDocumentUploadWidget({
    super.key, 
    required this.multiFilesList, 
    this.isSingleFile = false, 
    this.title, 
    this.thenUploadFileToSever, 
    this.isLoading = false, 
    this.hideDeleteButton = false,
    this.onFilesChanged,
    this.feildTitle = "",
  });

  @override
  State<EndhanDocumentUploadWidget> createState() => _EndhanDocumentUploadWidgetState();
}

class _EndhanDocumentUploadWidgetState extends State<EndhanDocumentUploadWidget> {
  bool isFile = false;
  final double documentHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)...[
          Text(widget.title ?? 'Upload Document', style: AppTextStyle.textFiled),
          Text('Supported formats: PDF, JPG, PNG, DOC', style: AppTextStyle.body4GreyColor),
          10.height,
        ],

        // Always show upload interface
        GestureDetector(
          onTap: !isFile ? () {
            commonHideKeyboard(context);
            commonBottomSheet(context: context, barrierDismissible: true, screen: const UploadFileAndImageBottomSheet()).then((value) {
              debugPrint("Document Upload: $value");
              isFile = true;
                                if (value != null) {
                    for (int i = 0; i < value.length;) {
                      if (value.length <= 8) {
                        isFile = false;
                        // For single file upload, replace the existing document instead of adding
                        final newList = widget.isSingleFile == true ? [value] : List.from(widget.multiFilesList)..add(value);
                        widget.onFilesChanged?.call(newList);
                        widget.thenUploadFileToSever?.call();
                      } else {
                        isFile = false;
                      }
                      break;
                    }
                  } else {
                isFile = false;
              }
              if(!context.mounted) return;
              commonHideKeyboard(context);
            });
            setState(() {});
          } : () {},
          child: DottedBorder(
            dashPattern: const [3, 5],
            color: Colors.black26,
            padding: EdgeInsets.zero,
            strokeWidth: 3,
            radius: const Radius.circular(commonTexFieldRadius),
            borderType: BorderType.RRect,
            child: Container(
              height: documentHeight,
              color: AppColors.textFieldFillColor,
              alignment: Alignment.center,
              child: isFile
                  ? Text(AppString.label.loading, style: AppTextStyle.body2)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.feildTitle??context.appText.uploadDocument, style: AppTextStyle.textFiled),
                        10.width,
                        SvgPicture.asset(AppIcons.svg.documentUpload, width: 16, colorFilter: AppColors.svg(AppColors.iconColor)),
                      ],
                    ),
            ),
          ),
        ),

        // Show uploaded documents below the upload interface
        if (widget.multiFilesList.isNotEmpty) ...[
          10.height,
          // For single file, show only the first document (safely)
          ...(widget.isSingleFile == true ? 
              (widget.multiFilesList.isNotEmpty ? [widget.multiFilesList.first] : []) : 
              widget.multiFilesList).asMap().entries.map((entry) {
            final index = entry.key;
            final document = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.uploadedDocBgColor,
                borderRadius: BorderRadius.circular(commonTexFieldRadius),
                
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      document["fileName"].toString().capitalizeFirst,
                      style: AppTextStyle.h6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!widget.isLoading! && !widget.hideDeleteButton!)
                    AppIconButton(
                      onPressed: () {
                        try {
                          // For single file, clear the entire list when deleting
                          final newList = widget.isSingleFile == true ? [] : List.from(widget.multiFilesList)..removeAt(index);
                          widget.onFilesChanged?.call(newList);
                          commonHapticFeedback();
                          commonHideKeyboard(context);
                          setState(() {});
                        } catch (e) {
                          debugPrint('Error deleting document: $e');
                          // Fallback: clear the entire list
                          widget.onFilesChanged?.call([]);
                          setState(() {});
                        }
                      },
                      icon: AppIcons.png.deleteIcon,
                      iconColor: AppColors.activeRedColor,
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }
} 