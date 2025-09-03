import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
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

  /// Get display filename from document data
  String _getDisplayFileName(dynamic fileName) {
    if (fileName == null) return context.appText.unknownFile;
    
    final fileNameStr = fileName.toString();
    
    // If it's an uploaded URL, extract the filename from the URL
    if (fileNameStr.startsWith('http')) {
      try {
        final uri = Uri.parse(fileNameStr);
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty) {
          final lastSegment = pathSegments.last;
          // Remove query parameters if present
          final cleanFileName = lastSegment.split('?').first;
          return cleanFileName.capitalizeFirst;
        }
      } catch (e) {
        // Error parsing URL
      }
      // Fallback: show a generic name for uploaded files
      return context.appText.uploadedDocument;
    }
    
    // For local files, use the filename as is
    return fileNameStr.capitalizeFirst;
  }

  @override
  Widget build(BuildContext context) {
    
    // Update isFile state based on whether there are documents
    if (widget.multiFilesList.isNotEmpty && !isFile) {
      isFile = true;
    } else if (widget.multiFilesList.isEmpty && isFile) {
      isFile = false;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)...[
          Text(widget.title ?? context.appText.uploadDocument, style: AppTextStyle.textFiled),
          Text(context.appText.supportedFormats, style: AppTextStyle.body4GreyColor),
          10.height,
        ],

        // Always show upload interface
        GestureDetector(
          onTap: !isFile ? () {
            commonHideKeyboard(context);
            commonBottomSheet(context: context, barrierDismissible: true, screen: const UploadFileAndImageBottomSheet()).then((value) {
              if (value != null) {
                isFile = true;
                // For single file upload, replace the existing document instead of adding
                final newList = widget.isSingleFile == true ? [value] : List.from(widget.multiFilesList)..add(value);
                widget.onFilesChanged?.call(newList);
                widget.thenUploadFileToSever?.call();
                // Force immediate state update
                setState(() {});
              } else {
                isFile = false;
                setState(() {});
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
              child: Row(
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
                      _getDisplayFileName(document["fileName"] ?? document["path"]),
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
                          // Error deleting document
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
          }),
        ],
      ],
    );
  }
} 