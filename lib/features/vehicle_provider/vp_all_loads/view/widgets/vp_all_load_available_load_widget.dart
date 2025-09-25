import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../../utils/app_route.dart';
import '../../../../kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import '../../../../kyc/view/kyc_pending_dialogue.dart';
import '../../../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';

class VpAllLoadAvailableLoadWidget extends StatefulWidget {
  final VpRecentLoadData data;
  final Function() onBack;
  const VpAllLoadAvailableLoadWidget({super.key, required this.data, required this.onBack});

  @override
  State<VpAllLoadAvailableLoadWidget> createState() => _VpAllLoadAvailableLoadWidgetState();
}

class _VpAllLoadAvailableLoadWidgetState extends State<VpAllLoadAvailableLoadWidget> {

  final AnalyticsService analyticsHelper = locator<AnalyticsService>();
  final bloc = locator<VpAcceptLoadBloc>();
  final lpHomeBloc = locator<LpHomeBloc>();

  @override
  Widget build(BuildContext context) {

    String amount = (widget.data.vpMaxRate??"").isNotEmpty && (widget.data.vpMaxRate??"").trim()!="0" ?
    "${PriceHelper.formatINR(widget.data.vpRate)} - ${PriceHelper.formatINR(widget.data.vpMaxRate)}":
    (widget.data.vpRate??"").isNotEmpty ? PriceHelper.formatINR(widget.data.vpRate)  : "--";

    bool isPriceIntoRange=checkPriceIntoRange(widget.data.vpRate, widget.data.vpMaxRate??"");

    return GestureDetector(
      onTap: () async {
       await context.push(AppRouteName.loadDetailsScreen,extra: {
          "loadId":widget.data.id
        }).then((value) {
         widget.onBack();
       },);
        },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: commonContainerDecoration(
          borderColor: AppColors.primaryColor,
          borderWidth: 1,
          color: AppColors.blackishWhite,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: commonContainerDecoration(
                    color: AppColors.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
                ),

                10.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data.loadId, style: AppTextStyle.h5),
                    Text(
                      formatDateTimeKavach(widget.data.createdAt?.toString() ??DateTime.now().toString()),
                      style: AppTextStyle.primaryColor12w400,
                    ),
                  ],
                ).expand(),
                5.width,
              ],
            ),
            10.height,
            Row(
              children: [
                _buildLocationInfoWidget(    widget.data.pickUpLocation.capitalize).expand(),
                Icon(
                  Icons.arrow_right_alt_outlined,
                  color: AppColors.primaryColor,
                ).paddingSymmetric(horizontal: 5).expand(),

                _buildLocationInfoWidget(   widget.data.dropLocation.capitalize,).expand(),

              ],
            ),
            commonDivider(),
            Row(
              children: [
                Column(
                  children: [
                    detailWidget(
                      text: widget.data.truckType?.type ?? "--",
                      iconSvg: AppIcons.svg.deliveryTruckSpeed,
                    ),
                    detailWidget(
                      text: widget.data.commodity?.name ?? "--",
                      iconSvg: AppIcons.svg.package,
                    ),
                  ],
                ).expand(),
                Column(
                  children: [
                    detailWidget(
                      text: widget.data.truckType?.subType ?? "--",
                      iconSvg: AppIcons.svg.deliveryTruckSpeed,
                    ),
                    detailWidget(
                      text: "${widget.data.consignmentWeight} ${context.appText.tonn}",
                      iconSvg: AppIcons.svg.weight,
                    ),
                  ],
                ).expand(),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.greyIconColor),
                  ),
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
            15.height,
            Container(

              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryLightColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                   context.appText.quotedPrice,
                    style: AppTextStyle.textBlackColor18w400,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).expand(),

                  Text(
                    amount,
                    style: AppTextStyle.h4PrimaryColor,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).expand(),
                ],
              ),
            ),
            20.height,
            BlocConsumer<VpAcceptLoadBloc, VpAcceptLoadState>(
              bloc: bloc,
              listener: (context, state) {
                if(state is VpAcceptLoadSuccess){
                  var parameter = {
                    "customerId": widget.data.customerId,
                    "customerName": widget.data.customer?.customerName ?? '',
                    "loadId": widget.data.id.toString(),
                    "status": "accepted",
                    "amount": amount,
                  };
                  analyticsHelper.logEvent(AnalyticEventName.ACCEPT_LOAD, parameter);
                }
              },
              listenWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return Row(
                  children: [
                    if(!isPriceIntoRange)
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

                    // Accept Load
                    AppButton(
                      buttonHeight: 40,
                      onPressed: () async {
                        if(isPriceIntoRange){
                          await callRedirect(SUPPORT_NUMBER);
                          return;
                        }

                        if (VpVariables.isKycVerified) {
                          bloc.add(VpAcceptLoad(loadId: widget.data.id.toString()));
                        } else {

                          commonBottomSheetWithBGBlur(
                            context: context,
                            screen: KycPendingDialogue(
                              hideButton:VpVariables.kycStatus==2  ,
                              onPressed: () {
                                context.pop();
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: EnterAadhaarNumberBottomSheet(),
                                ).then((_) {
                                  lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? "0"),
                                  );
                                });
                              },
                            ),
                          );
                        }
                      },
                      isLoading: state.loadingLoadIds?.contains(widget.data.id.toString()),
                      title:  isPriceIntoRange ? context.appText.adminContact: context.appText.acceptLoad,
                    ).expand(),
                  ],
                );
              },
            ),
          ],
        ),
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
        Text(text, style: AppTextStyle.body,
        maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).expand(),
      ],
    );
  }

  Widget _buildLocationInfoWidget(String? location){
    String locationText=location?.split(",").first??"";
    return Text(
      locationText,
      style: AppTextStyle.blackColor15w500,
      maxLines: 1,
    );
  }
}
