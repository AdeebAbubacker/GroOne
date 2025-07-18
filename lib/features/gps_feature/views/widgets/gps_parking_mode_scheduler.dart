import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class GpsParkingModeScheduler extends StatefulWidget {
  const GpsParkingModeScheduler({super.key});

  @override
  State<GpsParkingModeScheduler> createState() =>
      _GpsParkingModeSchedulerState();
}

class _GpsParkingModeSchedulerState extends State<GpsParkingModeScheduler> {
  bool scheduleActive = true;
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  String selectedDay = 'Tue';

  TimeOfDay startTime = const TimeOfDay(hour: 20, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 20, minute: 0);
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Parking Mode Scheduler', style: AppTextStyle.h5PrimaryColor),
          8.height,
          Text(
            'The Parking Mode Scheduler will automatically activate the parking mode on the selected days of the week and between the selected time interval.',
            style: AppTextStyle.bodyGreyColor,
          ),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Schedule Active", style: AppTextStyle.h5,),
              Switch(
                value: scheduleActive,
                activeColor: Colors.white,
                activeTrackColor: AppColors.activeGreenColor,
                onChanged: (val) => setState(() => scheduleActive = val),
              ),
            ],
          ),
          15.height,
          Text('Days of Week', style: AppTextStyle.h5),
          10.height,
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children:
                days.map((day) {
                  final isSelected = selectedDay == day;
                  return ChoiceChip(
                    label: Text(
                      day,
                      style: AppTextStyle.h6.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    selected: isSelected,
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    showCheckmark: false,
                    onSelected: (_) => setState(() => selectedDay = day),
                  );
                }).toList(),
          ),

          15.height,
          Text('Time Range', style: AppTextStyle.h5),
          10.height,
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Start Time', style: AppTextStyle.h5),
                          30.height,
                          SizedBox(
                            height: 100,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: _startTime,
                              use24hFormat: false,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  _startTime = newTime;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('End Time', style: AppTextStyle.h5),
                          30.height,
                          SizedBox(
                            height: 100,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: _endTime,
                              use24hFormat: false,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  _endTime = newTime;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          40.height,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => Navigator.pop(context),
                  title: "Cancel",
                  style: AppButtonStyle.outline,
                ),
              ),
              10.width,
              Expanded(child: AppButton(onPressed: () {}, title: "Save")),
            ],
          ),
          20.height,
        ],
      ),
    );
  }

  Widget buildTimePickerTile(String label, TimeOfDay time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(time.format(context), style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
