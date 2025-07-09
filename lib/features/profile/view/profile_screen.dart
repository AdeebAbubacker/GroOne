import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/view/benefits_of_membership_screen.dart';
import 'package:gro_one_app/features/profile/view/master_screen.dart';
import 'package:gro_one_app/features/profile/view/my_account_screen.dart';
import 'package:gro_one_app/features/profile/view/my_document_screen.dart';
import 'package:gro_one_app/features/profile/view/setting_screen.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/features/profile/view/transaction_screen.dart';
import 'package:gro_one_app/features/profile/view/widgets/profile_my_account_tile.dart';
import 'package:gro_one_app/utils/common_dialog_view/log_out_dialogue_ui.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
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
    setState(() {});
    debugPrint("user id ${lpHomeLocator.userId}");
  });

  void disposeFunction() => frameCallback(() {});


  void logoutDialogPopUp(BuildContext context, bool isLoading) {
    AppDialog.show(
      context,
      child: CommonDialogView(
        yesButtonText: context.appText.logOut,
        noButtonText: context.appText.cancel,
        showYesNoButtonButtons: true,
        hideCloseButton: true,
        onClickYesButton: ()=> profileCubit.logout(),
        yesButtonLoading: isLoading,
        child: LogOutDialogueUi(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.profile),
      body: SafeArea(
        minimum: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildProfileDetailWidget(),
            profileOptionWidget(context),
            buildProfileVersionWidget(),
          ],
        ),
      ).withScroll(),
    );
  }


  // User Basic Detail
  Widget buildProfileDetailWidget() {
    return BlocConsumer<ProfileCubit , ProfileState>(
      bloc: profileCubit,
      listenWhen: (previous, current) =>  previous.profileDetailUIState != current.profileDetailUIState,
      listener:  (context, state) async {
        final status = state.profileDetailUIState?.status;

        if (status == Status.ERROR) {
          final error = state.profileDetailUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        return Column(
          spacing: 10,
          children:  [

            if(state.profileDetailUIState?.data != null && state.profileDetailUIState?.data?.customer != null)...[

              // Company Name
              if (state.profileDetailUIState?.data?.customer?.companyName != null && state.profileDetailUIState?.data?.customer?.companyName != "")...[
                Container(
                  height: profileSize,
                  width: profileSize,
                  decoration: BoxDecoration(color: AppColors.greyIconBackgroundColor, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(getInitialsFromName(this, name: state.profileDetailUIState!.data!.customer!.companyName),
                    style: AppTextStyle.h1,
                  ),
                ),

                Text(state.profileDetailUIState!.data!.customer!.companyName, style: AppTextStyle.h5),
              ],

              // Customer Name
              if(state.profileDetailUIState?.data?.customer?.customerName != null && state.profileDetailUIState?.data?.customer?.customerName != "")
              Text(state.profileDetailUIState!.data!.customer!.customerName, style: AppTextStyle.body),

              // Blue Id
              if(state.profileDetailUIState?.data?.customer?.blueId != null && state.profileDetailUIState?.data?.customer?.blueId != "")
              InkWell(
                onTap: () {
                  Navigator.push(context, commonRoute(BenefitsOfMembershipScreen()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  child: Text("${context.appText.blueMembershipId} : ${state.profileDetailUIState!.data!.customer!.blueId}", style: AppTextStyle.h5WhiteColor),
                ),
              ),
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

          BlocBuilder<ProfileCubit , ProfileState>(
            bloc: profileCubit,
            builder: (context, state) {
              return ProfileMyAccountTile(
                imageString: AppImage.svg.user,
                text: context.appText.myAccount,
                onTap: () {
                  Navigator.push(context, commonRoute(LpMyAccount(
                    customerDetail: state.profileDetailUIState!.data!.customer!,
                    bankDetails : state.profileDetailUIState!.data!.bankDetails!,
                    address: state.profileDetailUIState!.data!.address!,
                  ), isForward: true));
                },
              );
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.master,
            text: "Master",
            onTap: () {
              Navigator.of(context).push(commonRoute(MasterScreen(), isForward: true));
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.routes,
            text: "Routes",
            onTap: () {
              ///todo - routes to be done later
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.myDocuments,
            text: "My Documents",
            onTap: () {
              Navigator.of(context).push(commonRoute(MyDocumentScreen(), isForward: true));
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.transaction,
            text: context.appText.transactions,
            onTap: () {
              Navigator.of(context).push(commonRoute(LpTransaction(), isForward: true));
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.settings,
            text: context.appText.settings,
            onTap: () {
              Navigator.of(context).push(commonRoute(LpSetting(), isForward: true));
            },
          ),
          commonDivider(),

          ProfileMyAccountTile(
            imageString: AppImage.svg.support,
            text: context.appText.support,
            onTap: () {
              Navigator.of(context).push(commonRoute(LpSupport(), isForward: true));
            },
          ),
          commonDivider(),

          // Logout
          BlocConsumer<ProfileCubit, ProfileState>(
            bloc: profileCubit,
            listenWhen: (previous, current) =>
            previous.logoutUIState?.status != current.logoutUIState?.status,
            listener: (context, state) {
              final status = state.logoutUIState?.status;

              if (status == Status.SUCCESS) {
                context.push(AppRouteName.chooseLanguage);
              }

              if (status == Status.ERROR) {
                final error = state.logoutUIState?.errorType;
                ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
              }
            },
            builder: (context, state) {
              return ProfileMyAccountTile(
                imageString: AppImage.svg.logOut,
                text: context.appText.logOut,
                onTap: () => logoutDialogPopUp(context, state.logoutUIState?.status == Status.LOADING),
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
    return Text("Version $appVersion", style: AppTextStyle.textGreyDetailColor14w400);
  }

}
