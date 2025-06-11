import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class RecentAddedLoadListBody extends StatefulWidget {
  final VpRecentLoadData data;
  const RecentAddedLoadListBody({super.key, required this.data});

  @override
  State<RecentAddedLoadListBody> createState() => _RecentAddedLoadListBodyState();
}

class _RecentAddedLoadListBodyState extends State<RecentAddedLoadListBody> {

  final bloc = locator<VpAcceptLoadBloc>();
  final vpRecentLoadListBloc = locator<VpRecentLoadListBloc>();



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: commonContainerDecoration(borderColor: AppColors.primaryColor, borderWidth: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ListTile(
          //   contentPadding: EdgeInsets.zero,
          //     title: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             Text(widget.data.pickUpAddr, style: AppTextStyle.h5w500, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left).expand(),
          //             Icon(Icons.arrow_right_alt_outlined, color: AppColors.primaryColor).paddingSymmetric(horizontal: 5),
          //             Text(widget.data.dropAddr, style: AppTextStyle.h5w500, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right).expand(),
          //           ],
          //         ),
          //         Text(widget.data.rate, style: AppTextStyle.body3GreyColor),
          //       ],
          //     ),
          //
          //     leading: Container(
          //       decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor, borderRadius: BorderRadius.circular(100)),
          //       child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
          //     ),
          //
          //     trailing: SvgPicture.asset(AppIcons.svg.support)
          // ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Column(
          //       children: [
          //
          //         Row(
          //           children: [
          //             SvgPicture.asset(AppIcons.svg.deliveryTruckSpeed),
          //             10.width,
          //             if(widget.data.truckType != null)
          //             Text("${widget.data.truckType!.subType} ${widget.data.truckType!.type}", style: AppTextStyle.body),
          //           ],
          //         ),
          //         10.height,
          //
          //         if(widget.data.commodity != null)...[
          //           Row(
          //             children: [
          //               SvgPicture.asset(AppIcons.svg.package),
          //               10.width,
          //               Text(widget.data.commodity!.name, style: AppTextStyle.body),
          //             ],
          //           ),
          //           10.height,
          //         ],
          //
          //
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             SvgPicture.asset(AppIcons.svg.kgWeight, width: 18, colorFilter: AppColors.svg(AppColors.black)),
          //             7.width,
          //             Text("${widget.data.consignmentWeight} Ton", style: AppTextStyle.body),
          //           ],
          //         ),
          //       ],
          //     ).expand(),
          //
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         // Advance Paid
          //        // if (widget.data.)
          //         statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid"),
          //         10.height,
          //
          //         Text("$indianCurrencySymbol${widget.data.rate}", style: AppTextStyle.h4),
          //       ],
          //     )
          //
          //
          //   ],
          // ),
          Row(
            children: [
              Container(
                decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor, borderRadius: BorderRadius.circular(100)),
                child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
              ),
              15.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(widget.data.pickUpAddr.capitalize, style: AppTextStyle.textBlackColor18w500,maxLines: 2,),
                      Icon(Icons.arrow_right_alt_outlined, color: AppColors.primaryColor).paddingSymmetric(horizontal: 5),
                      Text(widget.data.dropAddr.capitalize, style: AppTextStyle.textBlackColor18w500,maxLines: 2,),
                    ],
                  ),
                  Text(formatDateTimeKavach(widget.data.dueDate!.toString()), style: AppTextStyle.primaryColor12w400),
                ],
              ).expand()
            ],
          ),
          commonDivider(),
          Row(
            children: [
              Column(
                children: [
                  detailWidget(text: widget.data.truckType?.type??"--", iconSvg: AppIcons.svg.deliveryTruckSpeed),
                  detailWidget(text: widget.data.commodity?.name??"--", iconSvg: AppIcons.svg.package),
                ],
              ).expand(),
              Column(
                children: [
                  detailWidget(text: widget.data.truckType?.subType??"--", iconSvg: AppIcons.svg.deliveryTruckSpeed),
                  detailWidget(text: "${widget.data.consignmentWeight} Tonn", iconSvg: AppIcons.svg.weight)
                ],
              ).expand(),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: AppColors.greyIconColor)),
                  child: Icon(Icons.chevron_right,))
            ],
          ),
          15.height,
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColors.primaryLightColor),
            child: Row(
              children: [
                Text("Quoted Price", style: AppTextStyle.textBlackColor18w400,textAlign: TextAlign.center,).expand(),
                Text("$indianCurrencySymbol${widget.data.rate.isNotEmpty ? widget.data.rate : "0000 - 0000"}", style: AppTextStyle.h4PrimaryColor,textAlign: TextAlign.center,).expand(),
              ],
            ),
          ),
          20.height,
          // BlocListener<VpAcceptLoadBloc, VpAcceptLoadState>(
          //   bloc: bloc,
          //   listener: (context, state) {
          //     if (state is VpAcceptLoadSuccess) {
          //       vpRecentLoadListBloc.add(VpRecentLoadEvent());
          //       // showSuccessDialog(
          //       //     context,
          //       //     text: 'Load Accepted Successfully',
          //       //     subheading: ''
          //       // );
          //       // Future.delayed(Duration(seconds: 3),() {
          //       //   Navigator.of(context).pop();
          //       // },);
          //     }
          //     if (state is VpAcceptLoadError) {
          //       ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
          //     }
          //   },
          //   child: BlocBuilder<VpAcceptLoadBloc, VpAcceptLoadState>(
          //     bloc: bloc,
          //     builder: (context, state) {
          //       return Row(
          //         children: [
          //           IconButton(
          //             onPressed: () {},
          //             icon: Container(
          //               alignment: Alignment.center,
          //               padding: EdgeInsets.all(5),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 border: Border.all(color: AppColors.primaryColor, width: 1.5),
          //               ),
          //               child: SvgPicture.asset(AppIcons.svg.support, width: 25, colorFilter: AppColors.svg(AppColors.primaryColor)),
          //             ),
          //           ),
          //           10.width,
          //           AppButton(
          //             buttonHeight: 40,
          //             onPressed: () {
          //               bloc.add(VpAcceptLoad(loadId: widget.data.id.toString()));
          //             },
          //             isLoading: state is VpAcceptLoadLoading,
          //             title: 'Accept Load',
          //           ).expand(),
          //         ],
          //       );
          //     },
          //   ),
          // ),

          BlocListener<VpAcceptLoadBloc, VpAcceptLoadState>(
            listener: (context, state) {},
            bloc: bloc,
            child: BlocBuilder<VpAcceptLoadBloc, VpAcceptLoadState>(
            bloc: bloc,
            builder: (context, state) {
              return Row(
                children: [
                  IconButton(
                    onPressed: () {

                    },
                    icon: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsGeometry.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: AppColors.primaryColor,width: 1.5)),
                      child: SvgPicture.asset(AppIcons.svg.support , width: 25,colorFilter: AppColors.svg(AppColors.primaryColor),),
                    ),
                  ),
                  10.width,
                  // Accept
                  AppButton(
                    buttonHeight: 40,
                    onPressed: (){
                      bloc.add(VpAcceptLoad(loadId: widget.data.id.toString()));
                      if (state is VpAcceptLoadSuccess) {
                        vpRecentLoadListBloc.add(VpRecentLoadEvent());
                        AppDialog.show(context, child: SuccessDialogView(message: "Load Accepted Successfully"));
                      }
                      if (state is VpAcceptLoadError) {
                        ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
                      }
                    },
                    isLoading: state is VpAcceptLoadLoading,
                    title: 'Accept Load',
                  ).expand(),
                ],
              );
            },
          ),
          ),
        ],
      ),
    );
  }
  Widget detailWidget({required String text,required String iconSvg,}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(iconSvg, width: 18, colorFilter: AppColors.svg(AppColors.black)),
        10.width,
        Text(text, style: AppTextStyle.body),
      ],
    );
  }
}
