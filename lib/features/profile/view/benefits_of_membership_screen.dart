import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_icons.dart';

class BenefitsOfMembershipScreen extends StatefulWidget {
 const BenefitsOfMembershipScreen({super.key});

  @override
  State<BenefitsOfMembershipScreen> createState() =>
      _BenefitsOfMembershipScreenState();
}

class _BenefitsOfMembershipScreenState extends State<BenefitsOfMembershipScreen> {
  final profileCubit = locator<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(() async {
    await profileCubit.fetchMembershipBenefit();
  });

  final List icons = [
    AppIcons.svg.commission,
    AppIcons.svg.priorityLoad,
    AppIcons.svg.fasterPayment,
    AppIcons.svg.manager,
    AppIcons.svg.fuel,
    AppIcons.svg.fasterLoad,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
        title: Text(
          context.appText.benefitsOfMembership,
          style: AppTextStyle.body1,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final uiState = state.memberShipState;

          if (uiState == null || uiState.status == Status.LOADING) {
            return CircularProgressIndicator().center();
          }

          if (uiState.status == Status.ERROR) {
            return genericErrorWidget(error: uiState.errorType);
          }

          final memberShipData = uiState.data?.data ?? [];

          if (memberShipData.isEmpty) {
            return genericErrorWidget(error: NotFoundError());
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ListView.builder(
              itemCount: memberShipData.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final membership = memberShipData[index];
                return ListTile(
                  leading: SvgPicture.asset(icons[index]),
                  title: Text(membership.title, style: AppTextStyle.h5).paddingSymmetric(vertical: 5),
                  subtitle: Text(membership.description, style: AppTextStyle.body3),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
