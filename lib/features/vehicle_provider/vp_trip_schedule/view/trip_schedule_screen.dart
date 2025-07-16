import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
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
  final String? loadId;
  const TripScheduleScreen({super.key,this.loadId});

  @override
  State<TripScheduleScreen> createState() => _TripScheduleScreenState();
}

class _TripScheduleScreenState extends State<TripScheduleScreen> {

  List<VehicleDetail> vehicleDetail = [];
  List<DriverDetails> driverDetails = [];
  final vpHomeScreenBloc = locator<VpHomeBloc>();
  final cubit = locator<LoadDetailsCubit>();
  final lpHomeCubit = locator<LPHomeCubit>();

  String? truckType;
  String? driverType;


  String? possibleDeliveryDate;


  @override
  void initState() {
    initFunction();
    super.initState();
  }


  void clearValues()=> frameCallback((){
    cubit.resetTripScheduleUIState();
  });


  void initFunction() => frameCallback(() async {
    cubit.resetState();
    String? userId= await vpHomeScreenBloc.getUserId()??"0";

    vpHomeScreenBloc.add(
      VpVehicleListRequested(userId:userId.toString() ),
    );
    vpHomeScreenBloc.add(
      VpDriverDetailsRequested( userId:userId.toString() ??"" ),
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
            if(vehicleDetail.isEmpty){
              setState(() {
                vehicleDetail = state.vehicleListResponse.data;
              });
            }
          }
          if (state is VpDriverListSuccess) {
           if(driverDetails.isEmpty){
            setState(() {
              driverDetails = state.driverListResponse.data;
            });
          }
          }
        },
        child: BlocBuilder<LoadDetailsCubit,LoadDetailsState>(
              bloc:cubit,
              builder: (context, state)  {
                LoadDetailModelData? loadDetails=state.loadDetailsUIState?.data?.data;
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
                      child: Text(e.truckNumber, style: AppTextStyle.body),
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
                  buildReadOnlyField("Scheduled Pickup Date",DateTimeHelper.formatCustomDate(loadDetails?.pickUpDateTime??DateTime.now()), fillColor: Color(0xffEBEBEB)),

                  ///Expected Delivery date

                  buildReadOnlyField("Expected Delivery date",DateTimeHelper.formatCustomDate(loadDetails?.expectedDeliveryDateTime??DateTime.now()), fillColor: Color(0xffEBEBEB)),

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
                          possibleDeliveryDate =  DateTimeHelper.convertToApiDateTime(date, time);
                        }
                        },
                      child: buildReadOnlyField("Possible Delivery date", state.possibleDeliveryDate ?? "Possible Pickup Date", fillColor: Colors.white)
                  ),

                  BlocConsumer<LoadDetailsCubit, LoadDetailsState>(
                    listener: (context, state) {
                      if(state.scheduleTripResponse?.status==Status.SUCCESS){
                        cubit.acceptLoad(4);
                      }

                    },
                    builder: (context, state) {
                      return AppButton(
                        isLoading: state.scheduleTripResponse?.status==Status.LOADING,
                        title: "Schedule trip",
                        style: AppButtonStyle.primary.copyWith(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          String? userId=await vpHomeScreenBloc.getUserId();
                          cubit.scheduleTripApi(ScheduleTripRequest(
                            loadId: loadDetails?.loadId ?? "",
                            expectedDeliveryDate: loadDetails?.expectedDeliveryDateTime?.toString(),
                            vehicleId: truckType,
                            driverId: driverType ?? "0",
                            acceptedBy: userId??"",
                            etaForPickUp: (loadDetails?.pickUpDateTime.toString()??DateTime.now()).toString(),
                            possibleDeliveryDate:possibleDeliveryDate,
                          ),);
                          },
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
