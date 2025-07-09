import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/kyc_upload_document_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../../utils/app_route.dart';
import '../../../../kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import '../../../../kyc/view/kyc_pending_dialogue.dart';
import '../../../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';

class RecentAddedLoadListBody extends StatefulWidget {
  final VpRecentLoadData data;
  final bool isKycDone;
  final num companyTypeId;
  const RecentAddedLoadListBody({super.key, required this.data, required this.isKycDone, required this.companyTypeId});

  @override
  State<RecentAddedLoadListBody> createState() => _RecentAddedLoadListBodyState();
}

class _RecentAddedLoadListBodyState extends State<RecentAddedLoadListBody> {

  final bloc = locator<VpAcceptLoadBloc>();
  final lpHomeBloc = locator<LpHomeBloc>();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        /// TODO:
        /// Temp navigation remote remove it after you done design part
        context.push(AppRouteName.loadDetailsScreen,extra: {
          "loadId":widget.data.id
        });
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
              children: [
                Container(
                  decoration: commonContainerDecoration(
                    color: AppColors.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
                ),
                15.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.data.pickUpWholeAddr.capitalize,
                          style: AppTextStyle.textBlackColor18w500,
                          maxLines: 1,
                        ).expand(),
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: AppColors.primaryColor,
                        ).paddingSymmetric(horizontal: 5).expand(),
                        Text(
                          widget.data.dropWholeAddr.capitalize,
                          style: AppTextStyle.textBlackColor18w500,
                          maxLines: 1,
                        ).expand(),
                      ],
                    ),
                    Text(
                      formatDateTimeKavach(widget.data.createdAt?.toString()??DateTime.now().toString()),
                      style: AppTextStyle.primaryColor12w400,
                    ),
                  ],
                ).expand(),
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
                      text: "${widget.data.consignmentWeight} Tonn",
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
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryLightColor,
              ),
              child: Row(
                children: [
                  Text(
                    "Quoted Price",
                    style: AppTextStyle.textBlackColor18w400,
                    textAlign: TextAlign.center,
                  ).expand(),
                  Text(
                    (widget.data.vpMaxRate??"").isNotEmpty && (widget.data.vpMaxRate??"")!="0"?
                    "$indianCurrencySymbol${widget.data.vpRate} - $indianCurrencySymbol${widget.data.vpMaxRate}":
                    "$indianCurrencySymbol${(widget.data.vpRate??"").isNotEmpty ? widget.data.vpRate : "0000 - 0000"}",
                    style: AppTextStyle.h4PrimaryColor,
                    textAlign: TextAlign.center,
                  ).expand(),
                ],
              ),
            ),
            20.height,
            BlocBuilder<VpAcceptLoadBloc, VpAcceptLoadState>(
              bloc: bloc,
              builder: (context, state) {
                return Row(
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
                    AppButton(
                      buttonHeight: 40,
                      onPressed: () {
                        if (widget.isKycDone) {
                          bloc.add(
                            VpAcceptLoad(loadId: widget.data.id.toString()),
                          );
                        } else {
                          commonBottomSheetWithBGBlur(
                            context: context,
                            screen: KycPendingDialogue(
                              onPressed: () {
                                context.pop();
                                CustomLog.debug(this, 'Recent Load Company Id : ${widget.companyTypeId}');
                                if (widget.companyTypeId == 2 || widget.companyTypeId == 1) {
                                  commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                                } else {
                                  Navigator.of(context).push(commonRoute(KycUploadDocumentScreen()));
                                }
                              },
                            ),
                          );
                        }
                      },
                      isLoading: state.loadingLoadIds?.contains(widget.data.id.toString()),
                      title: 'Accept Load',
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
        Text(text, style: AppTextStyle.body),
      ],
    );
  }
}
