import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/mark_as_favourite_dailog_ui.dart';
import 'package:gro_one_app/features/load_provider/lp_location_screens/lp_select_pick_point/view/lp_select_pick_point_screen.dart';
import 'package:gro_one_app/features/splash/splash_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/lp_selection_dropdown.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_text_field.dart';
import '../../../our_value_added_service/view/our_value_added_service_widget.dart';

class HomeScreenLoadProvider extends StatefulWidget {
  const HomeScreenLoadProvider({super.key});

  @override
  State<HomeScreenLoadProvider> createState() => _HomeScreenLoadProviderState();
}

class _HomeScreenLoadProviderState extends State<HomeScreenLoadProvider> {

  final vpHomeBloc = locator<VpCreationBloc>();

  final dateTextController = TextEditingController();
  final weightTextController = TextEditingController();


  int selectedPercentage = 80;
  final int baseAmount = 15000;

  String hintCommodity = 'Commodity';
  String? selectedCommodity;
  String hintTruck = 'Truck';
  String? selectedTruck;

  bool selectedValueCommodity = false;
  bool selectedValueTruck = false;
  bool checkBoxBool = false;
  bool memoDone = false;





  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => addPostFrameCallback(() {
    //  Call your init methods
  });

  void disposeFunction() => addPostFrameCallback(() {

  });


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
      leading:  BlocListener<VpCreationBloc, VpCreationState>(
        bloc: vpHomeBloc,
        listener: (context, state) {
          if (state is LogoutSuccess) {
            navigateAndRemoveAllRoutes(context, screen: SplashScreen());
          }
          if (state is LogoutError) {
            ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
          }
        },
        child: InkWell(
          onTap: ()=> vpHomeBloc.add(LogoutRequested()),
          child: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
        ),
      ),
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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildKYCStatusWidget(),

            bookShipmentSectionWidget(context),
            20.height,

            valueAddedService(context),
            20.height,

            upComingShipment(),
            30.height,
          ],
        ),
      ),
    );
  }

  Widget buildKYCStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      color: AppColors.appRedColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImage.png.alertTriangle, width: 20),
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
                  text: "  ${context.appText.kyc}  ",
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
          Expanded(
            child: AppButton(
              buttonHeight: 32.h,
              style: AppButtonStyle.outline,
              title: "Pay Now",
              onPressed: () {
                context.push(AppRouteName.lpPayNowAndTrackLoad);
              },
            ),
          ),
          15.width,
          Expanded(
            child: AppButton(
              buttonHeight: 32.h,
              style: AppButtonStyle.outline,
              title: "Track Load",
              onPressed: () {
                context.push(AppRouteName.lpPayNowAndTrackLoad);
              },
            ),
          ),
        ],
      )
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: AppButton(
          buttonHeight: 32.h,
          style: AppButtonStyle.outline,
          title: context.appText.iAgreeTripToGo,
          onPressed: () {
           // showAdvancePaymentDialogue(context: context);
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



  Widget bookShipmentSectionWidget(BuildContext context) {

    // Inner inside Widget
    Widget bookShipmentWidget({required String heading, required String subHeading, required GestureTapCallback onClick}) {
      return InkWell(
        onTap: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(heading, style: AppTextStyle.textGreyColor12w400),
                Text(subHeading, style: AppTextStyle.body),
              ],
            ),
            Image.asset(AppImage.png.locationIcon, height: 18.h, width: 18.w),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(context.appText.bookShipment, style: AppTextStyle.body1),
          15.height,

          Container(
            padding: EdgeInsets.all(10),
            decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
            child: Row(
              children: [
                Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight),
                10.width,

                Column(
                  children: [
                    // Source
                    bookShipmentWidget(
                      heading: context.appText.source,
                      subHeading: context.appText.selectPickUpPoint,
                      onClick: () {
                        Navigator.of(context).push(commonRoute(LpSelectPickPointScreen(), isForward: true));
                      },
                    ),

                    commonDivider(),

                    // Destination
                    bookShipmentWidget(
                      heading: context.appText.destination,
                      subHeading: context.appText.selectDestination,
                      onClick: () {
                        Navigator.of(context).push(commonRoute(LpSelectPickPointScreen(), isForward: true));
                      },
                    ),
                  ],
                ).expand(),
              ],
            ),
          ),
          15.height,

          // Commodity selection
          LPSelectionDropdown(
            preFixIcon: AppIcons.svg.commodity,
            hintText: hintCommodity,
            onSelect: (value) async {
              selectedCommodity = commodities[value]['label'];
              await Future.delayed(Duration(milliseconds: 300));
              selectedValueCommodity = false;
              setState(() {});
            },
            dataList: commodities,
            selectedText: selectedCommodity,
            viewDropDown: selectedValueCommodity,
            onTab: () {
              selectedValueCommodity = !selectedValueCommodity;
              setState(() {});
            },
          ),
          15.height,

          // Truck selection
          LPSelectionDropdown(
            preFixIcon: AppIcons.svg.truck,
            hintText: hintTruck,
            onSelect: (value) {
              selectedTruck = truck[value]['label'];
              selectedValueTruck = false;
              setState(() {});
            },
            dataList: truck,
            selectedText: selectedTruck,
            viewDropDown: selectedValueTruck,
            onTab: () {
              selectedValueTruck = !selectedValueTruck;
              setState(() {});
            },
          ),
          15.height,

          // Date and Time
          InkWell(
            onTap: () async {
              final String? date = await commonDatePicker(context,  firstDate:  DateTime.now(), initialDate : DateTimeHelper.convertToDateTimeWithCurrentTime(dateTextController.text));
              if (date != null) {
                dateTextController.text = date;
              } else {
                dateTextController.clear();
              }
              setState(() {});
            },
            child: Container(
              height: 55,
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.svg.calendar, width: 20, colorFilter: AppColors.svg(AppColors.primaryIconColor),),
                  12.width,
                  Text(dateTextController.text.isEmpty ? context.appText.dateAndTime :  dateTextController.text, style: AppTextStyle.body).expand(),
                  Icon(Icons.keyboard_arrow_down, color: AppColors.greyIconColor, size: 20),
                ],
              ),
            ),
          ),
          20.height,

          // Consignment weight (MT)
          Container(
            height: 55,
            padding: EdgeInsets.all(10),
            decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
            child: Row(
              children: [
                SvgPicture.asset(AppIcons.svg.kgWeight),
                12.width,
                TextFormField(
                  controller: weightTextController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: context.appText.consignmentWeightWithMT,
                      hintStyle: AppTextStyle.body,
                      maintainHintHeight: true
                  ),
                ).expand(),
              ],
            ),
          ),
          20.height,

          // Suggested Price
          Container(
            padding: EdgeInsets.all(10),
            decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Suggested Price", style: AppTextStyle.textDarkGreyColor14w400),
                    Text("₹75,000 - ₹80, 000", style: AppTextStyle.textBlackColor16w500),
                  ],
                ),
                SizedBox.shrink().expand(),

                AppButton(
                  title: context.appText.postLoad,
                  onPressed: () async {

                    AppDialog.show(context, child: MarkAsFavouriteDialogUi());
                    //AppDialog.show(context, child: SuccessDialogView());
                  },
                ).expand(flex: 2),

              ],
            ),
          ),
          20.height,


          // Need Support Next
          InkWell(
              onTap: (){
                showCustomerCareBottomSheet(context);
                },
              child: Center(
                child: Text("Need Our Customer Support Help?",style: AppTextStyle.primaryColor14w400UnderLine),
              ),
          ),
        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding, vertical: 20),
    );
  }




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
