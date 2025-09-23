import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/google_map_widdget.dart';

import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_details_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_status_label.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class VpLoadDetailsScreen extends StatefulWidget {
  final String? loadId;
  final num? companyTypeId;
  final String? loadSeriesID;

  const VpLoadDetailsScreen({super.key, required this.loadId,this.companyTypeId,this.loadSeriesID});

  @override
  State<VpLoadDetailsScreen> createState() => _VpLoadDetailsScreenState();
}

class _VpLoadDetailsScreenState extends State<VpLoadDetailsScreen> {

  final cubit = locator<LoadDetailsCubit>();
  final homeCubit = locator<LPHomeCubit>();
  final vpHomeBloc = locator<VpHomeBloc>();
  bool _consentStatusCalled = false;


  /// Get Load Details

  getLoadDetails() {
    frameCallback(() => cubit.getLoadDetails(widget.loadId ?? ""));
  }

  @override
  void initState() {
    getLoadDetails();
    _resetPreviousDocumentState();
    super.initState();
  }



  void _resetPreviousDocumentState(){
    cubit.resetTripDocumentState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
          bloc: cubit,
            builder: (context, state) {
            if (state.loadDetailsUIState?.status == Status.LOADING) {
              return CircularProgressIndicator().center();
            }
            if (state.loadDetailsUIState?.status == Status.ERROR) {
              return VpHelper.withSliverRefresh(
                  () => getLoadDetails(),
                  child: genericErrorWidget(
                error: state.loadDetailsUIState?.errorType,
              ));
            }
            if (state.loadDetailsUIState?.status == Status.SUCCESS) {
              final loads = state.loadDetailsUIState?.data;
              if (loads?.data == null) {
                return VpHelper.withSliverRefresh(
                        () => getLoadDetails(),
                    child: genericErrorWidget(error: NotFoundError()));
              }
              return Stack(
                children: [
                  Positioned.fill(child: GoogleMapWidget(
                    driverLat: loads?.data?.trackingDetails?.currentLat,
                    driverLong:  loads?.data?.trackingDetails?.currentLong,
                    pickupLocation: loads?.data?.loadRoute?.pickUpLocation,
                    dropLocation: loads?.data?.loadRoute?.dropLocation,
                    pickUpLatLong: loads?.data?.loadRoute?.pickUpLatlon,
                    dropLatLong: loads?.data?.loadRoute?.dropLatlon,
                  )),
                  Positioned(
                    top: 15,
                    left: 16,
                    right: 16,
                    child: buildSourceAndDestinationWidget(loads?.data)
                  ),

                  LoadDetailsWidget(
                    vpHomeBloc: vpHomeBloc,
                    cubit: cubit,lpHomeCubit: homeCubit,
                  ),
                  buildFloatingWidget(),
                  if((state.loadStatusId??0)>4)
                  buildSimConsentWidget(loads?.data?.driverConsent??0)
                ],
              );
            }
        
            return genericErrorWidget(error: GenericError());
          },
          listener: (context, state) {
            if (state.loadDetailsUIState?.status == Status.SUCCESS) {
              final loads = state.loadDetailsUIState?.data;
              if (loads?.data !=null) {
                if ((state.loadStatusId??0)>=4 && !_consentStatusCalled) {
                  _consentStatusCalled = true;
                }
              }
            }
          }
          ),
      ),
      floatingActionButton: ChatActionButton(),
    );
  }



  /// Support
  Widget buildFloatingWidget() {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomWidgetMaxHeight = screenHeight * 0.45;

    return Positioned(
        right: 5, bottom: bottomWidgetMaxHeight + 10,child: Column(
      children: [

        // IconButton(
        //       onPressed: () {},
        //       icon: Container(
        //         padding: EdgeInsets.all(4),
        //         decoration: commonContainerDecoration(shadow: true,shadowColor: AppColors.secondaryButtonColor,borderRadius: BorderRadius.circular(20)),
        //         child: Icon(Icons.location_searching, color: AppColors.primaryColor),
        //       )
        //   ),
        IconButton(
            onPressed: () {
              commonSupportDialog(context);
            },
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: commonContainerDecoration(shadow: true,shadowColor: AppColors.secondaryButtonColor,borderRadius: BorderRadius.circular(20)),
              child: SvgPicture.asset(
                AppIcons.svg.support,
                width: 25,
                colorFilter: AppColors.svg(AppColors.primaryColor),
              ),
            )
        ),

      ],
    ));
  }

  Widget buildSimConsentWidget(int driverConsent) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomWidgetMaxHeight = screenHeight * 0.45;
    final isTrackingAllowed = driverConsent==1;

    return Positioned(
      left: 12, bottom: bottomWidgetMaxHeight + 15,
      child: Container(
        decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Container(decoration: BoxDecoration(shape: BoxShape.circle, color: isTrackingAllowed ? AppColors.activeDarkGreenColor : AppColors.red), height: 12, width: 12),
            10.width,
            Text(context.appText.sim, style: AppTextStyle.h5 )
          ],
        ).paddingAll(8),
      ),
    );

  }

  /// Build Source And Destination
  Widget buildSourceAndDestinationWidget(LoadDetailModelData? loadDetails) {
    return BlocBuilder<LoadDetailsCubit, LoadDetailsState>(
      builder: (context, state) {
        return Container(
          decoration: commonContainerDecoration(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(onTap: () {
                    Navigator.pop(context);
                  },child: Icon(Icons.arrow_back)),
                  8.width,
                  Text(
                    "${loadDetails?.loadSeriesId}",
                    style: TextStyle(color: AppColors.textBlackDetailColor),
                  ),
                  Spacer(),

                  Text(
                    DateTimeHelper.formatCustomDate(
                      loadDetails?.createdAt ?? DateTime.now(),
                    ),
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              12.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLocationDetailsTileWidget(
                    loadDetails?.loadRoute?.pickUpLocation,
                    DateTimeHelper.formatCustomDateIST(
                      loadDetails?.pickUpDateTime?? DateTime.now(),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                  20.width,
                  _buildLocationDetailsTileWidget(
                    loadDetails?.loadRoute?.dropLocation,
                      'ETA: ${DateTimeHelper.formatCustomDateIST(loadDetails?.expectedDeliveryDateTime ?? DateTime.now())}'
                  ),

                  if ((state.loadStatusId??1)>=3)
                   ...[
                      LoadStatusLabel(
                         loadOnHold: loadDetails?.loadOnHold??false,
                         loadStatusTitle:loadDetails?.loadStatusDetails?.loadStatus??"" ,
                         loadStatus: state.loadStatus!,
                         statusBgColor: loadDetails?.loadStatusDetails?.statusBgColor ??"" ,
                         statusTxtColor: loadDetails?.loadStatusDetails?.statusTxtColor ?? "",
                         ),
                   ]
                ],
              ).paddingSymmetric(horizontal: 5),
            ],
          ).paddingAll(commonRadius),
        );
      },
    );
  }

  /// Google Map


  /// Location Details
  _buildLocationDetailsTileWidget(String? location, String? date) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (location??"").split(",")[0],
          style: TextStyle(color: AppColors.black, fontSize: 16),
          maxLines: 1,
        ),
        FittedBox(child: Text(date ?? "", style: TextStyle(color: AppColors.grayColor))),
      ],
    ).expand();
  }
}
