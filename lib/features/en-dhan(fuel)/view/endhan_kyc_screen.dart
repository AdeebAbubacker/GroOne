import 'package:flutter/material.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/view/endhan_create_new_card_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';

class EndhanKycScreen extends StatelessWidget {
  const EndhanKycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List _panDocuments = [];
    final List _identityFront = [];
    final List _identityBack = [];
    final List _addressFront = [];
    final List _addressBack = [];

    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.kyc,
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {},
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          10.width,
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Aadhaar Card
            _buildLabelWithInfoIcon('Aadhaar Card', isMandatory: true),

            10.height,
            
            AppTextField(
              hintText: 'AAAPA1234A',
            ),

            15.height,

            AppButton(
              onPressed: () {},
              title: context.appText.getOtp,
              textStyle: TextStyle(
                color: AppColors.primaryColor
              ),
              style: AppButtonStyle.outlineAndFilled,
            ),

            15.height,

            // PAN Card
            _buildLabelWithInfoIcon('PAN', isMandatory: true),
            10.height,

            AppTextField(
              hintText: 'AAAPA1234A',
            ),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _panDocuments,
              isSingleFile: true,
              title: 'Upload document',
            ),

            15.height,

            _buildLabelWithInfoIcon('Identity Proof'),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _identityFront,
              isSingleFile: true,
              title: 'Upload Front side of the document',
            ),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _identityBack,
              isSingleFile: true,
              title: 'Upload Back side of the document',
            ),

            15.height,

            _buildLabelWithInfoIcon('Address Proof'),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _addressFront,
              isSingleFile: true,
              title: 'Upload Front side of the document',
            ),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _addressBack,
              isSingleFile: true,
              title: 'Upload Back side of the document',
            ),
          ],
        ).paddingAll(20),
      )),
      bottomNavigationBar: AppButton(
        onPressed: () {
          Navigator.push(context,commonRoute(EndhanCreateNewCardScreen()));
        },
        title: context.appText.submit,
      ).paddingAll(20),
    );
  }

  Widget _buildLabelWithInfoIcon(String label, {bool isMandatory = false}) {
    return Row(
      children: [
        Text(label, style: AppTextStyle.textFiled),
        if (isMandatory)
          Text(
            "*",
            style: AppTextStyle.textFiled.copyWith(color: AppColors.activeRedColor),
          ),
        const Spacer(),
        AppIconButton(
          onPressed: () {},
          icon: AppIcons.svg.infOutline,
          iconColor: AppColors.primaryTextColor,
        ),
      ],
    );
  }
}
