import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';

import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/helper/vp_my_load_ui_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/vp_load_details_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_status_label.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_progress_bar.dart';
import 'package:gro_one_app/utils/app_route.dart';
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
     this.onBack,
  });

  final VpRecentLoadData data;
  final bool? showButton;
  final void Function()? onClickAssignDriver;
  final void Function()? onBack;

  @override
  State<VpAllLoadMyLoadWidget> createState() => _VpAllLoadMyLoadWidgetState();
}

class _VpAllLoadMyLoadWidgetState extends State<VpAllLoadMyLoadWidget> {

  final loadDetailsCubit= locator<LoadDetailsCubit>();
  final vpHomeBloc= locator<VpHomeBloc>();


  @override
  Widget build(BuildContext context) {

    String amount = (widget.data.vpMaxRate??"").isNotEmpty && (widget.data.vpMaxRate??"").trim()!="0" ?
    "${PriceHelper.formatINR(widget.data.vpRate)} - ${PriceHelper.formatINR(widget.data.vpMaxRate)}":
    (widget.data.vpRate??"").isNotEmpty ? PriceHelper.formatINR(widget.data.vpRate)  : "0000 - 0000";

    bool isPriceIntoRange=checkPriceIntoRange(widget.data.vpRate, widget.data.vpMaxRate);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
              Image.asset(AppImage.png.truckMyLoad, width: 50),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.data.loadId, style: AppTextStyle.h5),
                    ],
                  ),
                  Text(
                    formatDateTimeKavach(widget.data.createdAt?.toString() ??DateTime.now().toString()),
                    style: AppTextStyle.primaryColor12w400,
                  ),
                ],
              ).expand(),
              5.width,
              if(widget.data.loadStatus>2 && widget.data.loadStatusDetails != null)
                VpMyLoadUIHelper.loadStatusWidget(
                    statusBgColor: widget.data.loadStatusDetails!.statusBgColor,
                    statusTxtColor: widget.data.loadStatusDetails!.statusTxtColor,
                    (widget.data.loadUnHold??false) ? context.appText.loadOnHold:
                    widget.data.loadStatusDetails!.loadStatus, context)

            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocationInfoWidget(widget.data.pickUpLocation).expand(),
              Icon(
                Icons.arrow_right_alt_outlined,
                color: AppColors.primaryColor,
              ).paddingSymmetric(horizontal: 2).expand(),
              _buildLocationInfoWidget(widget.data.dropLocation).expand(),
            ],
          ),
          commonDivider(),
          //  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")

          if(widget.data.loadStatusDetails != null)...[
            VpMyLoadUIHelper.simTrackingWidget(context: context, status: widget.data.loadStatusDetails!.loadStatus, driverConsent:  widget.data.driverConsent??0),

            // VpMyLoadUIHelper.progressTrackingWidget(status: widget.data.loadStatusDetails!.loadStatus, progress: 0.3),
          ],


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
                text: "${widget.data.consignmentWeight} ${context.appText.tons}",
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
                      widget.data.loadStatusValues==LoadStatus.assigned ? context.appText.tripPrice : context.appText.acceptedPrice ,
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


          if(widget.data.loadUnHold==false)
          Row(
            children: [

                // Support Button
                IconButton(
                  onPressed: () {
                    commonSupportDialog(context);
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: commonContainerDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(commonButtonRadius), borderColor: AppColors.primaryColor, borderWidth: 1.5),
                    child: SvgPicture.asset(
                      AppIcons.svg.support,
                      width: 25,
                      colorFilter: AppColors.svg(AppColors.primaryColor),
                    ),
                  ),
                ),
                10.width,

              // Action Button
                if(widget.data.loadStatusDetails != null)
                  ///TODO:
                  ///Add document list once it get from api
                  VpMyLoadUIHelper.loadStatusButtonWidget(
                    status: widget.data.loadStatusDetails!.loadStatus,
                    isIntoRangePrice: isPriceIntoRange,
                      isPodAdded: widget.data.podDispatch!=null,
                      enable:  loadDetailsCubit.checkAllDocumentAddedOrNot(
                      loadStatus: widget.data.loadStatusValues ,
                      documentList: widget.data.loadDocument??[]
                    ),
                      context: context,
                    onPressed: () async {
                      if(isPriceIntoRange){
                        await callRedirect(SUPPORT_NUMBER);
                        return;
                      }
                      _handleOnTap(widget.data.loadStatusDetails,widget.data.loadStatusValues,widget.data.id,widget.data.loadStatus.toInt());
                    }
                ).expand(),


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
          width: 20,
          colorFilter: AppColors.svg(AppColors.black),
        ),
        10.width,
        Text(text, style: AppTextStyle.body),
      ],
    ).expand();
  }

  Widget _buildLocationInfoWidget(String? location) {
  String locationText = location?.split(",").first ?? "";

  return Tooltip(
    message: locationText,
    child: Text(
      locationText,
      style: AppTextStyle.blackColor15w500,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}


  _handleOnTap(LoadStatusDetailsResponse? loadStatus,LoadStatus? loadStatusValues,String? id,int? loadStatusId) async {
     String? userId = await vpHomeBloc.getUserId();
      if((loadStatusValues?.index??0)>LoadStatus.assigned.index && loadStatusValues!=LoadStatus.completed && loadStatusValues!=LoadStatus.podDispatched){
        await loadDetailsCubit.changedLoadStatus(
            id??"0",
            customerId: userId??"",
            loadStatus:(loadStatusId??0)+1
        );
        widget.onBack!();
        return;
      }

     await Navigator.push(context, commonRoute(VpLoadDetailsScreen(
        loadId: id,
      ))).then((value) {
        widget.onBack!();
     },);
  }



}