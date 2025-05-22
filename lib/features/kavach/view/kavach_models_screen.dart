import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_models_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class KavachModelsScreen extends StatefulWidget {
  const KavachModelsScreen({super.key});

  @override
  State<KavachModelsScreen> createState() => _KavachModelsScreenState();
}

class _KavachModelsScreenState extends State<KavachModelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.kavachModels),
      body: buildBodyWidget(),
      bottomNavigationBar: buildBuyButtonWidget(),
    );
  }

  Widget buildBodyWidget(){
    return SafeArea(
      minimum: EdgeInsets.all(commonSafeAreaPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(context.appText.kavachModels, style: AppTextStyle.body2),
          20.height,

          // List
          ListView.separated(
            itemCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 20.height,
            itemBuilder: (context, index){
              return KavachModelsListBody();
            },
          ),

          20.height
        ],
      ),
    );
  }

  Widget buildSearchBarAndFilterWidget(){
    return Row(
        children: [
          // AppSearchBar(searchController: searchController).expand(),
          //
          // 15.width,
          //
          // AppIconButton(
          //   onPressed: (){
          //     commonBottomSheetWithBGBlur(context: context, screen: AvailableLoadsFilterScreen());
          //   },
          //   style: AppButtonStyle.primaryIconButtonStyle,
          //   icon: SvgPicture.asset(AppIcons.svg.filter, width: 20, colorFilter: AppColors.svg(AppColors.primaryColor)),
          // )
        ],
      );
  }

  Widget buildBuyButtonWidget(){
    return AppButton(
        title: context.appText.buyNow,
        onPressed: (){},
    ).bottomNavigationPadding();
  }

}
