import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/view/availabel_loads_filter_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class AvailableLoadsScreen extends StatefulWidget {
  const AvailableLoadsScreen({super.key});

  @override
  State<AvailableLoadsScreen> createState() => _AvailableLoadsScreenState();
}

class _AvailableLoadsScreenState extends State<AvailableLoadsScreen> {

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.availableLoads, scrolledUnderElevation: 0.0,),
      body: SafeArea(
        minimum: EdgeInsets.only(right: commonSafeAreaPadding, left: commonSafeAreaPadding, top: 20),
        bottom: false,
        child:  Column(
          children: [

            // Search Bar
            Row(
              children: [
                AppSearchBar(searchController: searchController).expand(),

                15.width,

                AppIconButton(
                  onPressed: (){
                    commonBottomSheetWithBGBlur(context: context, screen: AvailableLoadsFilterScreen());
                  },
                  style: AppButtonStyle.primaryIconButtonStyle,
                  icon: SvgPicture.asset(AppIcons.svg.filter, width: 20, colorFilter: AppColors.svg(AppColors.primaryColor)),
                )
              ],
            ),
            10.height,

            // List
            ListView.separated(
              itemCount: 5,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 20, bottom: 50),
              separatorBuilder: (context, index) => 20.height,
              itemBuilder: (context, index){
                return RecentAddedLoadListBody();
              },
            ).expand(),
          ],
        ),
      ),
    );
  }
}
