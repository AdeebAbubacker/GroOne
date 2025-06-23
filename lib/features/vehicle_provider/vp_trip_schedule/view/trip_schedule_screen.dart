import 'package:flutter/material.dart';
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
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/validator.dart';

import '../../../../utils/app_dropdown.dart' show AppDropdown;

class TripScheduleScreen extends StatefulWidget {
  const TripScheduleScreen({super.key});

  @override
  State<TripScheduleScreen> createState() => _TripScheduleScreenState();
}

class _TripScheduleScreenState extends State<TripScheduleScreen> {
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
      child: Column(
        spacing: 20,
        children: [
          TripDetails(),

          AppDropdown(
            validator: (value) => Validator.fieldRequired(value),
            labelText: "Truck Number",
            hintText: "Select Truck Number",
            dropdownValue: "First",
            mandatoryStar: true,
            decoration: commonInputDecoration(fillColor: Colors.white),
            dropDownList: ["First","Second"].map((e) => DropdownMenuItem(
                value:e,
                child: Text(e, style: AppTextStyle.body)),
            ).toList(),
            onChanged: (onChangeValue) {

            },
          ),
          AppDropdown(
            validator: (value) => Validator.fieldRequired(value),
            labelText: "Driver Name  & Number",
            hintText: "Select Truck Number",
            dropdownValue: "First",
            mandatoryStar: true,
            decoration: commonInputDecoration(fillColor: Colors.white),
            dropDownList: ["First","Second"].map((e) => DropdownMenuItem(
                value:e,
                child: Text(e, style: AppTextStyle.body)),
            ).toList(),
            onChanged: (onChangeValue) {

            },
          ),
          ///Scheduled Pickup Date
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


                }

              },
              child: buildReadOnlyField("Scheduled Pickup Date","Scheduled Pickup Date", fillColor: Colors.white)
          ),

          ///Expected Delivery date

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


                }

              },
              child: buildReadOnlyField("Expected Delivery date","Expected Pickup Date", fillColor: Colors.white)
          ),

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


                }

              },
              child: buildReadOnlyField("Possible Delivery date","Possible Pickup Date", fillColor: Colors.white)
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
            onPressed: () {},

          ),
          10.height,


        ],
      ).paddingSymmetric(horizontal: 15),
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
