import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/view/widgets/profile_my_account_tile.dart';
import 'package:gro_one_app/utils/common_dialog_view/log_out_dialogue_ui.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseState<ProfileScreen> {
  final lpHomeLocator = locator<LpHomeBloc>();
  final kycCubit = locator<KycCubit>();
  final lpHomeCubit = locator<LPHomeCubit>();
  final profileCubit = locator<ProfileCubit>();

  final double profileSize = 120;

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
    profileCubit.fetchProfileDetail();
    appVersion = await appVersionInfo();
    await kycCubit.fetchUserRole();
    setState(() {});
  });

  void disposeFunction() => frameCallback(() {
    profileCubit.resetLogoutUIState();
  });

  void logoutDialogPopUp(BuildContext context) {
    AppDialog.show(
      context,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        bloc: profileCubit,
        builder: (context, state) {
          final isLoading = state.logoutUIState?.status == Status.LOADING;
          return CommonDialogView(
            yesButtonText: context.appText.logOut,
            noButtonText: context.appText.cancel,
            showYesNoButtonButtons: true,
            hideCloseButton: true,
            onClickYesButton: () => !isLoading ? profileCubit.logout() : () {},
            yesButtonLoading: isLoading,
            child: LogOutDialogueUi(),
          );
        },
      ),
    );
  }

  void closeBloc() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.profile,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => initFunction(),
        child:
            SafeArea(
              minimum: EdgeInsets.all(commonSafeAreaPadding),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildProfileDetailWidget(),
                  5.height,
                  profileOptionWidget(context),
                  buildProfileVersionWidget(),
                ],
              ),
            ).withScroll(),
      ),
    );
  }

  // User Basic Detail
  Widget buildProfileDetailWidget() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listenWhen:
          (previous, current) =>
              previous.profileDetailUIState != current.profileDetailUIState,
      listener: (context, state) async {
        final status = state.profileDetailUIState?.status;

        if (status == Status.ERROR) {
          final error = state.profileDetailUIState?.errorType;
          ToastMessages.error(
            message: getErrorMsg(errorType: error ?? GenericError()),
          );
        }
      },
      builder: (context, state) {
        return Column(
          spacing: 10,
          children: [
            if (state.profileDetailUIState?.data != null &&
                state.profileDetailUIState?.data?.customer != null) ...[
              // Company Name
              if (state.profileDetailUIState?.data?.customer?.companyName !=
                      null &&
                  state.profileDetailUIState?.data?.customer?.companyName !=
                      "") ...[
                Container(
                  height: profileSize,
                  width: profileSize,
                  decoration: BoxDecoration(
                    color: AppColors.greyIconBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.blueColor, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    getInitialsFromName(
                      this,
                      name:
                          state
                              .profileDetailUIState!
                              .data!
                              .customer!
                              .companyName,
                    ),
                    style: AppTextStyle.h1,
                  ),
                ).isAnimate(),

                Text(
                  state
                      .profileDetailUIState!
                      .data!
                      .customer!
                      .companyName
                      .capitalize,
                  style: AppTextStyle.h5,
                ).isAnimate(),
              ],

              // Customer Name
              if (state.profileDetailUIState?.data?.customer?.customerName !=
                      null &&
                  state.profileDetailUIState?.data?.customer?.customerName !=
                      "")
                Text(
                  state
                      .profileDetailUIState!
                      .data!
                      .customer!
                      .customerName
                      .capitalize,
                  style: AppTextStyle.body,
                ).isAnimate(),

              // Blue Id
              if (state.profileDetailUIState?.data?.customer?.blueId != null &&
                  state.profileDetailUIState?.data?.customer?.blueId != "")
                InkWell(
                  onTap: () {
                    context.push(AppRouteName.benefitsOfMembership);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor,
                    ),
                    child: Text(
                      "${context.appText.blueMembershipId} : ${state.profileDetailUIState!.data!.customer!.blueId}",
                      style: AppTextStyle.h5WhiteColor,
                    ),
                  ),
                ).isAnimate(),
            ],
          ],
        );
      },
    );
  }

  Widget profileOptionWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: commonContainerDecoration(),
      child: Column(
        children: [
          10.height,

          BlocBuilder<ProfileCubit, ProfileState>(
            bloc: profileCubit,
            builder: (context, state) {
              return ProfileMyAccountTile(
                imageString: AppImage.svg.user,
                text: context.appText.myAccount,
                onTap: () {

                  final extra = {
                    "customerDetail": state.profileDetailUIState?.data?.customer,
                    "bankDetails": state.profileDetailUIState?.data?.bankDetails,
                    "kycDoc": state.profileDetailUIState?.data?.kycDocs[0],
                  };

                  context.push(AppRouteName.myAccount, extra: extra);
                },
              );
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.master,
            text: context.appText.masters,
            onTap: () {
              context.push(AppRouteName.master);
            },
          ),
          commonDivider(),
          if (kycCubit.userRole == 1 || kycCubit.userRole == 3) ...[
            ProfileMyAccountTile(
              imageString: AppImage.svg.routes,
              text: context.appText.routes,
              onTap: () {
                context.push(AppRouteName.routes);
              },
            ),
            commonDivider(),
          ],

          ProfileMyAccountTile(
            imageString: AppImage.svg.myDocuments,
            text: context.appText.myDocuments,
            onTap: () {
              context.push(AppRouteName.myDocuments);
            },
          ),
          commonDivider(),
          ...[
            Visibility(
              visible: false,
              child: ProfileMyAccountTile(
                imageString: AppImage.svg.transaction,
                text: context.appText.transactions,
                onTap: () {
                  context.push(AppRouteName.lpTransaction);
                },
              ),
            ),
            Visibility(visible: false, child: commonDivider()),
          ],

          ProfileMyAccountTile(
            imageString: AppImage.svg.settings,
            text: context.appText.settings,
            onTap: () {
              context.push(AppRouteName.settings);
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.support,
            text: context.appText.support,
            onTap: () {
              context.push(AppRouteName.support, extra: {"showBackButton" : true});
            },
          ),
          commonDivider(),

          // Logout
          BlocConsumer<ProfileCubit, ProfileState>(
            bloc: profileCubit,
            listenWhen:
                (previous, current) =>
                    previous.logoutUIState?.status !=
                    current.logoutUIState?.status,
            listener: (context, state) {
              final status = state.logoutUIState?.status;

              if (status == Status.SUCCESS) {
                LpBottomNavigation.selectedIndexNotifier.value = 0;
                disposeFunction();
                // context.pushReplacement(
                //   AppRouteName.login,
                //   extra: {"showBackButton": false},
                // );
                context.go(
                AppRouteName.login,
                extra: {"showBackButton": false},
              );
              }

              if (status == Status.ERROR) {
                final error = state.logoutUIState?.errorType;
                ToastMessages.error(
                  message: getErrorMsg(errorType: error ?? GenericError()),
                );
              }
            },
            builder: (context, state) {
              return ProfileMyAccountTile(
                imageString: AppImage.svg.logOut,
                text: context.appText.logOut,
                onTap: () => logoutDialogPopUp(context),
                showArrow: false,
              );
            },
          ),

          10.height,
        ],
      ),
    );
  }

  Widget buildProfileVersionWidget() {
    return Text("v $appVersion", style: AppTextStyle.textGreyDetailColor14w400);
  }
}
