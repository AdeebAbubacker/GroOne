import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
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
  final LoadDetailsCubit cubit;
  final LPHomeCubit lpHomeCubit;
  const LoadDetailsWidget({super.key, required this.cubit,required this.lpHomeCubit});


  changeLoadStatus(BuildContext context,int? id) async {
    await cubit.changedLoadStatus(id??0,
      customerId:lpHomeCubit.state.profileDetailUIState?.data?.data?.customer?.id,
      loadStatus:cubit.state.loadStatus==LoadStatus.accepted ?   4 :3,
    ).then((value) {
      if(cubit.state.loadStatus==LoadStatus.accepted && cubit.state.vpLoadStatus?.status==Status.SUCCESS){
        AppDialog.show(
          context,
          child: SuccessDialogView(
            message: 'Load Accepted Successfully',
            afterDismiss: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    },);
    if ((cubit.state.loadStatus==LoadStatus.assigned)) {
      context.push(AppRouteName.tripScheduleScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
      buildWhen: (previous, current) => current!=previous,
      listener: (context, state) {

      },
      bloc: cubit,
      builder: (context, state) {
        print("state.vpLoadStatus ${state.vpLoadStatus}");
        LoadDetails? loadDetails;
        if (state.loadDetailsUIState?.status == Status.LOADING) {
          return CircularProgressIndicator().center();
        }
        if (state.loadDetailsUIState?.status == Status.ERROR) {
          return genericErrorWidget(
              error: state.loadDetailsUIState?.errorType);
        }
        if (state.loadDetailsUIState?.status == Status.SUCCESS) {
          final loads = state.loadDetailsUIState?.data;

          if (loads?.data == null) {
            return genericErrorWidget(error: NotFoundError());
          }
          loadDetails=loads?.data;

          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.55,
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
                    offset: Offset(
                        0, -2), // upward shadow (since it's a bottom sheet)
                  ),
                ]
            ),
            child: Column(
              children: [
                Expanded(child: ListView(
                  children: [
                    _buildRequestWidget((state.loadStatus==LoadStatus.accepted),loadDetails),

                    Divider(color: Color(0xffE1E1E1), thickness: 3),

                    12.height,
                    _buildSourceDestinationWidget(
                        (state.loadStatus==LoadStatus.accepted),loadDetails),
                    15.height,
                    _buildQuotedPriceWidget((state.loadStatus==LoadStatus.accepted),loadDetails?.rate),
                    15.height,
                    _buildLoadEntityWidget(loadDetails),

                    20.height,

                  ],
                )),
                Container(
                  decoration: commonContainerDecoration(
                      color: Colors.white,
                      blurRadius: 30,
                      shadow: state.loadStatus==LoadStatus.accepted

                  ), child: Row(
                  spacing: 10,
                  children: [
                    if(!(state.loadStatus==LoadStatus.accepted))
                      AppButton(
                        title: "Support",
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
                      isLoading:state.vpLoadStatus?.status==Status.LOADING,
                      title: state.loadStatus==LoadStatus.accepted
                          ? "Assign Driver"
                          : "Accept Load",
                      style: AppButtonStyle.primary.copyWith(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed:   () async {
                        changeLoadStatus(context,loadDetails?.id??0);
                      },
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    ).expand(),
                  ],
                ).paddingSymmetric(horizontal: 15, vertical: 12),
                ),

              ],
            ),
          );
        }
        return genericErrorWidget(error: GenericError());
      });
  }

  /// Build Request Widget
  Widget _buildRequestWidget(bool isAccepted,LoadDetails? loadDetails) {
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
                "${loadDetails?.truckType?.type} - ${loadDetails?.truckType?.subType}",
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

  Widget _buildSourceDestinationWidget(bool isAccepted,LoadDetails? loadDetails) {
    return AnimatedContainer(
      height: isAccepted ? 190: 200,

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
                      Text("${loadDetails?.pickUpLocation}",maxLines: 3,).expand(),
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
                      Text("${loadDetails?.dropLocation}"),
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

  Widget _buildQuotedPriceWidget(bool isAccepted,String? rate) {
    return Container(
      height: 37,
      padding: EdgeInsets.symmetric(horizontal: 10),

      decoration:commonContainerDecoration( color: AppColors.lightBlueColor,borderRadius: BorderRadius.circular(6)),

      child: Row(
        mainAxisAlignment:isAccepted ?  MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround,
        children: [
          Text( isAccepted? "Trip Price": "Quoted price"),
          Text(
            "$indianCurrencySymbol $rate",
            style: AppTextStyle.h1PrimaryColor.copyWith(fontSize: 20),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildLoadEntityWidget(LoadDetails? loadDetails) {
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
              loadDetails?.commodity?.name??"",
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
              "${loadDetails?.consignmentWeight} Ton",
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
