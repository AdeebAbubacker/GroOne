import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_create_card_customer_info_screen.dart';
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
import 'package:gro_one_app/features/en-dhan_fuel/widgets/endhan_document_upload_widget.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:path/path.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';

class EndhanKycScreen extends StatelessWidget {
  const EndhanKycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<EnDhanCubit>(),
      child: const _EndhanKycScreenContent(),
    );
  }
}

class _EndhanKycScreenContent extends StatelessWidget {
  const _EndhanKycScreenContent();

  void _showSuccessDialog(BuildContext context) {
   AppDialog.show(
            context,
            child: SuccessDialogView(
              message: 'KYC documents uploaded successfully!',
              onContinue: () {
                    Navigator.of(context).pop();
                   Navigator.push(context, commonRoute(EndhanCreateCardCustomerInfoScreen()));
              },
            ),
          );
  }

  void _showOtpDialog(BuildContext context, EnDhanCubit cubit) {
    final TextEditingController otpController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocListener<EnDhanCubit, EnDhanState>(
          bloc: cubit,
          listenWhen: (previous, current) => 
            previous.aadhaarVerifyOtpState != current.aadhaarVerifyOtpState,
          listener: (context, state) {
            if (state.aadhaarVerifyOtpState?.status == Status.SUCCESS) {
              Navigator.of(context).pop();
              ToastMessages.success(message: 'Aadhaar verified successfully!');
            }
            if (state.aadhaarVerifyOtpState?.status == Status.ERROR) {
              final error = state.aadhaarVerifyOtpState?.errorType;
              ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
            }
          },
                      child: AlertDialog(
              title: Text('Verify Aadhaar OTP', style: AppTextStyle.h5),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter the OTP sent to your registered mobile number',
                    style: AppTextStyle.body3,
                  ),
                  8.height,
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 16),
                        8.width,
                        Expanded(
                          child: Text(
                            'Use OTP: 123456',
                            style: AppTextStyle.body3.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  AppTextField(
                    hintText: 'Enter 6-digit OTP',
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ],
              ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              BlocBuilder<EnDhanCubit, EnDhanState>(
                bloc: cubit,
                builder: (context, state) {
                  final bool isLoading = state.aadhaarVerifyOtpState?.status == Status.LOADING;
                  return ElevatedButton(
                    onPressed: isLoading ? null : () {
                      if (otpController.text.length == 6) {
                        cubit.verifyAadhaarOtp(otpController.text);
                      } else {
                        ToastMessages.alert(message: 'Please enter a valid 6-digit OTP');
                      }
                    },
                    child: isLoading 
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Verify'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EnDhanCubit>();
    final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: BlocBuilder<EnDhanCubit, EnDhanState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Aadhaar Card
                      _buildLabelWithInfoIcon(context, 'Aadhaar Card', isMandatory: true, isVerified: state.isAadhaarVerified),
                      10.height,

                      AppTextField(
                        hintText: 'Enter 12-digit Aadhaar number',
                        onChanged: (value) {
                          cubit.setAadhaar(value);
                          cubit.validateAadhaar(value);
                        },
                        validator: (value) => cubit.getAadhaarValidationError(value ?? ''),
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),

                      15.height,

                      BlocListener<EnDhanCubit, EnDhanState>(
                        bloc: cubit,
                        listenWhen: (previous, current) => 
                          previous.aadhaarSendOtpState != current.aadhaarSendOtpState,
                        listener: (context, state) {
                          if (state.aadhaarSendOtpState?.status == Status.SUCCESS) {
                            _showOtpDialog(context, cubit);
                          }
                          if (state.aadhaarSendOtpState?.status == Status.ERROR) {
                            final error = state.aadhaarSendOtpState?.errorType;
                            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                          }
                        },
                        child: Column(
                          children: [
                            // Debug info
                            // Text(
                            //   'Debug: isAadhaarValid=${state.isAadhaarValid}, isAadhaarVerified=${state.isAadhaarVerified}',
                            //   style: TextStyle(fontSize: 10, color: Colors.grey),
                            // ),
                            AppButton(
                              onPressed: state.isAadhaarValid && !state.isAadhaarVerified ? () {
                                cubit.sendAadhaarOtp();
                              } : () {},
                              title: state.isAadhaarVerified ? 'Verified' : context.appText.getOtp,
                              textStyle: TextStyle(
                                  color: AppColors.primaryColor
                              ),
                              style: state.isAadhaarValid && !state.isAadhaarVerified 
                                ? AppButtonStyle.outlineAndFilled 
                                : AppButtonStyle.disableButton,
                            ),
                          ],
                        ),
                      ),

                      15.height,

                      // PAN Card
                      _buildLabelWithInfoIcon(context, 'PAN', isMandatory: true, isVerified: state.isPanVerified),
                      10.height,

                      // Debug info for PAN
                      // Text(
                      //   'Debug: PAN="${state.pan}", isValid=${state.isPanValid}, isVerified=${state.isPanVerified}, verificationStatus=${state.panVerificationState?.status}',
                      //   style: TextStyle(fontSize: 10, color: Colors.grey),
                      // ),
                      // 5.height,

                      AppTextField(
                        hintText: 'Enter PAN number (e.g., ABCDE1234F)',
                        onChanged: (value) {
                          cubit.setPan(value);
                          cubit.validatePan(value);
                        },
                        validator: (value) => cubit.getPanValidationError(value ?? ''),
                        maxLength: 10,
                      ),

                      // Auto-verify PAN when input is complete
                      BlocListener<EnDhanCubit, EnDhanState>(
                        bloc: cubit,
                        listenWhen: (previous, current) => 
                          previous.panVerificationState != current.panVerificationState,
                        listener: (context, state) {
                          if (state.panVerificationState?.status == Status.SUCCESS) {
                            ToastMessages.success(message: 'PAN verified successfully!');
                          }
                          if (state.panVerificationState?.status == Status.ERROR) {
                            final error = state.panVerificationState?.errorType;
                            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                          }
                        },
                        child: SizedBox.shrink(),
                      ),

                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: "Upload document",
                            multiFilesList: state.panDocuments,
                            isSingleFile: true,
                            onFilesChanged: (newList) {
                              cubit.updatePanDocuments(newList);
                              // Reset upload flag if document is removed
                              if (newList.isEmpty) {
                                cubit.setPanImageUploaded(false);
                              }
                            },
                            thenUploadFileToSever: () {
                              // Set upload flag immediately when document is uploaded
                              cubit.setPanImageUploaded(true);
                            },
                          ),
                          if (state.panDocuments.isEmpty && state.hasAttemptedSubmit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'PAN document is required',
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      15.height,

                      _buildLabelWithInfoIcon(context, 'Identity Proof', isMandatory: true),
                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: "Upload Front side of the document",
                            multiFilesList: state.identityFrontDocuments,
                            isSingleFile: true,
                            // title: 'Upload Front side of the document',
                            onFilesChanged: (newList) {
                              cubit.updateIdentityFrontDocuments(newList);
                              // Reset upload flag if document is removed
                              if (newList.isEmpty) {
                                cubit.setIdentityFrontUploaded(false);
                              }
                            },
                            thenUploadFileToSever: () {
                              // Set upload flag immediately when document is uploaded
                              cubit.setIdentityFrontUploaded(true);
                            },
                          ),
                          if (state.identityFrontDocuments.isEmpty && state.hasAttemptedSubmit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Identity proof front side is required',
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: "Upload Back side of the document",
                            multiFilesList: state.identityBackDocuments,
                            isSingleFile: true,
                            // title: 'Upload Back side of the document',
                            onFilesChanged: (newList) {
                              cubit.updateIdentityBackDocuments(newList);
                              // Reset upload flag if document is removed
                              if (newList.isEmpty) {
                                cubit.setIdentityBackUploaded(false);
                              }
                            },
                            thenUploadFileToSever: () {
                              // Set upload flag immediately when document is uploaded
                              cubit.setIdentityBackUploaded(true);
                            },
                          ),
                          if (state.identityBackDocuments.isEmpty && state.hasAttemptedSubmit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Identity proof back side is required',
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      15.height,

                      _buildLabelWithInfoIcon(context, 'Address Proof', isMandatory: true),
                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: "Upload Front side of the document",
                            multiFilesList: state.addressFrontDocuments,
                            isSingleFile: true,
                            // title: 'Upload Front side of the document',
                            onFilesChanged: (newList) {
                              cubit.updateAddressFrontDocuments(newList);
                              // Reset upload flag if document is removed
                              if (newList.isEmpty) {
                                cubit.setAddressFrontUploaded(false);
                              }
                            },
                            thenUploadFileToSever: () {
                              // Set upload flag immediately when document is uploaded
                              cubit.setAddressFrontUploaded(true);
                            },
                          ),
                          if (state.addressFrontDocuments.isEmpty && state.hasAttemptedSubmit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Address proof front side is required',
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: "Upload Back side of the document",
                            multiFilesList: state.addressBackDocuments,
                            isSingleFile: true,
                            // title: 'Upload Back side of the document',
                            onFilesChanged: (newList) {
                              cubit.updateAddressBackDocuments(newList);
                              // Reset upload flag if document is removed
                              if (newList.isEmpty) {
                                cubit.setAddressBackUploaded(false);
                              }
                            },
                            thenUploadFileToSever: () {
                              // Set upload flag immediately when document is uploaded
                              cubit.setAddressBackUploaded(true);
                            },
                          ),
                          if (state.addressBackDocuments.isEmpty && state.hasAttemptedSubmit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Address proof back side is required',
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      20.height,
                    ],
                  ).paddingAll(20),
                );
              },
            ),
          )),
      bottomNavigationBar: BlocConsumer<EnDhanCubit, EnDhanState>(
        bloc: cubit,
        listenWhen: (previous, current) => previous.uploadKycState != current.uploadKycState,
        listener: (context, state) {
          if (state.uploadKycState?.status == Status.SUCCESS) {
            _showSuccessDialog(context);
          }
          if (state.uploadKycState?.status == Status.ERROR) {
            final error = state.uploadKycState?.errorType;
            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
          }
        },
        builder: (context, state) {
          final bool isLoading = state.uploadKycState?.status == Status.LOADING;
          final bool isFormValid = state.isFormValid;
          

          return AppButton(
            onPressed: (!isLoading && isFormValid) ? () {
              if (_formKey.currentState!.validate()) {
                cubit.uploadKycDocumentsMultipart();
              } else {
                ToastMessages.alert(message: "Please fill all required fields correctly");
              }
            } : () {},
            title: context.appText.submit,
            isLoading: isLoading,
            style: isFormValid ? AppButtonStyle.primary : AppButtonStyle.disableButton,
          ).paddingAll(20);
        },
      ),
    );
  }

  Widget _buildLabelWithInfoIcon(BuildContext context, String label, {bool isMandatory = false, bool isVerified = false}) {
    return Row(
      children: [
        Text(label, style: AppTextStyle.textFiled),
        if (isMandatory)
          Text(
            "*",
            style: AppTextStyle.textFiled.copyWith(color: AppColors.activeRedColor),
          ),
        const Spacer(),
        if (isVerified)
          Icon(
            Icons.verified,
            color: Colors.green,
            size: 20,
          )
        else
          AppIconButton(
            onPressed: () {
              _showInfoDialog(context, label);
            },
            icon: AppIcons.svg.infOutline,
            iconColor: AppColors.primaryTextColor,
          ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context, String fieldName) {
    String message = '';
    switch (fieldName) {
      case 'Aadhaar Card':
        message = '• Enter your 12-digit Aadhaar number\n'
                '• Aadhaar number should not start with 0 or 1\n'
                '• All digits should not be the same\n'
                '• You will receive OTP for verification';
        break;
      case 'PAN':
        message = '• Enter your 10-character PAN number\n'
                '• Format: ABCDE1234F (5 letters + 4 digits + 1 letter)\n'
                '• Upload clear image of your PAN card\n'
                '• Ensure all details are clearly visible';
        break;
      case 'Identity Proof':
        message = '• Upload both front and back sides of your identity document\n'
                '• Accepted documents: Aadhaar, PAN, Driving License, Passport\n'
                '• Ensure all details are clearly visible\n'
                '• File size should be less than 5MB';
        break;
      case 'Address Proof':
        message = '• Upload both front and back sides of your address document\n'
                '• Accepted documents: Aadhaar, Utility Bill, Bank Statement\n'
                '• Document should not be older than 3 months\n'
                '• Ensure address is clearly visible';
        break;
      default:
        message = 'Please provide valid information for this field.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(fieldName),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


}
