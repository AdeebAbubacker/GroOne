import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../utils/app_button.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dropdown2.dart';
import '../../../../utils/app_image.dart';
import '../../../our_value_added_service/view/our_value_added_service_widget.dart';

class HomeScreenLoadProvider extends StatefulWidget {
  const HomeScreenLoadProvider({super.key});

  @override
  State<HomeScreenLoadProvider> createState() => _HomeScreenLoadProviderState();
}

class _HomeScreenLoadProviderState extends State<HomeScreenLoadProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            AppImage.png.appIcon,
            height: 33.h,
            width: 75.w,
            scale: 1,
          ),
        ),
        actions: [
          Container(
            height: 36.h,
            width: 36.w,
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
               context.appText.kyc,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          20.width,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey.shade200, thickness: 3),
            valueAddedService(context),
            SizedBox(height:3.h,child: Divider(color: Colors.grey.shade200, thickness: 3)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              color: AppColors.appRedColor,
              height: 42.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
Image.asset(AppImage.png.alertTriangle,height: 24.h,width: 24.w,),
              10.width,Expanded(
                child: RichText(textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: context.appText.your,
                            style: AppTextStyle.textDarkGreyColor14w500,),
                          TextSpan(
                              text: " ${context.appText.kyc} ",
                              style:AppTextStyle.textDarkGreyColor14w500.copyWith(color: AppColors.orangeTextColor)
                          ),
                          TextSpan(
                            text: context.appText.stillPending,
                            style: AppTextStyle.textDarkGreyColor14w500,),
                        ],
                      ),
                    ),
              ),
                ],
              ),
            ),
            bookShipmentSection(),
            Divider(color: Colors.grey.shade200, thickness: 3),
          upComingShipment(),
            30.height
          ],
        ),
      ),
    );
  }
  upComingShipment(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.appText.upComingShipment,
            style: AppTextStyle.textBlackColor18w500,
          ),
          20.height,
          Center(child: Image.asset(width: 201.w,height: 134.h,AppImage.png.noShipment))
        ],
      ),
    );
  }
bookShipmentSection(){
return  Padding(
  padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 10.h,
    children: [

      Text(
        context.appText.bookShipment,
        style: AppTextStyle.textBlackColor18w500,
      ),
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.borderDisableColor,
            width: 0.6.w,
          ),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.backGroundBlue,
        ),
        child: Row(
          children: [
            Image.asset(
              AppImage.png.bookAShipment,
              height: 86.h,
              width: 18.h,
            ),
            10.width,
            Expanded(
              child: Column(
                children: [
                  bookShipmentWidget(
                    heading: context.appText.source,
                    subHeading: context.appText.selectPickUpPoint,
                    onClick: () {},
                  ),

                  Divider(
                    color: AppColors.disableColor,
                    thickness: 0.5,
                  ),
                  bookShipmentWidget(
                    heading: context.appText.destination,
                    subHeading: context.appText.selectDestination,
                    onClick: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      AppDropdown(hintText: hintCommodity,
        onSelect: (value) {
          selectedCommodity = commodities[value]['label'];
          selectedValueCommodity = false;
          setState(() {});
        },
        dataList: commodities,
        selectedText: selectedCommodity,
        viewDroDown: selectedValueCommodity,
        onTab: () {
          selectedValueCommodity = !selectedValueCommodity;
          setState(() {});
        },
      ),

      AppDropdown(hintText: hintTruck,
        onSelect: (value) {
          selectedTruck = truck[value]['label'];
          selectedValueTruck= false;
          setState(() {});
        },
        dataList: truck,
        selectedText: selectedTruck,
        viewDroDown: selectedValueTruck,
        onTab: () {
          selectedValueTruck = !selectedValueTruck;
          setState(() {});
        },
      ),
      Container(

        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.borderDisableColor,
            width: 0.6.w,
          ),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.backGroundBlue,
        ),
child: Row(
  children: [
    Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Suggested Price",style: AppTextStyle.textDarkGreyColor14w400,),
      Text("₹75,000 - ₹80, 000",style: AppTextStyle.textBlackColor16w500,)
    ],
      ),Expanded(child: const SizedBox.shrink()), Expanded(flex: 1,
    child: AppButton(
        title:context.appText.postLoad,

        onPressed:() {
        //  context.push(AppRouteName.login);
        } ,),
  ),],
),

      )



    ],
  ),
);
}
  bookShipmentWidget({
    required String heading,
    required String subHeading,
    required GestureTapCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5.h,
            children: [
              Text(heading, style: AppTextStyle.textGreyColor12w400),
              Text(subHeading, style: AppTextStyle.textBlackColor12w400),
            ],
          ),
          Image.asset(AppImage.png.locationIcon, height: 18.h, width: 18.w),
        ],
      ),
    );
  }

  String hintCommodity = 'Commodity';
  String? selectedCommodity;
  String hintTruck = 'Truck';
  String? selectedTruck;
  bool selectedValueCommodity = false;
  bool selectedValueTruck = false;
  final List<Map<String, dynamic>> commodities = [
    {'label': 'Agriculture', 'icon': Icons.grass},
    {'label': 'Parcels', 'icon': Icons.inventory_2},
    {'label': 'Barrels', 'icon': Icons.local_drink},
    {'label': 'Logs', 'icon': Icons.fireplace},
    {'label': 'Bottles', 'icon': Icons.wine_bar},
  ]; final List<Map<String, dynamic>> truck = [
    {'label': 'Open - 20ft SXL', 'icon': Icons.grass},
    {'label': 'Open - 20ft SXL', 'icon': Icons.inventory_2},
    {'label': 'Open - 20ft SXL', 'icon': Icons.local_drink},
    {'label': 'Open - 20ft SXL', 'icon': Icons.fireplace},
    {'label': 'Open - 20ft SXL', 'icon': Icons.wine_bar},
  ];
}
