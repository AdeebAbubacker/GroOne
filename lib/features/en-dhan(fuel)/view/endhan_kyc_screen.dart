import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/view/endhan_create_new_card_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:path/path.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';

class EndhanKycScreen extends StatefulWidget {
  const EndhanKycScreen({super.key});

  @override
  State<EndhanKycScreen> createState() => _EndhanKycScreenState();
}

class _EndhanKycScreenState extends State<EndhanKycScreen> {
  final cubit = locator<EnDhanCubit>();
  
  final List _panDocuments = [];
  final List _identityFront = [];
  final List _identityBack = [];
  final List _addressFront = [];
  final List _addressBack = [];

  @override
  void initState() {
    super.initState();
    // Set customer ID if available (you can get this from user info or pass as parameter)
    // cubit.setCustomerId(userId);
  }

  @override
  void dispose() {
    cubit.resetUploadKycUIState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: (value) => cubit.setAadhaar(value),
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
              onChanged: (value) => cubit.setPan(value),
            ),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _panDocuments,
              isSingleFile: true,
              title: 'Upload document',
              thenUploadFileToSever: () {
                if (_panDocuments.isNotEmpty) {
                  final filePath = _panDocuments.first["filePath"] ?? "";
                  cubit.setPanImage(filePath);
                }
              },
            ),

            15.height,

            _buildLabelWithInfoIcon('Identity Proof'),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _identityFront,
              isSingleFile: true,
              title: 'Upload Front side of the document',
              thenUploadFileToSever: () {
                if (_identityFront.isNotEmpty) {
                  final filePath = _identityFront.first["filePath"] ?? "";
                  cubit.setIdentityProofFront(filePath);
                }
              },
            ),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _identityBack,
              isSingleFile: true,
              title: 'Upload Back side of the document',
              thenUploadFileToSever: () {
                if (_identityBack.isNotEmpty) {
                  final filePath = _identityBack.first["filePath"] ?? "";
                  cubit.setIdentityProofBack(filePath);
                }
              },
            ),

            15.height,

            _buildLabelWithInfoIcon('Address Proof'),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _addressFront,
              isSingleFile: true,
              title: 'Upload Front side of the document',
              thenUploadFileToSever: () {
                if (_addressFront.isNotEmpty) {
                  final filePath = _addressFront.first["filePath"] ?? "";
                  cubit.setAddressProofFront(filePath);
                }
              },
            ),

            10.height,

            UploadAttachmentFiles(
              multiFilesList: _addressBack,
              isSingleFile: true,
              title: 'Upload Back side of the document',
              thenUploadFileToSever: () {
                if (_addressBack.isNotEmpty) {
                  final filePath = _addressBack.first["filePath"] ?? "";
                  cubit.setAddressProofBack(filePath);
                }
              },
            ),
          ],
        ).paddingAll(20),
      )),
      bottomNavigationBar: BlocConsumer<EnDhanCubit, EnDhanState>(
        bloc: cubit,
        listenWhen: (previous, current) => previous.uploadKycState != current.uploadKycState,
        listener: (context, state) {
          if (state.uploadKycState?.status == Status.SUCCESS) {
            ToastMessages.success(message: "KYC documents uploaded successfully!");
            Navigator.push(context, commonRoute(EndhanCreateNewCardScreen()));
          }
          if (state.uploadKycState?.status == Status.ERROR) {
            final error = state.uploadKycState?.errorType;
            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
          }
        },
        builder: (context, state) {
          final bool isLoading = state.uploadKycState?.status == Status.LOADING;
          final bool isFormValid = cubit.isFormValid();
          
          return AppButton(
            onPressed: (!isLoading && isFormValid) ? () {
              cubit.uploadKycDocuments();
            } : () {},
            title: context.appText.submit,
            isLoading: isLoading,
            style: isFormValid ? AppButtonStyle.primary : AppButtonStyle.disableButton,
          ).paddingAll(20);
        },
      ),
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
