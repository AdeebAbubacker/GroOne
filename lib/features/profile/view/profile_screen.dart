import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/bloc/kyc_bloc.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/bloc/profile_bloc.dart';
import 'package:gro_one_app/features/profile/view/benefits_of_membership_screen.dart';
import 'package:gro_one_app/features/profile/view/master_screen.dart';
import 'package:gro_one_app/features/profile/view/my_account_screen.dart';
import 'package:gro_one_app/features/profile/view/my_document_screen.dart';
import 'package:gro_one_app/features/profile/view/setting_screen.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/features/profile/view/transaction_screen.dart';
import 'package:gro_one_app/utils/common_dialog_view/log_out_dialogue_ui.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/log_out_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_file_and_image_bottom_sheet.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  ProfileDetailsData profileData;
  ProfileScreen({super.key, required this.profileData});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseState<ProfileScreen> {

  final lpHomeLocator = locator<LpHomeBloc>();
  final kycBloc = locator<KycCubit>();
  final lpHomeCubit = locator<LPHomeCubit>();
  final vpHomeBloc = locator<VpCreationBloc>();
  final profileBloc = locator<ProfileBloc>();

  final double profileSize = 120;

  dynamic pickImage;

  File? _croppedImage;

  String appVersion = '';

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await lpHomeLocator.getUserId();
    profileImage = widget.profileData.details!.profileImageUrl ?? "";
    appVersion = await appVersionInfo();
    setState(() {});
    debugPrint("user id ${lpHomeLocator.userId}");
  });

  void disposeFunction() => frameCallback(() {});

  void logoutDialogPopUp(BuildContext context) {
    AppDialog.show(
      context,
      child: CommonDialogView(
        yesButtonText: context.appText.logOut,
        noButtonText: context.appText.cancel,
        showYesNoButtonButtons: true,
        hideCloseButton: true,
        onClickYesButton: () {
          context.pop();
          vpHomeBloc.add(LogoutAPIRequested(apiRequest: LogOutRequest(customerId: lpHomeLocator.userId ?? "")),
          );
        },
        child: LogOutDialogueUi(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.profile),

      body:
          SafeArea(
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                15.width,
                // profile image upload widget
                buildUploadProfilePictureWidget(context: context),

                // profile details widget
                profileDetailWidget(),

                // profile options widget
                profileOptionWidget(context),

                5.height,
                profileVersionWidget(),
                30.height,
              ],
            ),
          ).withScroll(),
    );
  }

  profileDetailWidget() {
    return BlocConsumer(
      bloc: lpHomeLocator,
      builder: (context, state) {
        return Column(
          spacing: 10,
          children: [
            if (widget.profileData.details != null)
              Text(
                widget.profileData.details!.companyName,
                style: AppTextStyle.h5,
              ),

            Text(
              widget.profileData.customer!.customerName,
              style: AppTextStyle.blackColor15w500,
            ),

            if(widget.profileData.customer!.blueId.isNotEmpty)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  commonRoute(BenefitsOfMembershipScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor,
                ),
                child: Text(
                  "${context.appText.blueMembershipId} : ${widget.profileData.customer!.blueId ?? "--"}",
                  style: AppTextStyle.h5WhiteColor,
                ),
              ),
            ),
          ],
        );
      },
      listener: _listener,
    );
  }

  _listener(BuildContext context, HomeState state) {
    if (state is ProfileDetailSuccess) {
      widget.profileData = state.profileDetailResponse.data!;
    }
  }

  Widget profileOptionWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          10.height,
          BlocConsumer<LpHomeBloc, HomeState>(
            listener: _listener,
            bloc: lpHomeLocator,
            builder: (context, state) {
              return profileWidget(
                imageString: AppImage.svg.user,
                text: context.appText.myAccount,
                onTap: () {
                  Navigator.push(
                    context,
                    commonRoute(
                      LpMyAccount(profileData: widget.profileData),
                      isForward: true,
                    ),
                  ).then((onValue) {
                    lpHomeCubit.fetchProfileDetail();
                  });
                },
              );
            },
          ),
          dividerWidget(),

          profileWidget(
            imageString: AppImage.svg.master,
            text: "Master",
            onTap: () {
              Navigator.of(
                context,
              ).push(commonRoute(MasterScreen(), isForward: true));
            },
          ),

          dividerWidget(),

          profileWidget(
            imageString: AppImage.svg.routes,
            text: "Routes",
            onTap: () {
              ///todo - routes to be done later
            },
          ),

          dividerWidget(),

          profileWidget(
            imageString: AppImage.svg.myDocuments,
            text: "My Documents",
            onTap: () {
              Navigator.of(
                context,
              ).push(commonRoute(MyDocumentScreen(), isForward: true));
            },
          ),

          dividerWidget(),

          profileWidget(
            imageString: AppImage.svg.transaction,
            text: context.appText.transactions,
            onTap: () {
              Navigator.of(
                context,
              ).push(commonRoute(LpTransaction(), isForward: true));
            },
          ),

          dividerWidget(),

          profileWidget(
            imageString: AppImage.svg.settings,
            text: context.appText.settings,
            onTap: () {
              Navigator.of(
                context,
              ).push(commonRoute(LpSetting(), isForward: true));
            },
          ),

          dividerWidget(),

          profileWidget(
            imageString: AppImage.svg.support,
            text: context.appText.support,
            onTap: () {
              Navigator.of(
                context,
              ).push(commonRoute(LpSupport(), isForward: true));
            },
          ),
          dividerWidget(),
          BlocListener<VpCreationBloc, VpCreationState>(
            bloc: vpHomeBloc,
            listener: (context, state) {
              if (state is LogOutAPISuccess) {
                vpHomeBloc.add(LogoutRequested());
              }
              if (state is LogoutSuccess) {
                context.go(AppRouteName.chooseLanguage);
              }
              if (state is LogoutError) {
                ToastMessages.error(
                  message: getErrorMsg(errorType: state.errorType),
                );
              }
            },

            child: profileWidget(
              imageString: AppImage.svg.logOut,
              text: context.appText.logOut,
              onTap: () {
                logoutDialogPopUp(context);
              },
              showArrow: false,
            ),
          ),
          10.height,
        ],
      ),
    );
  }

  dividerWidget() {
    return Divider(color: AppColors.dividerColor, thickness: 0.5, indent: 20);
  }

  String profileImage = "";

  Widget buildUploadProfilePictureWidget({required BuildContext context}) {
    return SizedBox(
      height: profileSize,
      width: profileSize,
      child: Container(
        height: profileSize,
        width: profileSize,
        decoration: BoxDecoration(
          color: AppColors.profileBgGrey,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          getInitialsFromName(
            this,
            name: widget.profileData.details?.companyName ?? '',
          ),
          style: GoogleFonts.ubuntu(
            fontSize: profileSize * 0.35,
            color: AppColors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  profileVersionWidget() {
    return Text(
      "Version $appVersion",
      style: AppTextStyle.textGreyDetailColor14w400,
    );
  }

  // Widget buildUploadProfilePictureWidget({required BuildContext context}) {
  //   return BlocConsumer(
  //     bloc: kycBloc,
  //     builder: (context, state) {
  //       return InkWell(
  //         onTap: () {
  //           commonBottomSheet(
  //             context: context,
  //             barrierDismissible: true,
  //             screen: const UploadFileAndImageBottomSheet(),
  //           ).then((value) async {
  //             if (value != null && value["path"] != null) {
  //               File file = File(value["path"]);
  //               pickImage = file;
  //
  //               final croppedFile = await ImageCropper().cropImage(
  //                 sourcePath: pickImage.path,
  //                 aspectRatio: const CropAspectRatio(
  //                   ratioX: 1,
  //                   ratioY: 1,
  //                 ),
  //
  //                 uiSettings: [
  //                   AndroidUiSettings(
  //                     toolbarTitle: 'Crop Image',
  //                     toolbarColor: AppColors.primaryColor,
  //                     toolbarWidgetColor: Colors.white,
  //                     initAspectRatio: CropAspectRatioPreset.ratio16x9,
  //                     lockAspectRatio: true,
  //                   ),
  //                   IOSUiSettings(title: 'Crop Image'),
  //                 ],
  //               );
  //
  //               if (croppedFile != null) {
  //                 setState(() {
  //                   _croppedImage = File(croppedFile.path);
  //                   kycBloc.uploadFile(_croppedImage!);
  //                 });
  //               }
  //             } else {
  //               // viewModel.setPickImageUIState(null);
  //             }
  //           });
  //         },
  //         child: SizedBox(
  //           height: profileSize,
  //           width: profileSize,
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               BlocConsumer(
  //                 bloc: lpHomeLocator,
  //                 builder: (context, state) {
  //                   return profileImage.isEmpty
  //                       ? Container(
  //                     height: profileSize,
  //                     width: profileSize,
  //                     decoration: BoxDecoration(
  //                       color: AppColors.profileBgGrey,
  //                       shape: BoxShape.circle,
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       _getInitials(widget.profileData.details?.companyName ?? ''),
  //                       style: TextStyle(
  //                         fontSize: profileSize * 0.35,
  //                         color: AppColors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   )
  //                       : commonCacheNetworkImage(
  //                     path: profileImage,
  //                     height: profileSize,
  //                     width: profileSize,
  //                     radius: 100,
  //                     errorImage: AppImage.png.userProfileError,
  //                   );
  //                 },
  //                 listener: (context, state) {
  //                   if (state is ProfileDetailSuccess) {
  //                     profileImage =
  //                         state
  //                             .profileDetailResponse
  //                             .data!
  //                             .details!
  //                             .profileImageUrl ??
  //                             "";
  //                     widget.profileData = state.profileDetailResponse.data!;
  //                   }
  //                 },
  //               ),
  //               // Align(
  //               //   alignment: Alignment.bottomRight,
  //               //   child: InkWell(
  //               //     onTap: () {
  //               //       commonBottomSheet(
  //               //         context: context,
  //               //         barrierDismissible: true,
  //               //         screen: const UploadFileAndImageBottomSheet(),
  //               //       ).then((value) async {
  //               //         if (value != null && value["path"] != null) {
  //               //           File file = File(value["path"]);
  //               //           pickImage = file;
  //               //
  //               //           final croppedFile = await ImageCropper().cropImage(
  //               //             sourcePath: pickImage.path,
  //               //             aspectRatio: const CropAspectRatio(
  //               //               ratioX: 1,
  //               //               ratioY: 1,
  //               //             ),
  //               //
  //               //             uiSettings: [
  //               //               AndroidUiSettings(
  //               //                 toolbarTitle: 'Crop Image',
  //               //                 toolbarColor: AppColors.primaryColor,
  //               //                 toolbarWidgetColor: Colors.white,
  //               //                 initAspectRatio: CropAspectRatioPreset.ratio16x9,
  //               //                 lockAspectRatio: true,
  //               //               ),
  //               //               IOSUiSettings(title: 'Crop Image'),
  //               //             ],
  //               //           );
  //               //
  //               //           if (croppedFile != null) {
  //               //             setState(() {
  //               //               _croppedImage = File(croppedFile.path);
  //               //               kycBloc.uploadFile(_croppedImage!);
  //               //             });
  //               //           }
  //               //         } else {
  //               //           // viewModel.setPickImageUIState(null);
  //               //         }
  //               //       });
  //               //     },
  //               //     child: Container(
  //               //       height: 40,
  //               //       width: 40,
  //               //       decoration: const BoxDecoration(
  //               //         color: AppColors.secondaryColor,
  //               //         shape: BoxShape.circle,
  //               //       ),
  //               //       child: SvgPicture.asset(
  //               //         AppIcons.svg.camera,
  //               //         colorFilter: AppColors.svg(Colors.white),
  //               //       ).paddingAll(7),
  //               //     ).paddingBottom(15),
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //     listener: (context, state) {
  //       // if (state is UploadFileSuccess) {
  //       //   profileBloc.add(
  //       //     ProfileImageUploadRequested(
  //       //       userId: lpHomeLocator.userId ?? "",
  //       //       profileImageUploadRequest: ProfileImageUploadRequest(
  //       //         imageUrl: state.uploadFileModel.data!.url ?? "",
  //       //       ),
  //       //     ),
  //       //   );
  //       //   Future.delayed(Duration(seconds: 1), () {
  //       //     ToastMessages.success(message: "File uploaded successfully");
  //       //     lpHomeLocator.add(
  //       //       ProfileDetailRequested(lpHomeLocator.userId ?? ""),
  //       //     );
  //       //   });
  //       // } else if (state is AddharOtpError) {
  //       //   ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
  //       // }
  //     },
  //   );
  // }
}
