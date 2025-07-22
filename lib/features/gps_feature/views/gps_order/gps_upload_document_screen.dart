import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_field.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/upload_attachment_files.dart';
import '../../cubit/gps_order_cubit_folder/gps_upload_document_cubit.dart';
import '../../cubit/gps_order_cubit_folder/gps_upload_document_state.dart';
import '../../gps_order_repo/gps_order_api_repository.dart';
import 'gps_models_screen.dart';

class GpsUploadDocumentScreen extends StatelessWidget {
  const GpsUploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GpsUploadDocumentCubit(locator<GpsOrderApiRepository>()),
      child: const _GpsUploadDocumentContent(),
    );
  }
}

class _GpsUploadDocumentContent extends StatefulWidget {
  const _GpsUploadDocumentContent();

  @override
  State<_GpsUploadDocumentContent> createState() =>
      _GpsUploadDocumentContentState();
}

class _GpsUploadDocumentContentState extends State<_GpsUploadDocumentContent> {
  final aadharNoController = TextEditingController();
  final panNoController = TextEditingController();
  // Only PAN document list
  List<Map<String, dynamic>> panDocList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    aadharNoController.dispose();
    panNoController.dispose();
    super.dispose();
  }

  void _showOtpBottomSheet(BuildContext context, GpsUploadDocumentCubit cubit) {
    // Add a small delay for smoother transition
    Future.delayed(Duration(milliseconds: 100), () {
      if (context.mounted) {
        commonBottomSheetWithBGBlur(
          context: context,
          screen: GpsOtpVerificationBottomSheet(cubit: cubit),
        );
      }
    });
  }

  void _showSuccessDialog(BuildContext context) {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.kycDocumentsUploadedSuccessfully,
        onContinue: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(commonRoute(GpsModelsScreen()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GpsUploadDocumentCubit>();
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.uploadYourDocument,
        isLeading: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: BlocBuilder<GpsUploadDocumentCubit, GpsUploadDocumentState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Aadhaar Card Section
                    _buildLabelWithInfoIcon(
                      context,
                      context.appText.aadhaarCard,
                      isMandatory: true,
                      isVerified: state.isAadhaarVerified,
                    ),
                    10.height,
                    AppTextField(
                      hintText: context.appText.enter12DigitAadhaar,
                      controller: aadharNoController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator:
                          (value) =>
                              cubit.getAadhaarValidationError(value ?? ''),
                      onChanged: (value) {
                        cubit.setAadhaar(value);
                        cubit.validateAadhaar(value);
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                    ),
                    15.height,
                    BlocListener<
                      GpsUploadDocumentCubit,
                      GpsUploadDocumentState
                    >(
                      listenWhen:
                          (previous, current) =>
                              previous.aadhaarSendOtpState !=
                              current.aadhaarSendOtpState,
                      listener: (context, state) {
                        print(
                          '🔍 GPS Aadhaar Send OTP State changed: ${state.aadhaarSendOtpState?.status}',
                        );
                        if (state.aadhaarSendOtpState?.status ==
                            Status.SUCCESS) {
                          print('🔍 GPS Showing OTP bottom sheet');
                          _showOtpBottomSheet(context, cubit);
                        }
                        if (state.aadhaarSendOtpState?.status == Status.ERROR) {
                          print('🔍 GPS Aadhaar Send OTP failed');
                          final error = state.aadhaarSendOtpState?.errorType;
                          ToastMessages.error(
                            message: getErrorMsg(
                              errorType: error ?? GenericError(),
                            ),
                          );
                        }
                      },
                      child: AppButton(
                        onPressed:
                            (state.isAadhaarValid && !state.isAadhaarVerified)
                                ? () {
                                  print('🔍 GPS Get OTP button pressed');
                                  print(
                                    '🔍 GPS Current aadhaar: "${state.aadhaar}"',
                                  );
                                  cubit.sendAadhaarOtp();
                                }
                                : () {},
                        title:
                            state.isAadhaarVerified
                                ? context.appText.verified
                                : context.appText.getOtp,
                        textStyle: TextStyle(color: AppColors.primaryColor),
                        style:
                            (state.isAadhaarValid && !state.isAadhaarVerified)
                                ? AppButtonStyle.outlineAndFilled
                                : AppButtonStyle.disableButton,
                      ),
                    ),
                    30.height,

                    // PAN Card Section
                    _buildLabelWithInfoIcon(
                      context,
                      "${context.appText.pan} (Optional)",
                      isMandatory: false, // PAN is optional
                      isVerified: state.isPanVerified,
                    ),

                    // _buildLabelWithInfoIcon(context, 'PAN (Optional)', isMandatory: true, isVerified: state.isPanVerified),
                    10.height,
                    AppTextField(
                      hintText: context.appText.enterPanNumber,
                      controller: panNoController,
                      maxLength: 10,
                      validator:
                          (value) => cubit.getPanValidationError(value ?? ''),
                      onChanged: (value) {
                        cubit.setPan(value);
                        cubit.validatePan(value);
                      },
                    ),
                    10.height,
                    BlocListener<
                      GpsUploadDocumentCubit,
                      GpsUploadDocumentState
                    >(
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

                    // Document Upload Section
                    UploadAttachmentFiles(
                      multiFilesList: panDocList,
                      isSingleFile: true,
                      thenUploadFileToSever: () {
                        // Trigger rebuild when documents are added/removed
                        setState(() {});
                        // Update the cubit with the current document list
                        cubit.updatePanDocuments(panDocList);
                      },
                    ),
                    // Removed PAN document validation since it's optional
                    30.height,
                  ],
                ).paddingAll(commonSafeAreaPadding),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocConsumer<
        GpsUploadDocumentCubit,
        GpsUploadDocumentState
      >(
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
          final bool isFormValid =
              state.isAadhaarVerified; // Only Aadhaar verification is required, PAN is optional

          return AppButton(
            onPressed:
                (!isLoading && isFormValid)
                    ? () {
                      print('🔍 GPS Submit button pressed');
                      cubit.debugCubitStatus();
                      cubit.markFormSubmitted();
                      if (_formKey.currentState!.validate()) {
                        // Update the cubit with all document lists
                        cubit.updatePanDocuments(panDocList);
                        // Call the upload API
                        cubit.uploadKycDocuments();
                      } else {
                        ToastMessages.alert(
                          message: context.appText.pleaseFillAllRequiredFields,
                        );
                      }
                    }
                    : () {},
            title: context.appText.submit,
            isLoading: isLoading,
            style:
                isFormValid
                    ? AppButtonStyle.primary
                    : AppButtonStyle.disableButton,
          ).paddingAll(20);
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
          SvgPicture.asset(AppIcons.svg.tick, width: 22, height: 22)
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
      message =
          '• Enter your 12-digit Aadhaar number\n'
          '• Aadhaar number should not start with 0 or 1\n'
          '• All digits should not be the same\n'
          '• You will receive OTP for verification';
    } else if (fieldName == context.appText.pan) {
      message =
          '• Enter your 10-character PAN number (Optional)\n'
          '• Format: ABCDE1234F (5 letters + 4 digits + 1 letter)\n'
          '• PAN will be automatically verified when complete\n'
          '• You can skip this field if you don\'t have a PAN';
    } else if (fieldName == 'PAN Document') {
      message =
          '• Upload your PAN card document (Optional)\n'
          '• This document will be used for KYC requirements\n'
          '• Ensure all details are clearly visible\n'
          '• File size should be less than 5MB\n'
          '• Supported formats: PDF, JPG, PNG\n'
          '• You can skip this if you don\'t have a PAN document';
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

// GPS OTP Verification Bottom Sheet
class GpsOtpVerificationBottomSheet extends StatefulWidget {
  final GpsUploadDocumentCubit cubit;

  const GpsOtpVerificationBottomSheet({super.key, required this.cubit});

  @override
  State<GpsOtpVerificationBottomSheet> createState() =>
      _GpsOtpVerificationBottomSheetState();
}

class _GpsOtpVerificationBottomSheetState
    extends State<GpsOtpVerificationBottomSheet>
    with TickerProviderStateMixin {
  String otpValue = '';
  late AnimationController _animationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.verifyYourKyc,
      hideDivider: false,
      isCloseButton: true,
      body: BlocListener<GpsUploadDocumentCubit, GpsUploadDocumentState>(
        bloc: widget.cubit,
        listenWhen:
            (previous, current) =>
                previous.aadhaarVerifyOtpState?.status != current.aadhaarVerifyOtpState?.status,
        listener: (context, state) {
          print(
            '🔍 GPS OTP Verification State changed: ${state.aadhaarVerifyOtpState?.status}',
          );
          if (state.aadhaarVerifyOtpState?.status == Status.SUCCESS) {
            print('🔍 GPS OTP verification successful, closing bottom sheet');
            // Close bottom sheet immediately
            Navigator.of(context).pop();
            // Show success message after closing
            Future.delayed(Duration(milliseconds: 300), () {
              if (context.mounted) {
                ToastMessages.success(
                  message: context.appText.aadhaarVerifiedSuccessfully,
                );
              }
            });
          }
          if (state.aadhaarVerifyOtpState?.status == Status.ERROR) {
            print('🔍 GPS OTP verification failed');
            final error = state.aadhaarVerifyOtpState?.errorType;
            ToastMessages.error(
              message: getErrorMsg(errorType: error ?? GenericError()),
            );
          }
        },
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                20.height,

                // Simple instruction text with improved styling
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    context.appText.enterOtpSentToMobile,
                    style: AppTextStyle.body3.copyWith(
                      color: AppColors.primaryTextColor,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                32.height,

                // OTP Input Field with improved styling
                Container(
                  //padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      OtpTextField(
                        numberOfFields: 6,
                        borderColor: AppColors.borderColor,
                        showFieldAsBox: true,
                        borderRadius: BorderRadius.circular(16),
                        fieldWidth: 50,
                        fieldHeight: 60,
                        textStyle: AppTextStyle.h4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          letterSpacing: 3,
                        ),
                        enabledBorderColor: AppColors.borderColor,
                        focusedBorderColor: AppColors.primaryColor,
                        cursorColor: AppColors.primaryColor,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       // margin: const EdgeInsets.symmetric(horizontal: 6),
                        onCodeChanged: (String code) {
                          setState(() {
                            otpValue = code;
                          });
                        },
                        onSubmit: (String verificationCode) {
                          setState(() {
                            otpValue = verificationCode;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                32.height,

                // Verify Button
                BlocBuilder<GpsUploadDocumentCubit, GpsUploadDocumentState>(
                  bloc: widget.cubit,
                  builder: (context, state) {
                    final bool isLoading =
                        state.aadhaarVerifyOtpState?.status == Status.LOADING;
                    final bool isSuccess =
                        state.aadhaarVerifyOtpState?.status == Status.SUCCESS;

                    return Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: AppButton(
                            onPressed: isLoading
                                ? () {}
                                : () {
                                    if (otpValue.length == 6) {
                                      _verifyOtp(otpValue);
                                    } else {
                                      ToastMessages.alert(
                                        message: context.appText.pleaseEnterValid6DigitOtp,
                                      );
                                    }
                                  },
                            title: isLoading 
                                ? 'Verifying...'
                                : context.appText.verifyOtp,
                            isLoading: isLoading,
                            style: otpValue.length == 6 && !isLoading
                                ? AppButtonStyle.primary
                                : AppButtonStyle.disableButton,
                          ),
                        ),
                        
                        // Resend OTP option with improved styling
                        if (!isLoading && !isSuccess)
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(milliseconds: 300),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextButton(
                                onPressed: () {
                                  widget.cubit.sendAadhaarOtp();
                                  ToastMessages.success(
                                    message: 'OTP resent successfully',
                                  );
                                },
                                child: Text(
                                  context.appText.resendOtp ?? 'Resend OTP',
                                  style: AppTextStyle.body3.copyWith(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyOtp(String otp) {
    // Debug the cubit status before verification
    widget.cubit.debugCubitStatus();
    // Clear any previous state and verify OTP
    widget.cubit.verifyAadhaarOtp(otp);
    
    // Add a safety timeout to close bottom sheet if verification takes too long
    final context = this.context;
    Future.delayed(Duration(seconds: 10), () {
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
        ToastMessages.error(message: 'Verification timeout. Please try again.');
      }
    });
  }
}
