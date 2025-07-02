import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/google_map_widdget.dart';

import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_details_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_status_label.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class VpLoadDetailsScreen extends StatefulWidget {
  final int? loadId;
  const VpLoadDetailsScreen({super.key, required this.loadId});

  @override
  State<VpLoadDetailsScreen> createState() => _VpLoadDetailsScreenState();
}

class _VpLoadDetailsScreenState extends State<VpLoadDetailsScreen> {
  final cubit = locator<LoadDetailsCubit>();
  final homeCubit = locator<LPHomeCubit>();


  /// Map Style
  getLoadDetails() {
    frameCallback(() => cubit.getLoadDetails(widget.loadId ?? 0));
  }


  @override
  void initState() {
    getLoadDetails();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: LoadDetailsWidget(cubit: cubit,lpHomeCubit: homeCubit,),
        body: BlocBuilder<LoadDetailsCubit, LoadDetailsState>(
          bloc: cubit,
          builder: (context, state) {
            if (state.loadDetailsUIState?.status == Status.LOADING) {
              return CircularProgressIndicator().center();
            }
            if (state.loadDetailsUIState?.status == Status.ERROR) {
              return genericErrorWidget(
                error: state.loadDetailsUIState?.errorType,
              );
            }
            if (state.loadDetailsUIState?.status == Status.SUCCESS) {
              final loads = state.loadDetailsUIState?.data;
              if (loads?.data == null) {
                return genericErrorWidget(error: NotFoundError());
              }

              return Stack(
                children: [
                  Positioned.fill(child: GoogleMapWidget(
                      pickupLocation: loads!.data!.pickUpLocation,
                    dropLocation: loads.data!.dropLocation,
                    pickUpLatLong: loads.data!.pickUpLatlon,
                    dropLatLong: loads.data!.dropLatlon,
                  )),
                  Positioned(
                    top: 15,
                    left: 15,
                    right: 15,
                    child: buildSourceAndDestinationWidget(loads.data!)
                  ),
                ],
              );
            }
            return genericErrorWidget(error: GenericError());
          },
        ),
      ),
    );
  }

  /// Build Source And Destination
  Widget buildSourceAndDestinationWidget(LoadDetails loadDetails) {
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
                    "${loadDetails.loadId}",
                    style: TextStyle(color: AppColors.textBlackDetailColor),
                  ),
                  Spacer(),

                  Text(
                    DateTimeHelper.formatCustomDate(
                      loadDetails.createdAt ?? DateTime.now(),
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
                    loadDetails.pickUpLocation,
                    DateTimeHelper.getFormattedDate(
                      DateTime.tryParse(loadDetails.pickUpDateTime??"")?? DateTime.now(),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                  _buildLocationDetailsTileWidget(
                    loadDetails.dropLocation,
                    DateTimeHelper.getFormattedDate(
                      loadDetails.expectedDeliveryDateTime ?? DateTime.now(),
                    ),
                  ),
                  if (state.loadStatus==LoadStatus.accepted || state.loadStatus==LoadStatus.assigned)
                   ...[

                     LoadStatusLabel(loadStatus: state.loadStatus!),
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
        Text(date ?? "", style: TextStyle(color: AppColors.grayColor)),
      ],
    );
  }
}
