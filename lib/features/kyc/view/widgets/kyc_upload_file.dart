import 'dart:io';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
class KycUploadFile extends StatefulWidget {
  final List multiFilesList;
  final bool? isSingleFile;

  final Function? thenUploadFileToSever;
  const KycUploadFile({super.key, required this.multiFilesList, this.isSingleFile = false, this.thenUploadFileToSever});

  @override
  State<KycUploadFile> createState() => _KycUploadFile();
}

class _KycUploadFile extends State<KycUploadFile> {

  bool isFile = false;
  final double documentHeight = 70;


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
                            commonBottomSheetWithBGBlur(context: context, screen: const UploadFileAndImageBottomSheet()).then((value) {
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
                          child: DottedBorder(
                            color: AppColors.dividerColor,
                            strokeWidth: 1.5,
                            radius: const Radius.circular(12),
                            borderType: BorderType.RRect,
                            child: Container(
                              height: documentHeight,
                              alignment: Alignment.center,
                              child: isFile ? Text(AppString.label.loading, style: AppTextStyle.body) : Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(AppString.label.addMore, style: AppTextStyle.body2GreyColor),
                                    10.width,
                                    SvgPicture.asset(AppIcons.svg.documentUpload, width: 20, colorFilter: AppColors.svg(AppColors.greyIconColor)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).paddingOnly(right: 5, left: 5, top: 5);
                      } else {
                        return 0.width;
                      }
                    } else {
                      return  Container(
                        width: double.infinity,
                        color : AppColors.uploadedDocBgColor,
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
                            AppIconButton(
                              onPressed: (){
                                widget.multiFilesList.removeAt(index);
                                commonHapticFeedback();
                                commonHideKeyboard(context);
                                setState(() {});
                              },
                              icon: AppIcons.svg.delete,
                              iconColor: AppColors.activeRedColor,
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
                10.height,
                GestureDetector(
                  onTap: !isFile ? () {
                    commonHideKeyboard(context);
                    commonBottomSheet(context: context, barrierDismissible: true, screen: const UploadFileAndImageBottomSheet()).then((value) {
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
                    color: Colors.grey,
                    dashPattern: [6, 3],
                    strokeWidth: 1,
                    child: SizedBox(
                      height: 44.h,
                      width: double.infinity,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Upload document",
                            style: AppTextStyle.textBlackColor14w400.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          10.width,
                          Icon(Icons.file_upload_outlined, color: AppColors.black, size: 20),
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
}
