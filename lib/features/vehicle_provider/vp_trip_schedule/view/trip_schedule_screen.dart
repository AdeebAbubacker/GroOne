import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/widgets/trip_details.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/validator.dart';

import '../../../../utils/app_dropdown.dart' show AppDropdown;

class TripScheduleScreen extends StatefulWidget {
  const TripScheduleScreen({super.key});

  @override
  State<TripScheduleScreen> createState() => _TripScheduleScreenState();
}

class _TripScheduleScreenState extends State<TripScheduleScreen> {

  final cubit = locator<LoadDetailsCubit>();

  List<VehicleDetail> vehicleDetail = [];
  List<DriverDetails> driverDetails = [];
  final vpHomeScreenBloc = locator<VpHomeBloc>();

  String? truckType;
  String? driverType;

  @override
  void initState() {
    initFunction();
    super.initState();
  }


  void initFunction() => frameCallback(() async {
    vpHomeScreenBloc.add(
      VpVehicleListRequested(userId:cubit.state.loadDetailsUIState?.data?.data?.customerId.toString() ??"" ),
    );
    vpHomeScreenBloc.add(
      VpDriverDetailsRequested( userId:cubit.state.loadDetailsUIState?.data?.data?.customerId.toString() ??"" ),
    );
    //  Call your init methods
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(backgroundColor: AppColors.white, title: "Trip Scheduling"),
      body:_buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget(){
    return SingleChildScrollView(
      child: BlocListener(
        bloc: vpHomeScreenBloc,
        listener: (context, state) {
          if (state is VpVehicleListSuccess) {
            vehicleDetail = state.vehicleListResponse.data;

          }
          if (state is VpDriverListSuccess) {
            driverDetails = state.driverListResponse.data;
          }
        },
        child: BlocBuilder<LoadDetailsCubit,LoadDetailsState>(
              bloc:cubit,
              builder: (context, state)  {

              LoadDetails? loadDetails=state.loadDetailsUIState?.data?.data;
              print("state.possibleDeliveryDate ${state.possibleDeliveryDate}  ");
              return Column(
                spacing: 20,
                children: [
                  TripDetails(),

                  AppDropdown(
                    validator: (value) => Validator.fieldRequired(value, fieldName: "Truck Number Required*"),
                    labelTextStyle: AppTextStyle.textBlackColor18w400,
                    hintText: "Truck Number",
                    dropdownValue: truckType,
                    decoration: commonInputDecoration(fillColor: Colors.white),
                    dropDownList: vehicleDetail.map((e) => DropdownMenuItem(
                      value: e.id.toString(),
                      child: Text(e.vehicleNumber, style: AppTextStyle.body),
                    ),
                    ).toList(),
                    onChanged: (onChangeValue) {
                      truckType = onChangeValue;
                    },
                  ),
                  AppDropdown(
                    validator: (value) => Validator.fieldRequired(value),
                    labelTextStyle: AppTextStyle.textBlackColor18w400,
                    hintText: context.appText.selectDriver,
                    dropdownValue: driverType,
                    decoration: commonInputDecoration(fillColor: Colors.white),
                    dropDownList: driverDetails.map((e) => DropdownMenuItem(
                      value: e.id.toString(),
                      child: Text(e.name, style: AppTextStyle.body),
                    ),
                    ).toList(),
                    onChanged: (onChangeValue) {
                      driverType = onChangeValue;
                    },
                  ),
                  ///Scheduled Pickup Date
                  buildReadOnlyField(

                      "Scheduled Pickup Date",DateTimeHelper.formatCustomDate(loadDetails?.pickUpDateTime??DateTime.now()), fillColor: AppColors.disableColor),

                  ///Expected Delivery date

                  buildReadOnlyField("Expected Delivery date",DateTimeHelper.formatCustomDate(loadDetails?.expectedDeliveryDateTime??DateTime.now()), fillColor: AppColors.disableColor),

                  ///Possible Delivery date
                  InkWell(
                      onTap: () async {

                        final String? date = await commonDatePicker(
                          context,
                          firstDate: DateTime.now(),
                          initialDate: DateTimeHelper.convertToDateTimeWithCurrentTime( DateTime.now().toString()),
                        );

                        if(!context.mounted) return;
                        final String? time = await commonTimePicker(context);

                        if (date != null && time != null) {
                          cubit.updatePossibleDeliveryDateDate("$date, $time");
                        }

                      },
                      child: buildReadOnlyField("Possible Delivery date", state.possibleDeliveryDate ?? "Possible Pickup Date", fillColor: Colors.white)
                  ),

                  AppButton(
                    title: "Schedule trip",
                    style: AppButtonStyle.primary.copyWith(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      vpHomeScreenBloc.add(
                        ScheduleTripRequested(
                          apiRequest: ScheduleTripRequest(
                            loadId: loadDetails?.id??0,
                            vehicleId: int.parse(truckType ?? "0"),
                            driverId: int.parse(driverType ?? "0"),
                            acceptedBy: int.parse(vpHomeScreenBloc.userId??"0"),
                            etaForPickUp: DateTime.now(),
                            expectedDeliveryDate: DateTime.now(),

                          ),
                        ),
                      );
                    },

                  ),
                  10.height,


                ],
              ).paddingSymmetric(horizontal: 15);
            }

          )

      ),
    );
  }

  Widget buildReadOnlyField(String label, String value,{Color? fillColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textFiled),
        6.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: commonContainerDecoration(color: fillColor ?? AppColors.greyIconBackgroundColor, borderRadius: BorderRadius.circular(commonTexFieldRadius), borderColor: AppColors.borderDisableColor),
          child: Text(value, style: AppTextStyle.textFiled),
        ),
      ],
    );
  }

}
