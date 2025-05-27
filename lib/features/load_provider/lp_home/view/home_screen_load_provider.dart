import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/view/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/vp_home_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dropdown2.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_text_field.dart';
import '../../../our_value_added_service/view/our_value_added_service_widget.dart';

class HomeScreenLoadProvider extends StatefulWidget {
  const HomeScreenLoadProvider({super.key});

  @override
  State<HomeScreenLoadProvider> createState() => _HomeScreenLoadProviderState();
}

class _HomeScreenLoadProviderState extends State<HomeScreenLoadProvider> {
  bool checkBoxBool = false;

  void _showKycBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
backgroundColor: Colors.transparent,
elevation:10 ,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context1, setStateBuilder) {
            return Stack(
              children: [
                Container(height: double.infinity,color:AppColors.textBlackColor.withOpacity(0.4),),
                Positioned(
                  bottom: 0,left: 0,right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),

                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              "Verify Your KYC",
                              style: AppTextStyle.textBlackColor20w500,
                            ),
                            15.height,

                            AppTextField(
                              decoration: commonInputDecoration(
                                hintText: "xxxx xxxx 9123",
                                fillColor: AppColors.white,
                              ),
                              keyboardType: TextInputType.number,

                              labelText: "Enter Aadhar Card Number",
                              labelTextStyle: AppTextStyle.textBlackColor16w400,
                            ),

                            20.height,
                            customCheckbox(
                              context: context,
                              text: context.appText.iAgree,
                              onTap: () {
                                checkBoxBool = !checkBoxBool;
                                setStateBuilder(() {});
                              },
                              selected: checkBoxBool,
                            ),
                            20.height,
                            AppButton(
                              title: "Verify Aadhar",
                              onPressed: () {
                                context.pop();
                                context.push(AppRouteName.kycScreen).then((v) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    // Dismiss only with button if needed
                                    builder: (BuildContext context) {
                                      return showAlertDialogue(
                                        hideButtonButtons: true,
                                        context: context,
                                        onClickYesButton: () {},
                                        child: Column(
                                          spacing: 20.h,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                onTap:
                                                    () => Navigator.of(context).pop(),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 24,
                                                ),
                                              ),
                                            ),

                                            // Illustration
                                            Image.asset(
                                              AppImage.png.blueMembership,
                                              // replace with your image asset
                                              height: 150,
                                            ),

                                            // Title
                                            const Text(
                                              "Blue membership ID\ngenerated Successfully",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            // Subtitle
                                            const Text(
                                              "Start exploring premium load\noptions today",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text(
                                  "I’ll do it later",
                                  style: AppTextStyle.primaryColor16w400.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: buildAppBarWidget(context),
      body: buildBodyWidget(context),
    );
  }

  // Appbar
  PreferredSizeWidget buildAppBarWidget(BuildContext context){
    return CommonAppBar(
      isLeading: false,
      leading:  Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
      actions: [
        // KYC
        kycWidget(
            onTap: () {
              _showKycBottomSheet(context);
            }
        ),
        10.width,

        // Profile
        InkWell(
          onTap: (){
            context.push(AppRouteName.lpProfile);
          },
          child: commonCacheNetworkImage(
            height: 40,
            width: 40,
            path: "",
            errorImage: AppImage.png.userProfileError
          ).paddingRight(commonSafeAreaPadding),
        ),
      ],
    );
  }

  // Body
  Widget buildBodyWidget(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildKYCStatusWidget(),

          bookShipmentSection(),
          10.height,

          valueAddedService(context),

          upComingShipment(),
          30.height,
        ],
      ),
    );
  }

  Widget buildKYCStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      color: AppColors.appRedColor,
      height: 42.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImage.png.alertTriangle, height: 24.h, width: 24.w),
          10.width,
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.appText.your,
                  style: AppTextStyle.textDarkGreyColor14w500,
                ),
                TextSpan(
                  text: " ${context.appText.kyc} ",
                  style: AppTextStyle.textDarkGreyColor14w500.copyWith(
                    color: AppColors.orangeTextColor,
                  ),
                ),
                TextSpan(
                  text: context.appText.stillPending,
                  style: AppTextStyle.textDarkGreyColor14w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  upComingShipment() {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
        child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.appText.upComingShipment,
              style: AppTextStyle.textBlackColor18w500,
            ),

            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                spacing: 5.h,
                children: [
                  ListTile(
                    leading: Image.asset(
                      AppImage.png.shipmentBox,
                      height: 39.h,
                      width: 39.w,
                    ),
                    title: Text(
                      context.appText.idNumber,
                      style: AppTextStyle.textGreyDetailColor10w400,
                    ),
                    subtitle: Text(
                      "GD12456",
                      style: AppTextStyle.blackColor16w400,
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurpleColor,

                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        "Sourcing",
                        style: AppTextStyle.whiteColor14w400.copyWith(
                          color: AppColors.purpleColor,
                        ),
                      ),
                    ),
                  ),
                  dividerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        spacing: 10.h,
                        children: [
                          Text(
                            "14 Jul, 2025",
                            style: AppTextStyle.textGreyDetailColor10w400,
                          ),
                          Text(
                            "T. Nagar",
                            style: AppTextStyle.blackColor16w400,
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: AppColors.primaryColor),
                      Column(
                        spacing: 10.h,
                        children: [
                          Text(
                            "14 Jul, 2025",
                            style: AppTextStyle.textGreyDetailColor10w400,
                          ),
                          Text(
                            "T. Nagar",
                            style: AppTextStyle.blackColor16w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  10.height,
                  memoDone
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          normalButton(
                            buttonText: "Pay Now",
                            onTap: () {
                              context.push(AppRouteName.lpPayNowAndTrackLoad);
                            },
                            buttonWidth: 143.w,
                          ),
                          normalButton(
                            buttonText: "Track Load",
                            onTap: () {
                              context.push(AppRouteName.lpPayNowAndTrackLoad);
                            },
                            buttonWidth: 143.w,
                          ),
                        ],
                      )
                      : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: normalButton(
                          buttonText: context.appText.iAgreeTripToGo,
                          onTap: () {
                            showAdvanceDialogue(context: context);
                          },
                        ),
                      ),
                  5.height,
                ],
              ),
            ),

            ///Center(child: Image.asset(width: 201.w,height: 134.h,AppImage.png.noShipment))
          ],
        ),
      ),
    );
  }

  int selectedPercentage = 80;
  final int baseAmount = 15000;
  bool memoDone = false;

  Future showAdvanceDialogue({required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState1) {
            int calculatedAmount = (baseAmount * selectedPercentage ~/ 100);
            return showCustomDialogue(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.appText.advancePayment,
                    style: AppTextStyle.darkDividerColor16w400,
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        [70, 80, 85].map((percent) {
                          final isSelected = percent == selectedPercentage;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPercentage = percent;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF0057FF)
                                        : Colors.transparent,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? const Color(0xFF0057FF)
                                          : Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$percent%',
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '₹$calculatedAmount',
                    style: AppTextStyle.textBlackColor26w700,
                  ),
                ],
              ),
              onClickButton: () {
                context.pop();
                context.push(AppRouteName.lpValidateMemo).then((value) {
                  memoDone = true;
                  setState(() {});
                });
              },
              buttonText: context.appText.verifyAdvance,
            );
          },
        );
      },
    );
  }

  bookShipmentSection() {
    return Container(
      color: AppColors.white,
      child: Padding(
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
                          onClick: () {
                            context.push(AppRouteName.lpSelectPickPointScreen);
                          },
                        ),

                        Divider(color: AppColors.disableColor, thickness: 0.5),
                        bookShipmentWidget(
                          heading: context.appText.destination,
                          subHeading: context.appText.selectDestination,
                          onClick: () {
                            context.push(AppRouteName.lpSelectPickPointScreen);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppDropdown(
              hintText: hintCommodity,
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

            AppDropdown(
              hintText: hintTruck,
              onSelect: (value) {
                selectedTruck = truck[value]['label'];
                selectedValueTruck = false;
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Suggested Price",
                        style: AppTextStyle.textDarkGreyColor14w400,
                      ),
                      Text(
                        "₹75,000 - ₹80, 000",
                        style: AppTextStyle.textBlackColor16w500,
                      ),
                    ],
                  ),
                  Expanded(child: const SizedBox.shrink()),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      title: context.appText.postLoad,

                      onPressed: () async {
                        showSuccessDialog(
                          context,
                          text: "Load Posted Successfully",
                          subheading:
                              "We will assign the vehicle and\ndriver soon.",
                        );

                        await Future.delayed(
                          const Duration(seconds: 2),
                          () async {},
                        );
                        context.pop();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          // Dismiss only with button if needed
                          builder: (BuildContext context) {
                            return showAlertDialogue(
                              context: context,
                              onClickYesButton: () {},
                              child: Column(
                                spacing: 20.h,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Icon(Icons.close, size: 24),
                                    ),
                                  ),

                                  // Illustration
                                  Image.asset(
                                    AppImage.png.markAsFavourite,
                                    // replace with your image asset
                                    height: 150,
                                  ),

                                  // Title
                                  const Text(
                                    "Mark as Favourite",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // Subtitle
                                  const Text(
                                    "Do you want mark as Favorite this load?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
            5.height,
            InkWell(onTap: (){
              showCustomerCareBottomSheet(context);
            },child: Center(child: Text("Need Our Customer Support Help?",style: AppTextStyle.primaryColor14w400UnderLine,))),
            5.height,
          ],
        ),
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
            spacing: 2.h,
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
  ];
  final List<Map<String, dynamic>> truck = [
    {'label': 'Open - 20ft SXL1', 'icon': Icons.grass},
    {'label': 'Open - 20ft SXL2', 'icon': Icons.inventory_2},
    {'label': 'Open - 20ft SXL3', 'icon': Icons.local_drink},
    {'label': 'Open - 20ft SXL4', 'icon': Icons.fireplace},
    {'label': 'Open - 20ft SXL5', 'icon': Icons.wine_bar},
  ];
}
