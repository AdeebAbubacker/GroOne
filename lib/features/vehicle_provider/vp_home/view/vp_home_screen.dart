import 'package:flutter/material.dart';
import 'package:gro_one_app/features/our_value_added_service/view/our_value_added_service_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class VpHomeScreen extends StatefulWidget {
  const VpHomeScreen({super.key});

  @override
  State<VpHomeScreen> createState() => _VpHomeScreenState();
}

class _VpHomeScreenState extends State<VpHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  // AppBar
  PreferredSizeWidget _buildAppBar(){
    return CommonAppBar(
      isLeading: false,
      leading:  Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
      actions: [
        kycWidget().paddingRight(commonSafeAreaPadding),
      ],
    );
  }

  // Body
  Widget _buildBody(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            20.height,
            valueAddedService(context),
            20.height,
            _buildRecentAddedLoadWidget()
          ],
        ).withScroll(),
      ),
    );
  }

  Widget _buildRecentAddedLoadWidget(){
    return Container(
      decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.appText.recentAddedLoad, style: AppTextStyle.body1).expand(),

              TextButton(
                  onPressed: (){},
                style: AppButtonStyle.primaryTextButton,
                  child: Text(context.appText.seeMore, style: AppTextStyle.bodyWhiteColor),
              )
            ],
          ),
          10.height,

          // List
          ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 20.height,
            itemBuilder: (context, index){
              return RecentAddedLoadListBody();
            },
          ),

          20.height
        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding),
    );
  }

}


