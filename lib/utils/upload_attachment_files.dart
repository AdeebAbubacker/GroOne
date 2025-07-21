import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/upload_file_and_image_bottom_sheet.dart';

@immutable
class UploadAttachmentFiles extends StatefulWidget {
  final List multiFilesList;
  final bool? isSingleFile;
  final bool isMultipleSelectionFile;
  final bool? isLoading;
  final bool? hideDeleteButton;
  final String? title;
  final Function? thenUploadFileToSever;
  final void Function(int)? onDelete;
  const UploadAttachmentFiles({super.key,
    required this.multiFilesList,
    this.isSingleFile = false,
    this.isMultipleSelectionFile = true,
    this.title, this.thenUploadFileToSever,
    this.isLoading = false,
    this.hideDeleteButton = false,
    this.onDelete,
  });

  @override
  State<UploadAttachmentFiles> createState() => _UploadAttachmentFilesState();
}

class _UploadAttachmentFilesState extends State<UploadAttachmentFiles> {

  bool isFile = false;
  final double documentHeight = 50;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          if (widget.multiFilesList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (widget.title != null)...[
                  Text(widget.title ?? context.appText.attachment, style: AppTextStyle.textFiled),
                  Text(context.appText.docSupport, style: AppTextStyle.body4GreyColor),
                  10.height,
                ],

                MasonryGridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                  itemCount: !widget.isSingleFile! ? (widget.multiFilesList.length + 1) : widget.multiFilesList.length,
                  itemBuilder: (ctx, index) {

                    if (widget.multiFilesList.length == index && !widget.isSingleFile!) {
                      if (widget.multiFilesList.length <= 7) {
                        return GestureDetector(
                          onTap: !isFile ? () {
                            commonHideKeyboard(context);
                            commonBottomSheetWithBGBlur(context: context, screen: UploadFileAndImageBottomSheet(isMultipleSelectionFile: widget.isMultipleSelectionFile)).then((value) {
                              if (value != null) {
                                isFile = true;
                                widget.multiFilesList.add(value);
                                isFile = false;
                                widget.thenUploadFileToSever?.call();
                                debugPrint("Add new : $value");
                              } else {
                                isFile = false;
                              }
                              if(!context.mounted) return;
                              commonHideKeyboard(context);
                            });
                            setState(() {});
                          } : () {},

                          // Add More
                          child: DottedBorder(
                            color: Colors.black38,
                            strokeWidth: 1.5,
                            radius: const Radius.circular(commonTexFieldRadius),
                            borderType: BorderType.RRect,
                            child: Container(
                              height: documentHeight,
                              alignment: Alignment.center,
                              child: isFile ? Text(context.appText.loading, style: AppTextStyle.body) : Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(context.appText.addMore, style: AppTextStyle.textFiled),
                                    10.width,
                                    SvgPicture.asset(AppIcons.svg.documentUpload, width: 20, colorFilter: AppColors.svg(AppColors.iconColor)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).paddingOnly(top: 5);
                      } else {
                        return 0.width;
                      }
                    } else {

                      // Uploaded Document View
                      return  Container(
                        width: double.infinity,
                        height: (documentHeight + 3),
                        decoration: commonContainerDecoration(color : AppColors.uploadedDocBgColor, borderRadius: BorderRadius.circular(commonTexFieldRadius)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            15.width,
                            if (widget.multiFilesList[index]["extension"] == "docx" || widget.multiFilesList[index]["extension"] == "doc")
                              iconsGridDesign(CupertinoIcons.doc_fill)
                            else if (widget.multiFilesList[index]["extension"] == "pdf")
                              iconsGridDesign(Icons.picture_as_pdf_rounded)
                            else if (widget.multiFilesList[index]["extension"] == "jpeg" || widget.multiFilesList[index]["extension"] == "PNG" || widget.multiFilesList[index]["extension"] == "jpg" || widget.multiFilesList[index]["extension"] == "png" || widget.multiFilesList[index]["extension"] == "HEIC")
                              iconsGridDesign(CupertinoIcons.photo_on_rectangle)
                              else if (widget.multiFilesList[index]["extension"] == "gif")
                                iconsGridDesign(Icons.gif_box_rounded)
                                else if (widget.multiFilesList[index]["extension"] == "bmp")
                                  iconsGridDesign(Icons.photo_album_outlined)
                                  else if (widget.multiFilesList[index]["extension"] == "MOV" || widget.multiFilesList[index]["extension"] == "H.264" || widget.multiFilesList[index]["extension"] == "HEVC" || widget.multiFilesList[index]["extension"] == "mp4")
                                    iconsGridDesign(CupertinoIcons.videocam_circle_fill)
                                    else if (widget.multiFilesList[index]["extension"] == "mp3")
                                      iconsGridDesign(CupertinoIcons.music_note_2)
                                      else if (widget.multiFilesList[index]["extension"] == "txt")
                                        iconsGridDesign(CupertinoIcons.doc_richtext)
                                        else
                                          const Icon(CupertinoIcons.doc_text_fill, size: 20, color : AppColors.primaryColor),
                            10.width,
                            Text(widget.multiFilesList[index]["fileName"].toString().capitalizeFirst, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyle.body).expand(),
                            10.width,
                            // AppIconButton(onPressed: (){}, icon: AppIcons.svg.edit)

                            Builder(
                              builder: (context){
                                final isLastIndex = index == widget.multiFilesList.length - 1;

                                if(widget.isLoading!){
                                  if(isLastIndex) {
                                    return CupertinoActivityIndicator().paddingRight(10);
                                  } else{
                                    return _buildRemoveDocumentWidget(index);
                                  }
                                } else {
                                  if(widget.hideDeleteButton!) {
                                    return const SizedBox();
                                  } else {
                                    return _buildRemoveDocumentWidget(index);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      );
                }
              },
            ),
          ],
        );

      } else {
            // When No file selected
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (widget.title != null)...[
              Text(widget.title ?? context.appText.attachment, style: AppTextStyle.textFiled),
              Text(context.appText.docSupport, style: AppTextStyle.body4GreyColor),
              10.height,
            ],

            GestureDetector(
              onTap: !isFile ? () {
                commonHideKeyboard(context);
                commonBottomSheet(context: context, barrierDismissible: true, screen: UploadFileAndImageBottomSheet(isMultipleSelectionFile: widget.isMultipleSelectionFile)).then((value) {
                  debugPrint("First Time : $value");
                  isFile = true;
                  if (value != null) {
                    for (int i = 0; i < value.length;) {
                      if (value.length <= 8) {
                        isFile = false;
                        widget.multiFilesList.add(value);
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
                color:  Colors.black26,
                strokeWidth: 1,
                radius:  const Radius.circular(commonTexFieldRadius),
                borderType: BorderType.RRect,
                child: Container(
                  height: documentHeight,
                  color: AppColors.textFieldFillColor,
                  alignment: Alignment.center,
                  child: isFile
                      ? Text(context.appText.loading, style: AppTextStyle.body2)
                      :  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                          Text(context.appText.uploadDocument, style: AppTextStyle.textFiled),
                          10.width,
                          SvgPicture.asset(AppIcons.svg.documentUpload, width: 16, colorFilter: AppColors.svg(AppColors.iconColor)),
                        ],
                      ),
                ),
              ),
            ),
          ],
        );

      }
    });
  }

  Widget _buildRemoveDocumentWidget(int index){
    return AppIconButton(
      onPressed: (){
        widget.multiFilesList.removeAt(index);
        commonHapticFeedback();
        commonHideKeyboard(context);
        if(widget.onDelete != null){
          widget.onDelete?.call(index);
        }
        setState(() {});
      },
      icon: AppIcons.svg.delete,
      iconColor: AppColors.activeRedColor,
    );
  }

}
