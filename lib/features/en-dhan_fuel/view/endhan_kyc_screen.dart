import 'dart:async';
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
import 'package:gro_one_app/features/en-dhan_fuel/widgets/endhan_document_upload_widget.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import 'package:gro_one_app/features/en-dhan_fuel/repository/en_dhan_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';

import '../../kyc/api_request/init_kyc_request.dart';
import '../../kyc/cubit/kyc_cubit.dart';
import '../../kyc/helper/kyc_helper.dart';
import '../../kyc/model/aadhar_status_response.dart';
import '../../kyc/view/kyc_verification_webview.dart';
import '../../profile/view/support_screen.dart';
import '../../profile/view/widgets/add_new_support_ticket.dart';

class EndhanKycScreen extends StatefulWidget {
  final String? aadhaarPrefill;
  final String? panPrefill;
  final bool isAadhaarVerified;
  final bool isPanVerified;
  final bool showPanUpload;

  const EndhanKycScreen({
    super.key,
    this.aadhaarPrefill,
    this.panPrefill,
    this.isAadhaarVerified = false,
    this.isPanVerified = false,
    this.showPanUpload = true,
  });

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
        // return EnDhanCubit(repository, userInfoRepository);
        return EnDhanCubit(repository, userInfoRepository)..setInitialKycData(
          aadhaar: widget.aadhaarPrefill,
          pan: widget.panPrefill,
          isAadhaarVerified: widget.isAadhaarVerified,
          isPanVerified: widget.isPanVerified,
        );
      },
      child: _EndhanKycScreenContent(showPanUpload: widget.showPanUpload),
    );
  }
}

class _EndhanKycScreenContent extends StatelessWidget {
  final bool showPanUpload; // <- new property

  _EndhanKycScreenContent({
    required this.showPanUpload, // <- make it required or give default
  });

  final kycCubit = locator<KycCubit>(); // For KYC flow
  final aadharRequestId = ValueNotifier<String?>(null);

