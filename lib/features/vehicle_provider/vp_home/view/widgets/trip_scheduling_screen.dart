import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/bloc/profile_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
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

class TripSchedulingScreen extends StatefulWidget {
  const TripSchedulingScreen({
    super.key,
    required this.data,
    required this.allProfileDetails,
  });

  final VpLoadsList data;
  final AllProfileDetails allProfileDetails;

  @override
  State<TripSchedulingScreen> createState() => _TripSchedulingScreenState();
}

class _TripSchedulingScreenState extends State<TripSchedulingScreen> {
  final lpHomeBloc = locator<LpHomeBloc>();
  final vpHomeScreenBloc = locator<VpHomeBloc>();
  final _formKey = GlobalKey<FormState>();
  VehicleListResponse? vehicleListResponse;
  DriverListResponse? driverListResponse;
  List<VehicleDetail> vehicleDetail = [];
  List<DriverDetails> driverDetails = [];
  DateTime? pickedDate;
  DateTime? deliveryDateTime;

  String pickupEta = '';
  String? truckType;
  String? driverType;
  String deliveryDate = '';

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

  void initFunction() => addPostFrameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? ""));
    vpHomeScreenBloc.add(
      VpVehicleListRequested(userId: lpHomeBloc.userId ?? ""),
    );
    vpHomeScreenBloc.add(
      VpDriverDetailsRequested(userId: lpHomeBloc.userId ?? ""),
    );
    //  Call your init methods
  });

  void disposeFunction() => addPostFrameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Trip Scheduling",
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(
          right: commonSafeAreaPadding,
          left: commonSafeAreaPadding,
          top: 20,
        ),
        bottom: false,
        child: _buildTripDetailWidget(),
      ),
    );
  }

  _buildTripDetailWidget() {
    return BlocConsumer(
      bloc: vpHomeScreenBloc,
      listener: (context, state) {
        if (state is VpVehicleListSuccess) {
          vehicleListResponse = state.vehicleListResponse;
        }
        if (state is ScheduleTripSuccess) {
          ToastMessages.success(message:"Trip Scheduled");
          context.pop();
        }
        if (state is VpDriverListSuccess) {
          driverListResponse = state.driverListResponse;
        }
        if (state is VpMyLoadListError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      builder: (context, state) {
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
                            Text(
                              widget.data.pickUpAddr,
                              style: AppTextStyle.h4w500,
                            ),
                            Icon(
                              Icons.arrow_right_alt_outlined,
                              color: AppColors.primaryColor,
                            ).paddingSymmetric(horizontal: 5),
                            Expanded(
                              child: Text(
                                widget.data.dropAddr,
                                style: AppTextStyle.h4w500.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text("GD12456", style: AppTextStyle.body3GreyColor),
                      ],
                    ),

                    leading: Container(
                      decoration: commonContainerDecoration(
                        color: AppColors.lightPrimaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: SvgPicture.asset(
                        AppIcons.svg.orderBox,
                      ).paddingAll(10),
                    ),

                    trailing: SvgPicture.asset(AppIcons.svg.support),
                  ),

                  commonDivider(),

                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.deliveryTruckSpeed),
                          10.width,
                          Text(
                            widget.data.truckType!.subType,
                            style: AppTextStyle.body,
                          ),
                        ],
                      ).expand(),
                      statusButtonWidget(
                        statusBackgroundColor: AppColors.boxGreen,
                        statusTextColor: AppColors.textGreen,
                        statusText: "Advance Paid",
                      ),
                    ],
                  ),
                  10.height,

                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.svg.package),
                          10.width,
                          Text(
                            widget.data.commodity!.name,
                            style: AppTextStyle.body,
                          ),
                        ],
                      ).expand(),
                      Text(
                        "${indianCurrencySymbol}1000",
                        style: AppTextStyle.h4,
                      ),
                    ],
                  ),
                  20.height,
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.svg.package),
                      10.width,
                      Text(
                        "${widget.data.consignmentWeight} Tonn",
                        style: AppTextStyle.body,
                      ),
                    ],
                  ),
                  20.height,
                  commonDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        commonCacheNetworkImage(
                          radius: 50,
                          height: 40,
                          width: 40,
                          path:
                              widget
                                  .allProfileDetails
                                  .details
                                  ?.profileImageUrl ??
                              "",
                          errorImage: AppImage.png.userProfileError,
                        ).paddingRight(commonSafeAreaPadding),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          widget
                                              .allProfileDetails
                                              .customer
                                              ?.customerName ??
                                          "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' (Gro Agent)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '+91 ${widget.allProfileDetails.customer?.mobileNumber}',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.height,

           Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 ///truck part
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Truck Number", style: AppTextStyle.textBlackColor16w400),
                     Icon(Icons.add, size: 20),
                   ],
                 ),
                 10.height,
                 AppDropdown(
                   validator:
                       (value) => Validator.fieldRequired(
                     value,
                     fieldName: "Truck Number Required*",
                   ),
                   //  labelText: "Company Type",
                   labelTextStyle: AppTextStyle.textBlackColor18w400,
                   hintText: "Truck Number",
                   dropdownValue: truckType,
                   decoration: commonInputDecoration(fillColor: Colors.white),
                   dropDownList:
                   vehicleDetail
                       .map(
                         (e) => DropdownMenuItem(
                       value: e.id.toString(),
                       child: Text(
                         e.vehicleNumber,
                         style: AppTextStyle.body,
                       ),
                     ),
                   )
                       .toList(),
                   onChanged: (onChangeValue) {
                     truckType = onChangeValue;
                     setState(() {});
                   },
                 ),

                 ///Driver part
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       "Driver Name  & Number",
                       style: AppTextStyle.textBlackColor16w400,
                     ),
                     Icon(Icons.add, size: 20),
                   ],
                 ),
                 10.height,
                 AppDropdown(
                   validator:
                       (value) => Validator.fieldRequired(
                     value,
                     fieldName: "Driver Required*",
                   ),
                   //  labelText: "Company Type",
                   labelTextStyle: AppTextStyle.textBlackColor18w400,
                   hintText: "Driver Required*",
                   dropdownValue: driverType,
                   decoration: commonInputDecoration(fillColor: Colors.white),
                   dropDownList:
                   driverDetails
                       .map(
                         (e) => DropdownMenuItem(
                       value: e.id.toString(),
                       child: Text(e.name, style: AppTextStyle.body),
                     ),
                   )
                       .toList(),
                   onChanged: (onChangeValue) {
                     driverType = onChangeValue;
                     setState(() {});
                   },
                 ),
               ],
             ),
           ),

            20.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "RC Copy of Vehicle",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(4),

                  child: SvgPicture.asset(AppIcons.svg.tick),
                ),
              ],
            ),

            DateTimePickerField(
              label: "ETA of Pickup",
              value: pickupEta,
              icon: Icons.access_time,
              onTap: () async {
                pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (!mounted || pickedDate == null) return;

                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (!mounted || pickedTime == null) return;

                final dt = DateTime(
                  pickedDate!.year,
                  pickedDate!.month,
                  pickedDate!.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                final formatted =
                    "${DateFormat('dd-MM-yy').format(dt)} | ${DateFormat('h.mm a').format(dt)}";

                setState(() {
                  pickupEta = formatted;
                });
              },
            ),

            20.height,
            DateTimePickerField(
              label: "Expected Delivery date",
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
            20.height,
            AppButton(
              style:pickedDate!=null &&  deliveryDateTime!=null?AppButtonStyle.primary:AppButtonStyle.disableButton,
              onPressed: () {

                if(pickedDate!=null &&  deliveryDateTime!=null){
                  if(_formKey.currentState!.validate()){
                    vpHomeScreenBloc.add(
                      ScheduleTripRequested(
                        apiRequest: ScheduleTripRequest(
                          vehicleId: int.parse(truckType ?? "0"),
                          driverId: int.parse(driverType ?? "0"),
                          acceptedBy:
                          widget.allProfileDetails.customer?.customerName ?? "",
                          etaForPickUp: pickedDate,
                          expectedDeliveryDate: deliveryDateTime,
                        ),
                      ),
                    );
                  }

                }else{
                  ToastMessages.error(message: "Please Select Dates!!!");
                }

              },
              title: context.appText.continueText,
            ),
          ],
        ).paddingSymmetric(
          horizontal: commonSafeAreaPadding,
          vertical: commonSafeAreaPadding,
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
        Text(label, style: AppTextStyle.black13w700),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: commonContainerDecoration(
              color: AppColors.lightPrimaryColor2,
              borderColor: AppColors.borderColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? "Select" : value,
                    style: AppTextStyle.body,
                  ),
                ),
                Icon(icon, size: 20, color: AppColors.primaryIconColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}