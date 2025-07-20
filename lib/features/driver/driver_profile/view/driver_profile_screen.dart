import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/profile/view/master_screen.dart';
import 'package:gro_one_app/features/profile/view/my_document_screen.dart';
import 'package:gro_one_app/features/profile/view/setting_screen.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/features/profile/view/transaction_screen.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/driver/driver_profile/cubit/driver_profile_cubit.dart';
import 'package:gro_one_app/features/profile/view/widgets/profile_my_account_tile.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/constant_variables.dart' ;
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/data/ui_state/status.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});
  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends BaseState<DriverProfileScreen> {
  final driverProfileCubit = locator<DriverProfileCubit>();
  final double profileSize = 120;
  String appVersion = '';

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  void initFunction() => frameCallback(() async {
    driverProfileCubit.fetchProfileDetail();
    appVersion = await appVersionInfo();
    setState(() {});
  });

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
            5.height,
            profileOptionWidget(context),
            buildProfileVersionWidget(),
          ],
        ),
      ).withScroll(),
    );
  }

  Widget buildProfileDetailWidget() {
    return BlocConsumer<DriverProfileCubit, DriverProfileState>(
      bloc: driverProfileCubit,
      listenWhen: (prev, curr) => prev.profileDetailUIState != curr.profileDetailUIState,
      listener: (context, state) {
        if (state.profileDetailUIState?.status == Status.ERROR) {
          final error = state.profileDetailUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        final driver = state.profileDetailUIState?.data?.data; // Adjust field as per your model
        if (driver == null) return const SizedBox();

        return Column(
          spacing: 10,
          children: [
            Container(
              height: profileSize,
              width: profileSize,
              decoration: BoxDecoration(color: AppColors.greyIconBackgroundColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                getInitialsFromName(this, name: driver.name), // Adjust field
                style: AppTextStyle.h1,
              ),
            ).isAnimate(),
            if (driver.name.isNotEmpty)
              Text(driver.name, style: AppTextStyle.h5).isAnimate(),

            if (driver.driverId != null && driver.driverId!.isNotEmpty)
              Text("Driver ID: ${driver.driverId}", style: AppTextStyle.body).isAnimate(),
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
          BlocBuilder<DriverProfileCubit, DriverProfileState>(
            bloc: driverProfileCubit,
            builder: (context, state) {
              final driver = state.profileDetailUIState?.data?.data;
              if (driver == null) return const SizedBox();

              return ProfileMyAccountTile(
                imageString: AppImage.svg.user,
                text: context.appText.myAccount,
                onTap: () {
                  // You can pass driver info if needed
                },
              );
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
          10.height,
        ],
      ),
    );
  }

  Widget buildProfileVersionWidget() {
    return Text("Version $appVersion", style: AppTextStyle.textGreyDetailColor14w400);
  }
}
