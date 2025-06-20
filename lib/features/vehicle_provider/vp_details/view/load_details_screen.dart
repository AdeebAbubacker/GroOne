import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/assign_driver_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/assign_driver_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_details_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/load_status_label.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../utils/app_icons.dart';

class LoadDetailsScreen extends StatefulWidget {
  const LoadDetailsScreen({super.key});

  @override
  State<LoadDetailsScreen> createState() => _LoadDetailsScreenState();
}

class _LoadDetailsScreenState extends State<LoadDetailsScreen> {
  final cubit = locator<AssignDriverCubit>();

  GoogleMapController? _mapController;

  /// Map Style
  Future<void> _setMapStyle(GoogleMapController controller) async {
    String style = await rootBundle.loadString(AppJSON.mapStyle);
    controller.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: LoadDetailsWidget(cubit: cubit),


        body: Stack(
          children: [
            Positioned.fill(child: buildGoogleMapWidget()),
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: buildSourceAndDestinationWidget(),
            ),

          ],
        ),
      ),
    );
  }

  /// Build Source And Destination
  Widget buildSourceAndDestinationWidget() {
    return BlocBuilder<AssignDriverCubit, AssignDriverState>(
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
                    child: Text("#GRO22334",style: TextStyle(color: AppColors.textBlackDetailColor),),
                  ),

                  if(state.isLoadAccepted)
                    Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(top: 15,left: 10,right: 10),
                    child: Text("12 Jul 2025, 6.30 AM",style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryColor,
                    ),),
                  ),


                  if (!state.isLoadAccepted) ...[
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
                  _buildLocationDetailsTileWidget("Bangalore", "21-09-2025"),
                  Icon(Icons.arrow_forward),
                  _buildLocationDetailsTileWidget("Chennai", "21-09-2025"),
                  if(state.isLoadAccepted)
                    LoadStatusLabel(statusType: "Confirmed",)

                ],
              ),
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
      children: [
        Text(
          location ?? "",
          style: TextStyle(color: AppColors.black, fontSize: 16),
        ),
        Text(date ?? "", style: TextStyle(color: AppColors.grayColor)),
      ],
    );
  }
}
