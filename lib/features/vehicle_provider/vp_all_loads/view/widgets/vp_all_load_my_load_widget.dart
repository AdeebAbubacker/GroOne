import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/helper/vp_my_load_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_status_label.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_progress_bar.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../../../utils/app_button.dart';
import '../../../../../utils/app_button_style.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_text_style.dart';
import '../../../../../utils/common_functions.dart';
import '../../../../../utils/common_widgets.dart';
import '../../../../../utils/constant_variables.dart';

class VpAllLoadMyLoadWidget extends StatefulWidget {
  const VpAllLoadMyLoadWidget({
    super.key,
    required this.data,
    required this.onClickAssignDriver,
     this.showButton=true,
  });

  final VpRecentLoadData data;
  final bool? showButton;
  final void Function()? onClickAssignDriver;

  @override
  State<VpAllLoadMyLoadWidget> createState() => _VpAllLoadMyLoadWidgetState();
}

class _VpAllLoadMyLoadWidgetState extends State<VpAllLoadMyLoadWidget> {
  @override
  Widget build(BuildContext context) {

    String amount = (widget.data.vpMaxRate??"").isNotEmpty && (widget.data.vpMaxRate??"").trim()!="0" ?
    "${PriceHelper.formatINR(widget.data.vpRate)} - ${PriceHelper.formatINR(widget.data.vpMaxRate)}":
    (widget.data.vpRate??"").isNotEmpty ? PriceHelper.formatINR(widget.data.vpRate)  : "0000 - 0000";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: commonContainerDecoration(
        borderColor: AppColors.primaryColor,
        borderWidth: 1,
        color: AppColors.blackishWhite,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppImage.png.truckMyLoad,
                width: 50,
              ).paddingSymmetric(vertical: 10),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.loadId, style: AppTextStyle.h5),
                  Text(
                    formatDateTimeKavach(widget.data.createdAt?.toString()??DateTime.now().toString()),
                    style: AppTextStyle.primaryColor12w400,
                  ),
                ],
              ).expand(),
              5.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      _buildLocationInfoWidget(widget.data.pickUpLocation),
                      Icon(
                        Icons.arrow_right_alt_outlined,
                        color: AppColors.primaryColor,
                      ).paddingSymmetric(horizontal: 2),
                      _buildLocationInfoWidget(widget.data.dropLocation),
                    ],
                  ),
                  if(widget.data.loadStatus>2)
                    VpMyLoadHelper.loadStatusWidget(widget.data.loadStatusValues!.name)
                  // LoadStatusLabel(
                  //     loadStatusTitle:widget.data.loadStatusDetails?.loadStatus,
                  //     loadStatus: widget.data.loadStatusValues,
                  // )
                ],
              ).expand(),
            ],
          ),

          commonDivider(),
          //  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")
          Row(
            children: [
              detailWidget(
                text: widget.data.truckType?.type ?? "--",
                iconSvg: AppIcons.svg.deliveryTruckSpeed,
              ),
              detailWidget(
                text: widget.data.truckType?.subType ?? "--",
                iconSvg: AppIcons.svg.deliveryTruckSpeed,
              ),
            ],
          ),
          10.height,
          Row(
            children: [
              detailWidget(
                text: widget.data.commodity?.name ?? "--",
                iconSvg: AppIcons.svg.package,
              ),
              detailWidget(
                text: "${widget.data.consignmentWeight} Tonn",
                iconSvg: AppIcons.svg.weight,
              ),
            ],
          ),

          Visibility(
            visible:(widget.data.loadStatusValues?.index??0)<LoadStatus.loading.index,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin:  EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryLightColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FittedBox(
                    child: Text(
                      widget.data.loadStatusValues==LoadStatus.assigned ? "Trip Price": "Accepted Price",
                      style: AppTextStyle.textBlackColor18w400,
                      textAlign: TextAlign.center,
                    )
                  ),
                  FittedBox(
                    child: Text(
                      amount,
                      style: AppTextStyle.h4PrimaryColor,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          10.height,
          _buildTrackingProgress(0.5,widget.data.loadStatusValues),
          //if(widget.showButton??true)
          Row(
            children: [
              IconButton(
                onPressed: () {
                  commonSupportDialog(context);
                },
                icon: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.svg.support,
                    width: 25,
                    colorFilter: AppColors.svg(AppColors.primaryColor),
                  ),
                ),
              ),
              10.width,

              // title:state.loadStatus==LoadStatus.completed ? "View Trip Settlement":
              //
              //
              //     ? "Assign Driver"
              //     : "Accept Load",

              VpMyLoadHelper.loadStatusButtonWidget(
                  status: widget.data.loadStatusValues!.name,
                  onPressed: () {  }
              ).expand(),

              // Visibility(
              //   visible:true,
              //
              //   // (widget.data.loadStatusValues?.index??0)<LoadStatus.loading.index,
              //   child: AppButton(
              //     buttonHeight: 40,
              //     onPressed: widget.onClickAssignDriver ?? () {},
              //     title:widget.data.loadStatusValues==LoadStatus.accepted?"Assign Driver":widget.data.loadStatusValues==LoadStatus.assigned ? "Start Trip":"Start Trip",
              //     style: AppButtonStyle.primary,
              //   ).expand(),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget detailWidget({required String text, required String iconSvg}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSvg,
          width: 18,
          colorFilter: AppColors.svg(AppColors.black),
        ),
        10.width,
        Text(text, style: AppTextStyle.body),
      ],
    ).expand();
  }

  Widget _buildLocationInfoWidget(String? location){
    String locationText=location?.split(",").first??"";
    return Text(
      locationText,
      style: AppTextStyle.blackColor15w500,
      maxLines: 2,
    );
  }



  Widget _buildTrackingProgress(double progress,LoadStatus? loadStatus){
    return Visibility(

      visible:false,
      // (loadStatus?.index??0)>LoadStatus.assigned.index && (loadStatus?.index??0) <=LoadStatus.inTransit.index ,
      child: Column(
        children: [
          commonDivider(),
          AppProgressBar(progress: progress),
          8.height,
          commonDivider(),
        ],
      ),
    );
  }
}