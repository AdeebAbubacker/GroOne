import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart' hide Customer;
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';

import '../bloc/vp_home_bloc/vp_home_bloc.dart';

class TripSchedulingScreen extends StatefulWidget {
  final VpLoadsList data;
  final Customer allProfileDetails;
  const TripSchedulingScreen({super.key, required this.data, required this.allProfileDetails});

  @override
  State<TripSchedulingScreen> createState() => _TripSchedulingScreenState();
}

class _TripSchedulingScreenState extends BaseState<TripSchedulingScreen> {


  final lpHomeBloc = locator<LpHomeBloc>();
  final vpHomeScreenBloc = locator<VpHomeBloc>();
  final _formKey = GlobalKey<FormState>();


  List<VehicleDetail> vehicleDetail = [];
  List<DriverDetails> driverDetails = [];

  DateTime? pickedDate;
  DateTime? deliveryDateTime;

  String pickupEta = '';
  String deliveryDate = '';

  String? truckType;
  String? driverType;

  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? ""));
    vpHomeScreenBloc.add(
      VpVehicleListRequested(userId: lpHomeBloc.userId ?? ""),
    );
    vpHomeScreenBloc.add(
      VpDriverDetailsRequested(userId: lpHomeBloc.userId ?? ""),
    );
    //  Call your init methods
  });

  void disposeFunction() => frameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Trip Scheduling", scrolledUnderElevation: 0.0),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.only(right: commonSafeAreaPadding, left: commonSafeAreaPadding, top: 20),
          child: _buildTripDetailWidget(buildContext: context),
        ),
      ),
    );
  }

  _buildTripDetailWidget({required BuildContext buildContext}) {
    return BlocConsumer(
      bloc: vpHomeScreenBloc,
      listener: (context, state) {
        if (state is VpVehicleListSuccess) {
          vehicleDetail = state.vehicleListResponse.data;

        }
        if (state is ScheduleTripSuccess) {
          ToastMessages.success(message:"Trip Scheduled");


          // if (Navigator.canPop(buildContext)) {
          //   Future.delayed(const Duration(seconds: 1),(){
          //     Navigator.pop(buildContext);
          //   });
          //
          // }

        }
        if (state is VpDriverListSuccess) {
          driverDetails = state.driverListResponse.data;
        }
        if (state is VpMyLoadListError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      builder: (context, state) {
        bool isLoading=state is ScheduleTripLoading;
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: commonContainerDecoration(
                borderColor: AppColors.borderColor,
                borderWidth: 1,
              ),
              child: Column(
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(widget.data.pickUpAddr, style: AppTextStyle.h5w500, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left).expand(),
                              Icon(Icons.arrow_right_alt_outlined, color: AppColors.primaryColor).paddingSymmetric(horizontal: 5),
                              Text(widget.data.dropAddr, style: AppTextStyle.h5w500, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right).expand(),
                            ],
                          ),
                          Text(widget.data.rate, style: AppTextStyle.body3GreyColor),
                        ],
                      ),

                      leading: Container(
                        decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor, borderRadius: BorderRadius.circular(100)),
                        child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
                      ),

                      trailing: SvgPicture.asset(AppIcons.svg.call)
                  ),


                  commonDivider(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        children: [

                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.svg.deliveryTruckSpeed),
                              10.width,
                              if(widget.data.truckType != null)
                                Text("${widget.data.truckType!.subType} ${widget.data.truckType!.type}", style: AppTextStyle.body),
                            ],
                          ),
                          10.height,

                          if(widget.data.commodity != null)...[
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.svg.package),
                                10.width,
                                Text(widget.data.commodity!.name, style: AppTextStyle.body),
                              ],
                            ),
                            10.height,
                          ],


                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(AppIcons.svg.kgWeight, width: 18, colorFilter: AppColors.svg(AppColors.black)),
                              7.width,
                              Text("${widget.data.consignmentWeight} Ton", style: AppTextStyle.body),
                            ],
                          ),
                        ],
                      ).expand(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Advance Paid
                          // if (widget.data.)
                          statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid"),
                          10.height,

                          Text("$indianCurrencySymbol${widget.data.rate}", style: AppTextStyle.h5PrimaryColor),
                          3.height,

                          // Settled Price
                          Text(context.appText.settledPrice, style: AppTextStyle.body3),
                        ],
                      )
                    ],
                  ),


                  commonDivider(),

                  // Vehicle Provider
                  Row(
                    children: [
                      // Vehicle Provider Profile

                      // commonCacheNetworkImage(
                      //   radius: 100,
                      //   height: 40,
                      //   width: 40,
                      //   path: widget.allProfileDetails.details?.profileImageUrl ?? "",
                      //   errorImage: AppImage.png.userProfileError,
                      // ),
                      10.width,

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.allProfileDetails.customerName ?? "",
                                  style: AppTextStyle.h5w500,
                                ),
                                TextSpan(
                                  text: '  (Gro Agent)',
                                  style: AppTextStyle.body3GreyColor,
                                ),
                              ],
                            ),
                          ),
                          3.height,

                          Text('+91 ${widget.allProfileDetails.mobileNumber}', style: AppTextStyle.body),
                        ],
                      ).expand(),
                    ],
                  ),
                ],
              ),
            ),
            50.height,

           Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 //truck part
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Truck Number", style: AppTextStyle.textFiled),
                     Icon(Icons.add, size: 20),
                   ],
                 ),
                 6.height,

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
                 30.height,


                 // RC Copy of Vehicle
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Text(context.appText.rcCopyOfVehicle, style: AppTextStyle.body2),
                     10.width,
                     Icon(Icons.verified, color: AppColors.activeDarkGreenColor),
                   ],
                 ),
                 30.height,

                 //Driver part
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(context.appText.driverNameAndNumber, style: AppTextStyle.textFiled),
                     Icon(Icons.add, size: 20),
                   ],
                 ),
                 6.height,
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
               ],
             ),
           ),
            30.height,

            // RC Copy of Vehicle
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(context.appText.drivingLicense, style: AppTextStyle.body2),
                10.width,
                Icon(Icons.verified, color:  AppColors.activeDarkGreenColor),
              ],
            ),
            30.height,


            DateTimePickerField(
              label: context.appText.eTAOfPickup,
              value: pickupEta,
              icon: Icons.access_time,
              onTap: () async {

                pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (!context.mounted || pickedDate == null) return;

                final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                if (!mounted || pickedTime == null) return;

                final dt = DateTime(
                  pickedDate!.year,
                  pickedDate!.month,
                  pickedDate!.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                final formatted = "${DateFormat('dd-MM-yy').format(dt)} | ${DateFormat('h.mm a').format(dt)}";

                setState(() {
                  pickupEta = formatted;
                });
              },
            ),
            20.height,


            DateTimePickerField(
              label: context.appText.expectedDeliveryDate,
              value: deliveryDate,
              icon: Icons.calendar_today,
              onTap: () async {
                deliveryDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (!mounted || pickedDate == null) return;

                final formatted = DateFormat(
                  'dd-MM-yy',
                ).format(deliveryDateTime!);

                setState(() {
                  deliveryDate = formatted;
                });
              },
            ),
            50.height,


            AppButton(
              title: context.appText.scheduleTrip,
              isLoading:isLoading,
              style: (pickedDate !=null &&  deliveryDateTime !=null ) ? AppButtonStyle.primary : AppButtonStyle.disableButton,
              onPressed: () {
                if(pickedDate!=null &&  deliveryDateTime!=null){

                }else{
                  ToastMessages.error(message: "Please Select Dates!!!");
                }
              },
            ),
            20.height,
          ],
        );
      },
    );
  }
}


class DateTimePickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const DateTimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textFiled),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: commonContainerDecoration(
              color: Colors.white,
              borderColor: AppColors.borderColor,
              borderRadius: BorderRadius.circular(commonTexFieldRadius)
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? "Select" : value,
                    style: AppTextStyle.body,
                  ),
                ),
                Icon(icon, size: 20, color: AppColors.iconColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}