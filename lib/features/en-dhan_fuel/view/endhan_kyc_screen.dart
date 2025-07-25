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
import '../../kavach/view/kavach_support_screen.dart';
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';

class EndhanKycScreen extends StatefulWidget {
  const EndhanKycScreen({super.key});

  @override
  State<EndhanKycScreen> createState() => _EndhanKycScreenState();
}

class _EndhanKycScreenState extends State<EndhanKycScreen> {
  @override
  void initState() {
    super.initState();
    // No need to reset here since we'll create a fresh cubit
  }

  @override
  void dispose() {
    // No need to reset since we're using a fresh cubit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Create a completely fresh cubit instance with new dependencies
        final repository = locator<EnDhanRepository>();
        final userInfoRepository = locator<UserInformationRepository>();
        return EnDhanCubit(repository, userInfoRepository);
      },
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
              message: context.appText.kycDocumentsUploadedSuccessfully,
              onContinue: () {
                    Navigator.of(context).pop();
                   Navigator.pushReplacement(context, commonRoute(EndhanCreateCardCustomerInfoScreen()));
              },
            ),
          );
  }

  void _showOtpBottomSheet(BuildContext context, EnDhanCubit cubit) {
    final List<TextEditingController> otpControllers = List.generate(6, (i) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (i) => FocusNode());

    void _onOtpChanged(int idx, String value) {
      // Handle forward navigation when a digit is entered
      if (value.length == 1 && idx < 5) {
        // Add a small delay to ensure the current field is properly updated
        Future.delayed(Duration(milliseconds: 50), () {
          focusNodes[idx + 1].requestFocus();
        });
      } 
      // Handle backward navigation when a digit is deleted
      else if (value.isEmpty && idx > 0) {
        // Add a small delay to ensure the current field is properly cleared
        Future.delayed(Duration(milliseconds: 50), () {
          focusNodes[idx - 1].requestFocus();
          // Ensure cursor is at the end of the previous field
          WidgetsBinding.instance.addPostFrameCallback((_) {
            otpControllers[idx - 1].selection = TextSelection.fromPosition(
              TextPosition(offset: otpControllers[idx - 1].text.length),
            );
          });
        });
      }
      // When the last digit (6th) is entered, keep focus but show visual feedback
      else if (value.length == 1 && idx == 5) {
        // Keep focus on the last field but add a small delay for visual feedback
        Future.delayed(Duration(milliseconds: 100), () {
          if (context.mounted) {
            // Add a subtle visual feedback by briefly changing focus
            focusNodes[idx].unfocus();
            Future.delayed(Duration(milliseconds: 50), () {
              if (context.mounted) {
                focusNodes[idx].requestFocus();
              }
            });
          }
        });
      }
    }

    String getOtp() => otpControllers.map((c) => c.text).join();
    bool isOtpComplete() => getOtp().length == 6 && getOtp().runes.every((r) => r >= 48 && r <= 57);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocListener<EnDhanCubit, EnDhanState>(
          bloc: cubit,
          listenWhen: (previous, current) {
            final changed = previous.aadhaarVerifyOtpState != current.aadhaarVerifyOtpState;
            return changed;
          },
          listener: (context, state) {
            if (state.aadhaarVerifyOtpState?.status == Status.SUCCESS) {
              Navigator.of(context).pop();
              ToastMessages.success(message: context.appText.aadhaarVerifiedSuccessfully);
            }
            if (state.aadhaarVerifyOtpState?.status == Status.ERROR) {
              final error = state.aadhaarVerifyOtpState?.errorType;
              ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  20.height,
                  // Title
                  Text(
                    context.appText.verifyYourKyc,
                    style: AppTextStyle.h5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  30.height,
                  // Subtitle with OTP hint
                  Text(
                    '${context.appText.enterOtpSentToMobile}\n${context.appText.otpHint}',
                    style: AppTextStyle.body3.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  40.height,
                  // OTP input boxes
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) => Container(
                        width: 40,
                        height: 48,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: otpControllers[i],
                          focusNode: focusNodes[i],
                          textAlign: TextAlign.center,
                          style: AppTextStyle.h5,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            _onOtpChanged(i, value);
                            // Ensure cursor is always at the end after any change
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (otpControllers[i].text.isNotEmpty) {
                                otpControllers[i].selection = TextSelection.fromPosition(
                                  TextPosition(offset: otpControllers[i].text.length),
                                );
                              }
                            });
                          },
                          onTap: () {
                            // Ensure cursor is at the end when tapping
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              otpControllers[i].selection = TextSelection.fromPosition(
                                TextPosition(offset: otpControllers[i].text.length),
                              );
                            });
                          },
                        ),
                      )),
                    ),
                  ),
                  35.height,
                  // Verify button
                  BlocBuilder<EnDhanCubit, EnDhanState>(
                    bloc: cubit,
                    builder: (context, state) {
                      final bool isLoading = state.aadhaarVerifyOtpState?.status == Status.LOADING;
                      final bool canVerify = isOtpComplete();
                      return AppButton(
                        onPressed: (!isLoading && canVerify)
                            ? () {
                              cubit.verifyAadhaarOtp(getOtp());
                            }
                            : () {
                              // Button disabled
                            },
                        title: context.appText.verifyOtp,
                        isLoading: isLoading,
                        style: canVerify ? AppButtonStyle.primary : AppButtonStyle.disableButton,
                      );
                    },
                  ),
                  40.height,
                ],
              ),
            ),
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
        title: Text(context.appText.kyc,style: AppTextStyle.appBar),
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(context,commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          10.width,
        ],
      ),
      body: SafeArea(
          child: Form(
            key: _formKey,
            child: BlocListener<EnDhanCubit, EnDhanState>(
              bloc: cubit,
              listenWhen: (previous, current) {
                // Listen for verification state changes
                return previous.isAadhaarVerified != current.isAadhaarVerified ||
                       previous.isPanVerified != current.isPanVerified;
              },
              listener: (context, state) {
                // Verification state changed
              },
              child: BlocBuilder<EnDhanCubit, EnDhanState>(
              buildWhen: (previous, current) {
                // Rebuild when verification states change or document lists change
                return previous.isAadhaarVerified != current.isAadhaarVerified ||
                       previous.isPanVerified != current.isPanVerified ||
                       previous.isAadhaarValid != current.isAadhaarValid ||
                       previous.isPanValid != current.isPanValid ||
                       previous.panDocuments != current.panDocuments ||
                       previous.identityFrontDocuments != current.identityFrontDocuments ||
                       previous.identityBackDocuments != current.identityBackDocuments ||
                       previous.addressFrontDocuments != current.addressFrontDocuments ||
                       previous.addressBackDocuments != current.addressBackDocuments;
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                     
                      _buildLabelWithInfoIcon(context, context.appText.aadhaarCard, isMandatory: true, isVerified: state.isAadhaarVerified),
                      10.height,

                      AppTextField(
                        readOnly: state.isAadhaarVerified,
                        hintText: context.appText.enter12DigitAadhaar,
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
                            _showOtpBottomSheet(context, cubit);
                          }
                          if (state.aadhaarSendOtpState?.status == Status.ERROR) {
                            final error = state.aadhaarSendOtpState?.errorType;
                            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                          }
                        },
                        child: Column(
                          children: [
                           
                            AppButton(
                              onPressed: state.isAadhaarValid && !state.isAadhaarVerified ? () {
                                cubit.sendAadhaarOtp();
                              } : () {
                                // Button disabled
                              },
                              title: state.isAadhaarVerified ? context.appText.verified : context.appText.getOtp,
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

                      // Listen for Aadhaar verification state changes
                      BlocListener<EnDhanCubit, EnDhanState>(
                        bloc: cubit,
                        listenWhen: (previous, current) => 
                          previous.aadhaarVerifyOtpState != current.aadhaarVerifyOtpState,
                        listener: (context, state) {
                          if (state.aadhaarVerifyOtpState?.status == Status.SUCCESS) {
                            // The verification icon will be updated automatically through BlocBuilder
                          }
                          if (state.aadhaarVerifyOtpState?.status == Status.ERROR) {
                            final error = state.aadhaarVerifyOtpState?.errorType;
                            ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                          }
                        },
                        child: SizedBox.shrink(),
                      ),

                      15.height,

                      // PAN Card
                    
                      _buildLabelWithInfoIcon(context, context.appText.pan, isMandatory: true, isVerified: state.isPanVerified),
                      10.height,


                      AppTextField(
                        mandatoryStar: true,
                        hintText: context.appText.enterPanNumber,
                        onChanged: state.isPanVerified ? null : (value) {
                          cubit.setPan(value);
                          cubit.validatePan(value);
                        },
                        validator: (value) => cubit.getPanValidationError(value ?? ''),
                        maxLength: 10,
                        readOnly: state.isPanVerified,
                        decoration: commonInputDecoration(
                          hintText: context.appText.enterPanNumber,
                          suffixIcon: state.isPanVerified
                              ? null
                              : GestureDetector(
                                  onTap: state.isPanValid ? () {
                                    cubit.verifyPan();
                                  } : null,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      context.appText.verify,
                                      style: AppTextStyle.body3.copyWith(
                                        color: state.isPanValid ? AppColors.primaryColor : Colors.grey,
                                        decoration: state.isPanValid ? TextDecoration.underline : TextDecoration.none,
                                        fontWeight: state.isPanValid ? FontWeight.w500 : FontWeight.normal,
                                        decorationColor: state.isPanValid ? AppColors.primaryColor : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      // Listen for manual PAN verification responses
                      BlocListener<EnDhanCubit, EnDhanState>(
                        bloc: cubit,
                        listenWhen: (previous, current) => 
                          previous.panVerificationState != current.panVerificationState,
                        listener: (context, state) {
                          if (state.panVerificationState?.status == Status.SUCCESS) {
                            ToastMessages.success(message: context.appText.panVerifiedSuccessfully);
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
                            feildTitle: context.appText.uploadDocument,
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
                                context.appText.panDocumentRequired,
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      15.height,

                      _buildLabelWithInfoIcon(context, context.appText.identityProof, isMandatory: true),
                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: context.appText.uploadFrontSide,
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
                                context.appText.identityProofFrontRequired,
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: context.appText.uploadBackSide,
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
                                context.appText.identityProofBackRequired,
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      15.height,

                      _buildLabelWithInfoIcon(context, context.appText.addressProof, isMandatory: true),
                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: context.appText.uploadFrontSide,
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
                                context.appText.addressProofFrontRequired,
                                style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                              ),
                            ),
                        ],
                      ),

                      10.height,

                      Column(
                        children: [
                          EndhanDocumentUploadWidget(
                            feildTitle: context.appText.uploadBackSide,
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
                                context.appText.addressProofBackRequired,
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
            onPressed: () {
              if (isLoading) return;
              
              // Check if PAN and Aadhaar are verified
              if (!state.isAadhaarVerified || !state.isPanVerified) {
                String message = '';
                if (!state.isAadhaarVerified && !state.isPanVerified) {
                  message = 'Please verify both PAN and Aadhaar before submitting.';
                } else if (!state.isAadhaarVerified) {
                  message = 'Please verify your Aadhaar before submitting.';
                } else if (!state.isPanVerified) {
                  message = 'Please verify your PAN before submitting.';
                }
                
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(context.appText.verificationRequired),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(context.appText.ok),
                        ),
                      ],
                    );
                  },
                );
                return;
              }
              
              // If form is valid, proceed with submission
              if (isFormValid) {
                if (_formKey.currentState!.validate()) {
                  cubit.uploadKycDocumentsMultipart();
                } else {
                  ToastMessages.alert(message: context.appText.pleaseFillAllRequiredFields);
                }
              }
            },
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
    if (fieldName == context.appText.aadhaarCard) {
      message = '• Enter your 12-digit Aadhaar number\n'
              '• Aadhaar number should not start with 0 or 1\n'
              '• All digits should not be the same\n'
              '• You will receive OTP for verification';
    } else if (fieldName == context.appText.pan) {
      message = '• Enter your 10-character PAN number\n'
              '• Format: ABCDE1234F (5 letters + 4 digits + 1 letter)\n'
              '• Upload clear image of your PAN card\n'
              '• Ensure all details are clearly visible';
    } else if (fieldName == context.appText.identityProof) {
      message = '• Upload both front and back sides of your identity document\n'
              '• Accepted documents: Aadhaar, PAN, Driving License, Passport\n'
              '• Ensure all details are clearly visible\n'
              '• File size should be less than 5MB';
    } else if (fieldName == context.appText.addressProof) {
      message = '• Upload both front and back sides of your address document\n'
              '• Accepted documents: Aadhaar, Utility Bill, Bank Statement\n'
              '• Document should not be older than 3 months\n'
              '• Ensure address is clearly visible';
    } else {
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
              child: Text(context.appText.ok),
            ),
          ],
        );
      },
    );
  }


}
