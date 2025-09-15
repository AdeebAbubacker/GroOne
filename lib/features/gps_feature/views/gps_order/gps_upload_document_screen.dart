import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kavach/view/kavach_choose_your_preference_screen.dart';
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
import 'package:gro_one_app/utils/textFieldInputFormatter/upper_case_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_field.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/upload_attachment_files.dart';
import '../../../kyc/api_request/init_kyc_request.dart';
import '../../../kyc/cubit/kyc_cubit.dart';
import '../../../kyc/helper/kyc_helper.dart';
import '../../../kyc/model/aadhar_status_response.dart';
import '../../../kyc/model/kyc_init_response.dart';
import '../../../kyc/view/kyc_verification_webview.dart';
import '../../../profile/cubit/profile/profile_cubit.dart';
import '../../../profile/view/support_screen.dart';
import '../../../profile/view/widgets/add_new_support_ticket.dart';
import '../../cubit/gps_order_cubit_folder/gps_upload_document_cubit.dart';
import '../../cubit/gps_order_cubit_folder/gps_upload_document_state.dart';
import '../../gps_order_repo/gps_order_api_repository.dart';
import 'gps_models_screen.dart';

class GpsUploadDocumentScreen extends StatelessWidget {
  bool fromKavachScreen;

  GpsUploadDocumentScreen({super.key, this.fromKavachScreen = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GpsUploadDocumentCubit(locator<GpsOrderApiRepository>()),
      child: _GpsUploadDocumentContent(fromKavachScreen),
    );
  }
}

class _GpsUploadDocumentContent extends StatefulWidget {
  bool fromKavachScreen;

  _GpsUploadDocumentContent(this.fromKavachScreen);

  @override
  State<_GpsUploadDocumentContent> createState() =>
      _GpsUploadDocumentContentState();
}

class _GpsUploadDocumentContentState extends State<_GpsUploadDocumentContent> {
  final aadharNoController = TextEditingController();
  String? aadharRequestId;

  final kycBloc = locator<KycCubit>();
  final profileCubit = locator<ProfileCubit>();

  final panNoController = TextEditingController();

  // Only PAN document list
  List<Map<String, dynamic>> panDocList = [];
  final _formKey = GlobalKey<FormState>();
  bool panNoVerified = false;

