import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';




class TripDetails extends StatelessWidget {
  const TripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return _tripDetailsWidget(context);
  }

  Widget _tripDetailsWidget(BuildContext context) {
    return BlocBuilder<LoadDetailsCubit,LoadDetailsState>(
      builder: (context, state)  {
        LoadDetailModelData? loadDetails=state.loadDetailsUIState?.data?.data;
        String amount=(loadDetails?.loadPrice?.vpMaxRate??"").isNotEmpty && (loadDetails?.loadPrice?.vpMaxRate??"").trim()!="0" ?
        "${PriceHelper.formatINR(loadDetails?.loadPrice?.vpRate)} - ${PriceHelper.formatINR(loadDetails?.loadPrice?.vpMaxRate)}":
        (loadDetails?.loadPrice?.vpRate??"").isNotEmpty ? PriceHelper.formatINR(loadDetails?.loadPrice?.vpRate) : "0000 - 0000";

        return Container(
          decoration: BoxDecoration(
            color: AppColors.blackishWhite,
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),

          child: Column(
            children: [
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color(0xffDFE6FF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: SvgPicture.asset(AppIcons.svg.orderBox)),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  loadDetails?.loadSeriesId??"",
                                  style: AppTextStyle.h5w500.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>  commonSupportDialog(context),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    child: SvgPicture.asset(AppImage.svg.support),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // TODO:
                                    // put company name
                                    Text(
                                      "${loadDetails?.customer?.companyName}",
                                      style: AppTextStyle.h5w500.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textGreyDetailColor,
                                      ),
                                    ),
                                    Text(
                                      DateTimeHelper.getFormattedDate(loadDetails?.createdAt??DateTime.now()),
                                      style: AppTextStyle.h3PrimaryColor.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w100,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    5.height,
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.70,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${loadDetails?.loadRoute?.pickUpLocation.split(",").first} ",maxLines: 1,overflow: TextOverflow.ellipsis,).expand(),
                                          Icon(Icons.arrow_forward, size: 12),
                                          Text(
                                            "${loadDetails?.loadRoute?.dropLocation.split(",").first}",maxLines: 1,overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.end,


                                          ).expand(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 15, vertical: 10),
                Divider(
                  indent: 30,
                  endIndent: 30,
                  thickness: 0.5),

              10.height,
              Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      _buildTripEntityTiles(AppIcons.svg.deliveryTruckSpeed,loadDetails?.truckType?.type??"").expand(),
                      _buildTripEntityTiles(AppIcons.svg.deliveryTruckSpeed,"${loadDetails?.truckType?.subType}").expand(),
                    ],
                  ),

                  Row(
                    children: [
                      _buildTripEntityTiles(AppIcons.svg.package,"${loadDetails?.commodity?.name}").expand(),
                      _buildTripEntityTiles(AppIcons.svg.weight,"${loadDetails?.weight?.value} Ton").expand(),
                    ],
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
              15.height,

              Container(
                padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightBlueColor,
                borderRadius: BorderRadius.circular(8)
              ),
                child: Column(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPriceBreakDownWidget(context.appText.acceptedPrice,amount),
                    // _buildPriceBreakDownWidget("Advance Amount","65,000"),
                    // _buildPriceBreakDownWidget("Balance Amount","8000"),
                  ],
                ),
              ).paddingSymmetric(horizontal: 20),
              15.height,
            ],
          ),
        );
      }
    );
  }

  Widget _buildTripEntityTiles(String icon,String title){
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(icon),
        Text(title).expand()
      ],
    );
  }


  Widget _buildPriceBreakDownWidget(String title,String price){
return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(title,style: AppTextStyle.h5.copyWith(
      fontSize: 16,
      color: AppColors.textBlackColor,
      fontWeight: FontWeight.w200

    ),),
    Text(price,style:  AppTextStyle.h5.copyWith(
        fontSize: 16,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w200

    ),)
  ],
);
  }




}
