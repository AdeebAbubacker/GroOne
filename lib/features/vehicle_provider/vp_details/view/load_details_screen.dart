import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
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
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LoadDetailsScreen extends StatefulWidget {
  final int? loadId;
  const LoadDetailsScreen({super.key, required this.loadId});

  @override
  State<LoadDetailsScreen> createState() => _LoadDetailsScreenState();
}

class _LoadDetailsScreenState extends State<LoadDetailsScreen> {
  final cubit = locator<LoadDetailsCubit>();
  final homeCubit = locator<LPHomeCubit>();

  GoogleMapController? _mapController;

  /// Map Style
  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }

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
                  Positioned.fill(child: buildGoogleMapWidget()),
                  Positioned(
                    top: 15,
                    left: 15,
                    right: 15,
                    child: buildSourceAndDestinationWidget(loads!.data!),
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
          height: 110,
          width: MediaQuery.of(context).size.width * 0.80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: SvgPicture.asset(
                      AppIcons.svg.goBack,
                      colorFilter: AppColors.svg(Colors.black),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Text(
                      "${loadDetails.loadId}",
                      style: TextStyle(color: AppColors.textBlackDetailColor),
                    ),
                  ),

                  if (state.loadStatus==LoadStatus.accepted) Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      DateTimeHelper.formatCustomDate(
                        loadDetails.createdAt ?? DateTime.now(),
                      ),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),

                  if (!(state.loadStatus==LoadStatus.accepted)) ...[
                    Spacer(),

                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        child: SvgPicture.asset(
                          height: 24,
                          width: 24,
                          AppIcons.svg.share,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLocationDetailsTileWidget(
                    loadDetails.pickUpLocation,
                    DateTimeHelper.getFormattedDate(
                      loadDetails.pickUpDateTime ?? DateTime.now(),
                    ),
                  ),
                  Icon(Icons.arrow_forward).expand(),
                  _buildLocationDetailsTileWidget(
                    loadDetails.dropLocation,
                    DateTimeHelper.getFormattedDate(
                      loadDetails.expectedDeliveryDateTime ?? DateTime.now(),
                    ),
                  ),
                  if (state.loadStatus==LoadStatus.accepted)
                    LoadStatusLabel(statusType: "Confirmed"),
                ],
              ).paddingSymmetric(horizontal: 5),
            ],
          ),
        );
      },
    );
  }

  /// Google Map
  Widget buildGoogleMapWidget() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(13.0843, 80.2705),
        zoom: 10,
      ),
      onMapCreated: (controller) async {
        _mapController = controller;
        await _setMapStyle(controller);
      },
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      myLocationButtonEnabled: false,
      onCameraMove: (position) {},
      // markers: ,
      zoomControlsEnabled: false,
    );
  }

  /// Location Details
  _buildLocationDetailsTileWidget(String? location, String? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location ?? "",
          style: TextStyle(color: AppColors.black, fontSize: 16),
          maxLines: 1,
        ),
        Text(date ?? "", style: TextStyle(color: AppColors.grayColor)),
      ],
    ).expand();
  }
}
