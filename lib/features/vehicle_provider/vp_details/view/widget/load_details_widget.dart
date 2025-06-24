import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/assign_driver_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/assign_driver_state.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LoadDetailsWidget extends StatelessWidget {
  final AssignDriverCubit cubit;
  const LoadDetailsWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignDriverCubit, AssignDriverState>(
      builder: (context, state) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // light shadow
                  blurRadius: 30,
                  offset: Offset(0, -2), // upward shadow (since it's a bottom sheet)
                ),
              ]
            ),
            child: Column(
              children: [
                Expanded(child: ListView(
                  children: [
                    _buildRequestWidget(state.isLoadAccepted),

                    Divider(color: Color(0xffE1E1E1), thickness: 3),

                    12.height,
                    _buildSourceDestinationWidget(state.isLoadAccepted),
                    15.height,
                    _buildQuotedPriceWidget(state.isLoadAccepted),
                    15.height,
                    _buildLoadEntityWidget(),

                    20.height,

                  ],
                )),
                Container(

                 decoration:commonContainerDecoration(
                   color:  Colors.white,
                   blurRadius: 30,
                   shadow: state.isLoadAccepted

                 ), child: Row(
                    spacing: 10,
                    children: [
                      if(!state.isLoadAccepted)
                        AppButton(
                          title: "Customer Support",
                          style: AppButtonStyle.outline.copyWith(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          textStyle: TextStyle(fontSize: 14),
                        ).expand(),
                      AppButton(
                        title: state.isLoadAccepted ? "Assign Driver": "Accept Load",
                        style: AppButtonStyle.primary.copyWith(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if(state.isLoadAccepted){
                            context.push(AppRouteName.tripScheduleScreen);
                          }else{
                            AppDialog.show(
                              context,
                              child: SuccessDialogView(
                                message: 'Load Accepted Successfully',
                                afterDismiss: () {
                                  if (context.mounted){
                                    Navigator.pop(context);
                                    cubit.acceptLoad();
                                  }
                                },
                              ),
                            );
                          }


                        },
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ).expand(),
                    ],
                  ).paddingSymmetric(horizontal: 15,vertical: 12),
                ),

              ],
            ),
          );
      },
    );
  }

  /// Build Request Widget
  Widget _buildRequestWidget(bool isAccepted) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Image.asset(AppImage.png.dummyTruckLoad, width: 57, height: 42),
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Requested", style: AppTextStyle.body1GreyColor.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color:Color(0xff979797)
              )),
              Text(
                "Closed - 30 Ft SXL",
                style: AppTextStyle.body1BlackColor.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.textBlackDetailColor
                ),
              ),
            ],
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildSourceDestinationWidget(bool isAccepted) {
    return AnimatedContainer(
      height: isAccepted ? 180: 160,

      padding: EdgeInsets.symmetric(vertical: 13),
      decoration:commonContainerDecoration(
        color: AppColors.backGroundBlue,
        borderColor:  AppColors.disableColor,
        borderRadius: BorderRadius.circular(8)
      ),


      duration: Duration(milliseconds: 300),
      child: Column(
        children: [
          if (isAccepted)
            Container(
              height: 30,

              padding: EdgeInsets.symmetric(horizontal: 10),

              decoration: commonContainerDecoration(
                color: Color(0xffE5EBFF),
                borderRadius: BorderRadius.circular(6),
              ),


              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("LP: Nestle India Pvt ltd",style: AppTextStyle.h3.copyWith(
                    fontWeight: FontWeight.w100,
                    fontSize: 13,

                    color: AppColors.primaryColor
                  ),)),
            ).paddingSymmetric(
              horizontal: 13
            ),
          10.height,

          Row(
            children: [
              Column(
                spacing: 3,
                children: [
                  SvgPicture.asset(
                    AppIcons.svg.myLocation,
                    height: 18,
                    width: 18,
                  ),
                  ...List.generate(
                    8,
                    (index) => Container(
                      height: 3,
                      width: 1,
                      color: AppColors.dividerColor,
                    ),
                  ),
                  SvgPicture.asset(
                    AppIcons.svg.markerLocation,
                    height: 18,
                    width: 18,
                  ),
                ],
              ).expand(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Source",
                        style: AppTextStyle.h3w500.copyWith(
                          color: AppColors.textBlackColor,
                          fontSize: 14,

                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text("Bangalore"),
                    ],
                  ).expand(),
                   commonDivider(),
                  Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Destination",
                        style: AppTextStyle.h3w500.copyWith(
                          color: AppColors.textBlackColor,
                          fontSize: 14,

                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text("Himachal Pradesh"),
                    ],
                  ).expand(),
                ],
              ).expand(flex: 7),
            ],
          ).expand(),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildQuotedPriceWidget(bool isAccepted) {
    return Container(
      height: 37,
      padding: EdgeInsets.symmetric(horizontal: 10),

      decoration:commonContainerDecoration( color: AppColors.lightBlueColor,borderRadius: BorderRadius.circular(6)),

      child: Row(
        mainAxisAlignment:isAccepted ?  MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround,
        children: [
          Text( isAccepted? "Trip Price": "Quoted price"),
          Text(
            !isAccepted ?  "$indianCurrencySymbol 79,000 - ₹ 82,000":"$indianCurrencySymbol 79,000",
            style: AppTextStyle.h1PrimaryColor.copyWith(fontSize: 20),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildLoadEntityWidget() {
    return Wrap(
      spacing: 15,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppIcons.svg.package, height: 24, width: 24),
            Text(
              "Agricultural Products",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.svg.kgWeight,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),

            Text(
              "5 - 6 Ton",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.svg.locationDistance,
              height: 24,
              width: 24,
            ),

            Text(
              "534 KM",
              style: AppTextStyle.bodyGreyColorW500.copyWith(
                color: AppColors.veryLightGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 15);
  }
}
