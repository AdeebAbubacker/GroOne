import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:intl/intl.dart';

class TripSchedulingWidget extends StatefulWidget {
  const TripSchedulingWidget({super.key,required this.data,required this.onPressed});
  final VpLoadsList data;
  final Function() onPressed;
  @override
  State<TripSchedulingWidget> createState() => _TripSchedulingWidgetState();
}

class _TripSchedulingWidgetState extends State<TripSchedulingWidget> {
  final dateTextController = TextEditingController();
  String pickupEta = '';
  String deliveryDate = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: commonContainerDecoration(borderColor: AppColors.borderColor, borderWidth: 1),
          child: Column(
            children: [
              ListTile(
                  contentPadding: EdgeInsets.zero,

                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.data.pickUpAddr, style: AppTextStyle.h4w500),
                          Icon(Icons.arrow_right_alt_outlined, color: AppColors.primaryColor).paddingSymmetric(horizontal: 5),
                          Expanded(child: Text(widget.data.dropAddr, style: AppTextStyle.h4w500.copyWith(overflow: TextOverflow.ellipsis))),
                        ],
                      ),
                      Text("GD12456", style: AppTextStyle.body3GreyColor),
                    ],
                  ),

                  leading: Container(
                    decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor, borderRadius: BorderRadius.circular(100)),
                    child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
                  ),

                  trailing: SvgPicture.asset(AppIcons.svg.support)
              ),


              commonDivider(),

              Row(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.svg.deliveryTruckSpeed),
                      10.width,
                      Text(widget.data.truckType!.subType, style: AppTextStyle.body),
                    ],
                  ).expand(),
                  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")
                ],
              ),
              10.height,

              Row(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.svg.package),
                      10.width,
                      Text(widget.data.commodity!.name, style: AppTextStyle.body),
                    ],
                  ).expand(),
                  Text("${indianCurrencySymbol}1000", style: AppTextStyle.h4),
                ],
              ),
              20.height,
              Row(
                children: [
                  SvgPicture.asset(AppIcons.svg.package),
                  10.width,
                  Text("${widget.data.consignmentWeight} Tonn", style: AppTextStyle.body),
                ],
              ),
              20.height,
              commonDivider(),
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                  ), // Replace with your image
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Aman',
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
                        '+91 9834728349',
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

              child:  SvgPicture.asset(AppIcons.svg.tick),
            ),
          ],
        ),

        DateTimePickerField(
          label: "ETA of Pickup",
          value: pickupEta,
          icon: Icons.access_time,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
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
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
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
          label: "Expected Delivery date",
          value: deliveryDate,
          icon: Icons.calendar_today,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );

            if (!mounted || pickedDate == null) return;

            final formatted = DateFormat('dd-MM-yy').format(pickedDate);

            setState(() {
              deliveryDate = formatted;
            });
          },
        ),


        AppButton(
          onPressed: widget.onPressed,
          title: context.appText.continueText,
        )


      ],
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
