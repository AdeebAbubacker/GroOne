import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_search_bar.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_functions.dart';

class KavachSupportScreen extends StatelessWidget {
  const KavachSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Support',
        centreTile: false,
      ),
      bottomNavigationBar: _buildCallSupportButton(context),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildSearchBarAndFilterWidget(context),
            15.height,
            _buildTabSection(),
            15.height,
            Expanded(child: _buildFAQList()),
          ],
        ).paddingAll(commonSafeAreaPadding),
      ),
    );
  }

  Widget _buildTabSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              'FAQ\'s',
              style: AppTextStyle.h5WhiteColor,
            ),
          ),
        ),
        5.width,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greyContainerBg,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              'Tickets',
              style: AppTextStyle.h5GreyColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQList() {
    return ListView(
      children: const [
        FAQTile(
          title: "What's the resolution time for disputes?",
          subtitle:
          'Most issues are resolved within 24–48 hours. You’ll be notified via app and email on progress.',
        ),
        FAQTile(
          title: 'I paid, but it still shows pending. What should I do?',
          subtitle:
          'Please allow 10–15 minutes for payment status to update. If it still shows pending, contact support with payment proof.',
        ),
        FAQTile(
          title: 'How can I track my shipment?',
          subtitle:
          'Go to My Loads > Select Load > View Live Tracking. You’ll see the current location of your vehicle and estimated arrival time.',
        ),
        FAQTile(
          title: 'Can I cancel a shipment after confirmation?',
          subtitle:
          'You can cancel before vehicle allocation. Post that, cancellation depends on cancellation policy and may include charges.',
        ),
      ],
    );
  }

  Widget _buildCallSupportButton(BuildContext context) {
    return AppButton(
      title: 'Call Customer Support', onPressed: () {
      commonSupportDialog(context);
    },
    ).bottomNavigationPadding();
  }

  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Row(
      children: [
        // Search bar
        AppSearchBar(
          searchController: searchController,
          onChanged: (text) {
          },
        ).expand(),
        15.width,
        // Filter button
        AppIconButton(
          onPressed: () {
          },
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(AppIcons.svg.newFilter, width: 20),
        )
      ],
    );
  }
}

class FAQTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const FAQTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.h5,
          ),
          Divider(height: 20,color: AppColors.greyContainerBg,),
          Text(
            subtitle,
            style: AppTextStyle.textGreyColor14w300
          ),
        ],
      ),
    );
  }
}