  @override
  void dispose() {
    aadharNoController.dispose();
    panNoController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.kycDocumentsUploadedSuccessfully,
        onContinue: () {
          Navigator.of(context).pop();
          if (widget.fromKavachScreen) {
            Navigator.of(
              context,
            ).pushReplacement(commonRoute(KavachChooseYourPreferenceScreen()));
          } else {
            Navigator.of(
              context,
            ).pushReplacement(commonRoute(GpsModelsScreen()));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GpsUploadDocumentCubit>();
    Future<void> checkKycVerification(
      AadharVerificationData? aadharVerificationData,
    ) async {
      String? statusVerified = aadharVerificationData?.status;
      if (statusVerified == "VERIFIED") {
        final pdfPath = await KycHelper.saveBase64PdfToFile(
          aadharVerificationData?.dataPdf ?? "",
        );
        await cubit.uploadAadhaarPdfFile(File(pdfPath));

        cubit.setAadhaar(aadharNoController.text);
        cubit.validateAadhaar(aadharNoController.text);
        cubit.markAadhaarVerified();
      }
    }

    Future<void> checkVerification(KycInitResponse? kycInitResponse) async {
      String? sdkUrl = kycInitResponse?.sdkUrl ?? "";
      aadharRequestId ??= kycInitResponse?.requestId ?? "";

      if (sdkUrl.isNotEmpty) {
        final isVerified = await Navigator.push(
          context,
          commonRoute(KycVerificationWebView(url: sdkUrl)),
        );

        if (isVerified == true && aadharRequestId != null) {
          await kycBloc.getKYCStatus(aadharRequestId!);
        }
      }
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.uploadYourDocument,
        isLeading: true,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.of(context).push(
                commonRoute(
                  LpSupport(showBackButton: true, ticketTag: TicketTags.GPS),
                  isForward: true,
                ),
              );
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
        ],
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
                    _buildLabelWithInfoIcon(
                      context,
                      context.appText.pan,
                      isMandatory: false, // PAN is optional
                      isVerified: panNoVerified,
                    ),

                    // _buildLabelWithInfoIcon(context, 'PAN (Optional)', isMandatory: true, isVerified: state.isPanVerified),
                    10.height,
                    AppTextField(
                      enableInteractiveSelection: true,
                      hintText: context.appText.enterPanNumber,
                      controller: panNoController,
                      inputFormatters: [UpperCaseTextFormatter()],
                      maxLength: 10,
                      validator:
                          (value) => cubit.getPanValidationError(value ?? ''),
                      onChanged: (value) {
                        state.isPanVerified = false;
                        cubit.setPan(value);
                        cubit.validatePan(value);
                        panNoVerified = false;
                        setState(() {});
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
                      onDelete: (v) {
                        setState(() {});
                      },
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
          // final bool isFormValid =
          //     state.isAadhaarVerified; // Only Aadhaar verification is required, PAN is optional
          panNoVerified =
              state.isPanVerified; // As per change request PAN is required
          return AppButton(
            onPressed:
                (!isLoading &&
                        panNoVerified &&
                        panDocList.isNotEmpty &&
                        panDocList[0]['fileName'] != null &&
                        panDocList[0]['fileName'].isNotEmpty)
                    ? () {
                      // cubit.markFormSubmitted();
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
                    : () {
                      ToastMessages.alert(
                        message: context.appText.pleaseFillAllRequiredFields,
                      );
                    },
            title: context.appText.submit,
            isLoading: isLoading,
            style:
                panNoVerified &&
                        panDocList.isNotEmpty &&
                        panDocList[0]['fileName'] != null &&
                        panDocList[0]['fileName'].isNotEmpty
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
      message = context.appText.aadhaarInfo;
    } else if (fieldName == "${context.appText.pan} (Optional)") {
      message = context.appText.panInfo;
    } else if (fieldName == 'PAN Document') {
      message = context.appText.panDocumentInfo;
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

  // Resend OTP timer variables
  bool _canResendOtp = false;
  int _resendTimer = 10; // 10 seconds countdown
  Timer? _timer;

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
    _slideAnimationController.forward();

    // Start the resend timer
    _startResendTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideAnimationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResendOtp = false;
    _resendTimer = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
          } else {
            _canResendOtp = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void _resetResendTimer() {
    _timer?.cancel();
    _startResendTimer();
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
                previous.aadhaarVerifyOtpState?.status !=
                current.aadhaarVerifyOtpState?.status,
        listener: (context, state) {
          if (state.aadhaarVerifyOtpState?.status == Status.SUCCESS) {
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
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Instruction text matching the image design
                  Text(
                    context.appText.enterOtpSentToMobile,
                    style: AppTextStyle.body2.copyWith(
                      color: AppColors.primaryTextColor,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  32.height,

                  // OTP Input Field matching the image design (6 fields)
                  Column(
                    children: [
                      OtpTextField(
                        numberOfFields: 6,
                        borderColor: AppColors.borderColor,
                        showFieldAsBox: true,
                        borderRadius: BorderRadius.circular(8),
                        fieldWidth: 45,
                        fieldHeight: 60,
                        textStyle: AppTextStyle.h4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          letterSpacing: 2,
                        ),
                        enabledBorderColor: AppColors.borderColor,
                        focusedBorderColor: AppColors.primaryColor,
                        cursorColor: AppColors.primaryColor,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              onPressed:
                                  isLoading
                                      ? () {}
                                      : () {
                                        if (otpValue.length == 6) {
                                          _verifyOtp(otpValue);
                                        } else {
                                          ToastMessages.alert(
                                            message:
                                                'Please enter valid 6-digit OTP',
                                          );
                                        }
                                      },
                              title:
                                  isLoading
                                      ? 'Verifying...'
                                      : context.appText.verifyOtp,
                              isLoading: isLoading,
                              style:
                                  otpValue.length == 6 && !isLoading
                                      ? AppButtonStyle.primary
                                      : AppButtonStyle.disableButton,
                            ),
                          ),

                          // Resend OTP option with timer
                          if (!isLoading && !isSuccess)
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: Duration(milliseconds: 300),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextButton(
                                  onPressed:
                                      _canResendOtp
                                          ? () {
                                            widget.cubit.sendAadhaarOtp();
                                            _resetResendTimer();
                                            ToastMessages.success(
                                              message:
                                                  context
                                                      .appText
                                                      .otpResentSuccessfully,
                                            );
                                          }
                                          : null,
                                  child: Text(
                                    _canResendOtp
                                        ? (context.appText.resendOtp)
                                        : 'Resend OTP in ${_resendTimer}s',
                                    style: AppTextStyle.body3.copyWith(
                                      color:
                                          _canResendOtp
                                              ? AppColors.primaryColor
                                              : AppColors.primaryTextColor
                                                  .withValues(alpha: 0.5),
                                      decoration:
                                          _canResendOtp
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
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
      ),
    );
  }

  void _verifyOtp(String otp) {
    widget.cubit.verifyAadhaarOtp(otp);

    // Add a safety timeout to close bottom sheet if verification takes too long
    final context = this.context;
    Future.delayed(Duration(seconds: 10), () {
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
        ToastMessages.error(message: context.appText.verificationTimeout);
      }
    });
  }
}
