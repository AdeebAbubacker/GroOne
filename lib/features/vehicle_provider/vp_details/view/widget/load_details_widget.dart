import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/source_destination_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/trip_schedule_screen.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => TripScheduleScreen(),));
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
            decoration:commonContainerDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              shadow: true
            ),
            child: Column(
              children: [

                Expanded(child: ListView(
                  children: [

                    _buildRequestWidget((state.loadStatus==LoadStatus.accepted),loadDetails),
                    10.height,
                    Divider(color: Color(0xffE1E1E1), thickness: 3),

                    12.height,
                    SourceDestinationWidget(
                      pickUpLocation: loadDetails?.pickUpLocation,
                      dropLocation:  loadDetails?.dropLocation,
                    ).paddingSymmetric(horizontal: 15),

                    15.height,
                    _buildQuotedPriceWidget((state.loadStatus==LoadStatus.accepted),loadDetails?.rate, loadDetails?.vpRate, loadDetails?.vpMaxRate),
                    15.height,
                    _buildLoadEntityWidget(loadDetails,state.locationDistance),
                    20.height,
                    if(state.loadStatus==LoadStatus.assigned)
                      ...[
                        Text("Timeline", style: AppTextStyle.h4).paddingSymmetric(horizontal: 15),
                        20.height,
                        LoadTimelineWidget(
                          timelineList: loadDetails?.timeline??[],
                        ).paddingSymmetric(horizontal: 15),
                      ]
                  ],
                )),
                _buildBottomButtonWidget(loadDetails ,state,context)


              ],
            ).paddingTop(15),
          );
        }
        return genericErrorWidget(error: GenericError());
      });
  }

  /// Build Request Widget
  Widget _buildRequestWidget(bool isAccepted,LoadDetails? loadDetails) {
    return SizedBox(
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



  Widget _buildQuotedPriceWidget(bool isAccepted,String? rate, String? vpRate, String? vpMaxRate) {
    final vpLoadPrice = (vpMaxRate == null || vpMaxRate.isEmpty || vpMaxRate == "0")
        ? PriceHelper.formatINR(vpRate)
        : '${PriceHelper.formatINR(vpRate)} - ${PriceHelper.formatINR(vpMaxRate)}';
    return Container(
      height: 37,
      padding: EdgeInsets.symmetric(horizontal: 10),

      decoration:commonContainerDecoration( color: AppColors.lightBlueColor,borderRadius: BorderRadius.circular(6)),

      child: Row(
        mainAxisAlignment:isAccepted ?  MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround,
        children: [
          Text( isAccepted? "Trip Price": "Quoted price"),
          Text(
            vpLoadPrice,
            style: AppTextStyle.h1PrimaryColor.copyWith(fontSize: 20),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 15);
  }

  Widget _buildLoadEntityWidget(LoadDetails? loadDetails,String?locationDistance ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 15,

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
              "$locationDistance KM",
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

  Widget _buildBottomButtonWidget(LoadDetails? loadDetails,LoadDetailsState state,BuildContext context){
  return  Container(
      decoration: commonContainerDecoration(
          color: Colors.white,
          blurRadius: 30,
          shadow: state.loadStatus==LoadStatus.accepted || state.loadStatus==LoadStatus.assigned
      ), child: Row(
      spacing: 10,
      children:   [
        ...[
           if(state.loadStatus==LoadStatus.matching)
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
           if(state.loadStatus==LoadStatus.matching || state.loadStatus==LoadStatus.accepted)
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
           if(state.loadStatus==LoadStatus.assigned)
             SizedBox(
               height: 60,
               width:MediaQuery.of(context).size.width * 0.90,
               child: CustomSwipeButton(
                 padding: 0,
                 price:0,
                 loadId: "",
                 text: "Swipe to Start Trip",
                 onSubmit: () {
                   return null;

                   },),
             )

         ],
      ],
    ).paddingSymmetric(horizontal: 15, vertical: 12),
    );
  }
}
