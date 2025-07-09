import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_field.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/upload_attachment_files.dart';
import '../../../../utils/validator.dart';
import 'gps_models_screen.dart';
import '../../cubit/gps_order_cubit_folder/gps_upload_document_cubit.dart';
import '../../cubit/gps_order_cubit_folder/gps_upload_document_state.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';

class GpsUploadDocumentScreen extends StatelessWidget {
  const GpsUploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<GpsUploadDocumentCubit>(),
      child: const _GpsUploadDocumentContent(),
    );
  }
}

class _GpsUploadDocumentContent extends StatefulWidget {
  const _GpsUploadDocumentContent();

  @override
  State<_GpsUploadDocumentContent> createState() => _GpsUploadDocumentContentState();
}

class _GpsUploadDocumentContentState extends State<_GpsUploadDocumentContent> {
  final aadharNoController = TextEditingController();
  final panNoController = TextEditingController();
  List<Map<String, dynamic>> gpsDocList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    aadharNoController.dispose();
    panNoController.dispose();
    super.dispose();
  }

  void _showOtpBottomSheet(BuildContext context, GpsUploadDocumentCubit cubit) {
    commonBottomSheetWithBGBlur(
      context: context,
      screen: GpsOtpVerificationBottomSheet(cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GpsUploadDocumentCubit>();
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.uploadYourDocument,
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
                    _buildLabelWithInfoIcon(context, 'Aadhaar Card', isMandatory: true, isVerified: state.isAadhaarVerified),
                    10.height,
                    AppTextField(
                      hintText: 'Enter 12-digit Aadhaar number',
                      controller: aadharNoController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => cubit.getAadhaarValidationError(value ?? ''),
                      onChanged: (value) {
                        cubit.setAadhaar(value);
                        cubit.validateAadhaar(value);
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                    ),
                    15.height,
                    BlocListener<GpsUploadDocumentCubit, GpsUploadDocumentState>(
                      listenWhen: (previous, current) => previous.aadhaarSendOtpState != current.aadhaarSendOtpState,
                      listener: (context, state) {
                        if (state.aadhaarSendOtpState?.status == Status.SUCCESS) {
                          _showOtpBottomSheet(context, cubit);
                        }
                        if (state.aadhaarSendOtpState?.status == Status.ERROR) {
                          final error = state.aadhaarSendOtpState?.errorType;
                          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                        }
                      },
                      child: AppButton(
                        onPressed: (state.isAadhaarValid && !state.isAadhaarVerified)
                            ? () { cubit.sendAadhaarOtp(); }
                            : () {},
                        title: state.isAadhaarVerified ? 'Verified' : context.appText.getOtp,
                        textStyle: TextStyle(color: AppColors.primaryColor),
                        style: (state.isAadhaarValid && !state.isAadhaarVerified)
                            ? AppButtonStyle.outlineAndFilled
                            : AppButtonStyle.disableButton,
                      ),
                    ),
                    30.height,

                    // PAN Card Section
                    _buildLabelWithInfoIcon(context, 'PAN (Optional)', isMandatory: true, isVerified: state.isPanVerified),
                    10.height,
                    AppTextField(
                      hintText: 'Enter PAN number (e.g., ABCDE1234F)',
                      controller: panNoController,
                      maxLength: 10,
                      validator: (value) => cubit.getPanValidationError(value ?? ''),
                      onChanged: (value) {
                        cubit.setPan(value);
                        cubit.validatePan(value);
                      },
                    ),
                    10.height,
                    BlocListener<GpsUploadDocumentCubit, GpsUploadDocumentState>(
                      listenWhen: (previous, current) => previous.panVerificationState != current.panVerificationState,
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

                    // Document Upload Section
                    UploadAttachmentFiles(
                      multiFilesList: gpsDocList,
                      isSingleFile: true,
                    ),
                    if (gpsDocList.isEmpty && state.hasAttemptedSubmit)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'GPS document is required',
                          style: AppTextStyle.body3.copyWith(color: AppColors.activeRedColor),
                        ),
                      ),
                    30.height,
                  ],
                ).paddingAll(commonSafeAreaPadding),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: AppButton(
        title: context.appText.submit,
        onPressed: () {
          cubit.markFormSubmitted();
          if (_formKey.currentState!.validate() && gpsDocList.isNotEmpty) {
            // Add your submit logic here
            Navigator.of(context).push(commonRoute(GpsModelsScreen()));
          } else {
            ToastMessages.alert(message: "Please fill all required fields correctly");
          }
        },
      ).paddingAll(20),
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
                '• PAN will be automatically verified when complete';
        break;
      case 'GPS Document':
        message = '• Upload your GPS device document\n'
                '• Ensure all details are clearly visible\n'
                '• File size should be less than 5MB\n'
                '• Supported formats: PDF, JPG, PNG';
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

// GPS OTP Verification Bottom Sheet
class GpsOtpVerificationBottomSheet extends StatefulWidget {
  final GpsUploadDocumentCubit cubit;

  const GpsOtpVerificationBottomSheet({
    super.key,
    required this.cubit,
  });

  @override
  State<GpsOtpVerificationBottomSheet> createState() => _GpsOtpVerificationBottomSheetState();
}

class _GpsOtpVerificationBottomSheetState extends State<GpsOtpVerificationBottomSheet> {
  String otpValue = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: 'Verify Your KYC',
      hideDivider: false,
      isCloseButton: true,
      body: BlocListener<GpsUploadDocumentCubit, GpsUploadDocumentState>(
        bloc: widget.cubit,
        listenWhen: (previous, current) => previous.aadhaarVerifyOtpState != current.aadhaarVerifyOtpState,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            20.height,

            Text(
            'Enter the OTP sent to your registered Mobile number',
            style: AppTextStyle.body3,
            overflow: TextOverflow.ellipsis,
          ),
           Text(
          'OTP: 123456',
          style: AppTextStyle.body3.copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
            20.height,
            OtpTextField(
              numberOfFields: 6,
              borderColor: AppColors.primaryColor,
              showFieldAsBox: true,
              borderRadius: BorderRadius.circular(8),
              fieldWidth: 45,
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                setState(() {
                  otpValue = verificationCode;
                });
              },
            ),
            30.height,
            BlocBuilder<GpsUploadDocumentCubit, GpsUploadDocumentState>(
              bloc: widget.cubit,
              builder: (context, state) {
                final bool isLoading = state.aadhaarVerifyOtpState?.status == Status.LOADING;
                return AppButton(
                  onPressed: isLoading
                      ? () {}
                      : () {
                          if (otpValue.length == 6) {
                            widget.cubit.verifyAadhaarOtp(otpValue);
                          } else {
                            ToastMessages.alert(message: 'Please enter a valid 6-digit OTP');
                          }
                        },
                  title: 'Verify OTP',
                  isLoading: isLoading,
                  style: otpValue.length == 6 && !isLoading
                      ? AppButtonStyle.primary
                      : AppButtonStyle.disableButton,
                );
              },
            ),
         
          ],
        ),
      ),
    );
  }
}