  void _showSuccessDialog(BuildContext context) {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.kycDocumentsUploadedSuccessfully,
        onContinue: () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            commonRoute(EndhanCreateCardCustomerInfoScreen()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EnDhanCubit>();
    final formKey = GlobalKey<FormState>();

    Future<void> checkVerification(
      BuildContext context,
      String? sdkUrl,
      String? requestId, {
      String status = '',
      String pdf = '',
    }) async {
      if (sdkUrl != null && sdkUrl.isNotEmpty) {
        final isVerified = await Navigator.push(
          context,
          commonRoute(KycVerificationWebView(url: sdkUrl)),
        );

        if (isVerified == true && requestId != null) {
          await kycCubit.getKYCStatus(requestId);
        }
      }

      if (status == "VERIFIED") {
        final pdfPath = await KycHelper.saveBase64PdfToFile(pdf ?? "");
        final file = File(pdfPath);
        final uploadResponse = await cubit.uploadDocument(
          file,
        ); // This function already exists in your cubit

        if (uploadResponse?.data?.url != null) {
          final url = uploadResponse!.data!.url;
          cubit.setAadhaarDocUrl(
            url,
          ); // You’ll create this method and update the state
          cubit.setAadhaarVerified(true);
          if (!context.mounted) return;
          ToastMessages.success(
            message: context.appText.aadhaarVerifiedSuccessfully,
          );
        } else {
          if (!context.mounted) return;
          ToastMessages.error(
            message: context.appText.failedToUploadAadhaarPdf,
          );
        }
      }
    }

    Future<void> checkKycVerification(
      BuildContext context,
      AadharVerificationData? data,
      EnDhanCubit cubit,
    ) async {
      if (data?.status == "VERIFIED") {
        final pdfPath = await KycHelper.saveBase64PdfToFile(
          data?.dataPdf ?? "",
        );
        final file = File(pdfPath);
        final uploadResponse = await cubit.uploadDocument(
          file,
        ); // This function already exists in your cubit

        if (uploadResponse?.data?.url != null) {
          final url = uploadResponse!.data!.url;
          cubit.setAadhaarDocUrl(
            url,
          ); // You’ll create this method and update the state
          cubit.setAadhaarVerified(true);
          if (!context.mounted) return;
          ToastMessages.success(
            message: context.appText.aadhaarVerifiedSuccessfully,
          );
        } else {
          if (!context.mounted) return;
          ToastMessages.error(
            message: context.appText.failedToUploadAadhaarPdf,
          );
        }
      }
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: Text(context.appText.kyc, style: AppTextStyle.appBar),
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.of(context).push(
                commonRoute(
                  LpSupport(showBackButton: true, ticketTag: TicketTags.ENDHAN),
                  isForward: true,
                ),
              );
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          10.width,
        ],
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
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
                return previous.isAadhaarVerified !=
                        current.isAadhaarVerified ||
                    previous.isPanVerified != current.isPanVerified ||
                    previous.isAadhaarValid != current.isAadhaarValid ||
                    previous.isPanValid != current.isPanValid ||
                    previous.panDocuments != current.panDocuments ||
                    previous.identityFrontDocuments !=
                        current.identityFrontDocuments ||
                    previous.identityBackDocuments !=
                        current.identityBackDocuments ||
                    previous.addressFrontDocuments !=
                        current.addressFrontDocuments ||
                    previous.addressBackDocuments !=
                        current.addressBackDocuments;
              },
              builder: (context, state) {
                final aadhaarController = TextEditingController(
                  text: state.aadhaar,
                );
                final panController = TextEditingController(text: state.pan);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLabelWithInfoIcon(
                        context,
                        context.appText.aadhaarCard,
                        isMandatory: true,
                        isVerified: state.isAadhaarVerified,
                      ),
                      10.height,
                      BlocListener<KycCubit, KycState>(
                        listenWhen:
                            (prev, curr) =>
                                prev.kycInitResponse != curr.kycInitResponse ||
                                prev.aadharVerificationState !=
                                    curr.aadharVerificationState,
                        listener: (context, state) async {
                          if (state.kycInitResponse?.status == Status.SUCCESS) {
                            final sdkUrl = state.kycInitResponse?.data?.sdkUrl;
                            final requestId =
                                state.kycInitResponse?.data?.requestId;
                            aadharRequestId.value = requestId;
                            await checkVerification(
                              context,
                              sdkUrl,
                              requestId,
                              status: state.kycInitResponse?.data?.status ?? '',
                              pdf: state.kycInitResponse?.data?.dataPdf ?? '',
                            );
                          }

                          if (state.aadharVerificationState?.status ==
                              Status.SUCCESS) {
                            if (!context.mounted) return;
                            await checkKycVerification(
                              context,
                              state.aadharVerificationState?.data?.data,
                              cubit,
                            );
                          }
                          if (state.kycInitResponse?.status == Status.ERROR) {
                            if (!context.mounted) return;
                            ToastMessages.error(
                              message: context.appText.errorMessage,
                            );
                          }
                        },
                        child: Column(
                          children: [
                            AppTextField(
                              enableInteractiveSelection: true,
                              readOnly: state.isAadhaarVerified,
                              controller: aadhaarController,
                              hintText: context.appText.enter12DigitAadhaar,
                              onChanged: (value) {
                                // cubit.setAadhaar(value);
                                // cubit.validateAadhaar(value);

                                if (value.length >= 12) {
                                  cubit.setAadhaar(value);
                                  cubit.validateAadhaar(value);
                                }
                              },
                              validator:
                                  (value) => cubit.getAadhaarValidationError(
                                    value ?? '',
                                  ),
                              keyboardType: TextInputType.number,
                              maxLength: 12,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            15.height,
                            AppButton(
                              onPressed: () async {
                                if (state.isAadhaarValid &&
                                    !state.isAadhaarVerified) {
                                  final request = KycInitRequest(
                                    aadharNumber: aadhaarController.text,
                                  );
                                  await kycCubit.sendKycRequest(request);
                                }
                              },
                              textStyle:
                                  state.isAadhaarValid &&
                                          !state.isAadhaarVerified
                                      ? AppTextStyle.h5PrimaryColor
                                      : AppTextStyle.h5WhiteColor,
                              title:
                                  state.isAadhaarVerified
                                      ? context.appText.verified
                                      : context.appText.verifyAadhaar,
                              style:
                                  state.isAadhaarValid &&
                                          !state.isAadhaarVerified
                                      ? AppButtonStyle.outlineAndFilled
                                      : AppButtonStyle.disableButton,
                            ),
                          ],
                        ),
                      ),
                      15.height,
                      BlocListener<EnDhanCubit, EnDhanState>(
                        bloc: cubit,
                        listenWhen:
                            (previous, current) =>
                                previous.aadhaarVerifyOtpState !=
                                current.aadhaarVerifyOtpState,
                        listener: (context, state) {
                          if (state.aadhaarVerifyOtpState?.status ==
                              Status.SUCCESS) {
                            // The verification icon will be updated automatically through BlocBuilder
                          }
                          if (state.aadhaarVerifyOtpState?.status ==
                              Status.ERROR) {
                            final error =
                                state.aadhaarVerifyOtpState?.errorType;
                            ToastMessages.error(
                              message: getErrorMsg(
                                errorType: error ?? GenericError(),
                              ),
                            );
                          }
                        },
                        child: SizedBox.shrink(),
                      ),

                      15.height,

                      // PAN Card
                      _buildLabelWithInfoIcon(
                        context,
                        context.appText.pan,
                        isMandatory: true,
                        isVerified: state.isPanVerified,
                      ),
                      10.height,

                      AppTextField(
                        enableInteractiveSelection: true,
                        mandatoryStar: true,
                        hintText: context.appText.enterPanNumber,
                        controller: panController,
                        onChanged:
                            state.isPanVerified
                                ? null
                                : (value) {
                                  if (value.length >= 10) {
                                    cubit.setPan(value);
                                    cubit.validatePan(value);
                                  }
                                },
                        validator:
                            (value) => cubit.getPanValidationError(value ?? ''),
                        maxLength: 10,
                        readOnly: state.isPanVerified,
                        decoration: commonInputDecoration(
                          hintText: context.appText.enterPanNumber,
                          suffixIcon:
                              state.isPanVerified
                                  ? null
                                  : GestureDetector(
                                    onTap:
                                        state.isPanValid
                                            ? () {
                                              cubit.verifyPan();
                                            }
                                            : null,
                                    child: Text(
                                      context.appText.verify,
                                      style: AppTextStyle.body3.copyWith(
                                        color:
                                            state.isPanValid
                                                ? AppColors.primaryColor
                                                : Colors.grey,
                                        decoration:
                                            state.isPanValid
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
                                        fontWeight:
                                            state.isPanValid
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                        decorationColor:
                                            state.isPanValid
                                                ? AppColors.primaryColor
                                                : Colors.grey,
                                      ),
                                    ).paddingSymmetric(horizontal: 12),
                                  ),
                        ),
                      ),

                      // Listen for manual PAN verification responses
                      BlocListener<EnDhanCubit, EnDhanState>(
                        bloc: cubit,
                        listenWhen:
                            (previous, current) =>
                                previous.panVerificationState !=
                                current.panVerificationState,
                        listener: (context, state) {
                          if (state.panVerificationState?.status ==
                              Status.SUCCESS) {
                            ToastMessages.success(
                              message: context.appText.panVerifiedSuccessfully,
                            );
                          }
                          if (state.panVerificationState?.status ==
                              Status.ERROR) {
                            final error = state.panVerificationState?.errorType;
                            ToastMessages.error(
                              message: getErrorMsg(
                                errorType: error ?? GenericError(),
                              ),
                            );
                          }
                        },
                        child: SizedBox.shrink(),
                      ),

                      10.height,
                      // PAN Document Upload
                      if (showPanUpload)
                        Column(
                          children: [
                            EndhanDocumentUploadWidget(
                              feildTitle: context.appText.uploadDocument,
                              multiFilesList: state.panDocuments,
                              isSingleFile: true,
                              onFilesChanged: (newList) async {
                                cubit.updatePanDocuments(newList);

                                final filePath =
                                    newList.isNotEmpty
                                        ? newList.first['path']
                                        : null;
                                if (filePath != null) {
                                  final uploadResult = await cubit
                                      .uploadDocument(File(filePath));
                                  if (uploadResult?.success ?? false) {
                                    final fileUrl =
                                        uploadResult?.data?.url ?? '';
                                    final updatedDocs = [
                                      {
                                        'path': fileUrl,
                                        'name': newList.first['name'],
                                      },
                                    ];
                                    cubit.updatePanDocuments(updatedDocs);
                                    cubit.setPanImageUploaded(true);
                                  } else {
                                    cubit.setPanImageUploaded(false);
                                  }
                                }
                              },
                            ),
                            if (state.panDocuments.isEmpty &&
                                state.hasAttemptedSubmit)
                              Text(
                                context.appText.panDocumentRequired,
                                style: AppTextStyle.body3.copyWith(
                                  color: AppColors.activeRedColor,
                                ),
                              ).paddingOnly(top: 8.0),
                          ],
                        ),
                      15.height,

                      _buildLabelWithInfoIcon(
                        context,
                        context.appText.identityProof,
                        isMandatory: true,
                      ),
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
                          if (state.identityFrontDocuments.isEmpty &&
                              state.hasAttemptedSubmit)
                            Text(
                              context.appText.identityProofFrontRequired,
                              style: AppTextStyle.body3.copyWith(
                                color: AppColors.activeRedColor,
                              ),
                            ).paddingOnly(top: 8.0),
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
                          if (state.identityBackDocuments.isEmpty &&
                              state.hasAttemptedSubmit)
                            Text(
                              context.appText.identityProofBackRequired,
                              style: AppTextStyle.body3.copyWith(
                                color: AppColors.activeRedColor,
                              ),
                            ).paddingOnly(top: 8.0),
                        ],
                      ),

                      15.height,

                      _buildLabelWithInfoIcon(
                        context,
                        context.appText.addressProof,
                        isMandatory: true,
                      ),
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
                          if (state.addressFrontDocuments.isEmpty &&
                              state.hasAttemptedSubmit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                context.appText.addressProofFrontRequired,
                                style: AppTextStyle.body3.copyWith(
                                  color: AppColors.activeRedColor,
                                ),
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
                          if (state.addressBackDocuments.isEmpty &&
                              state.hasAttemptedSubmit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                context.appText.addressProofBackRequired,
                                style: AppTextStyle.body3.copyWith(
                                  color: AppColors.activeRedColor,
                                ),
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
        ),
      ),
      bottomNavigationBar: BlocConsumer<EnDhanCubit, EnDhanState>(
        bloc: cubit,
        listenWhen:
            (previous, current) =>
                previous.uploadKycState != current.uploadKycState,
        listener: (context, state) {
          if (state.uploadKycState?.status == Status.SUCCESS) {
            _showSuccessDialog(context);
          }
          if (state.uploadKycState?.status == Status.ERROR) {
            final error = state.uploadKycState?.errorType;
            ToastMessages.error(
              message: getErrorMsg(errorType: error ?? GenericError()),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state.uploadKycState?.status == Status.LOADING;
          final bool isFormValid = state.isFormValid;

          return AppButton(
            onPressed: () async {
              if (isLoading) return;

              final bool isAadhaarVerified = state.isAadhaarVerified;
              final bool isPanVerified = state.isPanVerified;

              if (!isAadhaarVerified || !isPanVerified) {
                String message = '';
                if (!isAadhaarVerified && !isPanVerified) {
                  message = context.appText.verifyPanAndAadhaarBeforeSubmit;
                } else if (!isAadhaarVerified) {
                  message = context.appText.verifyAadhaarBeforeSubmit;
                } else if (!isPanVerified) {
                  message = context.appText.verifyPanBeforeSubmit;
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

              if (!formKey.currentState!.validate()) {
                ToastMessages.alert(
                  message: context.appText.pleaseFillAllRequiredFields,
                );
                return;
              }

              if (showPanUpload) {
                if (await cubit.uploadKycDocuments()) {
                  await cubit.uploadKycDocumentsMultipart();
                }
              } else {
                await cubit.uploadKycDocumentsMultipart();
              }
            },
            title: context.appText.submit,
            isLoading: isLoading,
            style:
                isFormValid
                    ? AppButtonStyle.primary
                    : AppButtonStyle.disableButton,
          ).paddingOnly(bottom: 44, right: 20, left: 20, top: 15);
        },
      ),
    );
  }

  Widget _buildLabelWithInfoIcon(
    BuildContext context,
    String label, {
    bool isMandatory = false,
    bool isVerified = false,
  }) {
    return Row(
      children: [
        Text(label, style: AppTextStyle.textFiled),
        if (isMandatory)
          Text(
            "*",
            style: AppTextStyle.textFiled.copyWith(
              color: AppColors.activeRedColor,
            ),
          ),
        const Spacer(),
        if (isVerified)
          Icon(Icons.verified, color: Colors.green, size: 20)
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
      message = context.appText.aadhaarInfo;
    } else if (fieldName == context.appText.pan) {
      message = context.appText.panInfo;
    } else if (fieldName == context.appText.identityProof) {
      message = context.appText.identityProofInfo;
    } else if (fieldName == context.appText.addressProof) {
      message = context.appText.addressProofInfo;
    } else {
      message = context.appText.invalidFieldInfo;
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
