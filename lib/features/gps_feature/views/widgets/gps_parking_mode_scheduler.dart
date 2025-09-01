import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_parking_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../data/model/result.dart';
import '../../cubit/gps_parking_mode_cubit/gps_parking_mode_cubit.dart';


class GpsParkingModeScheduler extends StatefulWidget {
  final GpsParkingModeModel gpsParkingModeModel;

  const GpsParkingModeScheduler({super.key, required this.gpsParkingModeModel});

  @override
  State<GpsParkingModeScheduler> createState() =>
      _GpsParkingModeSchedulerState();
}

class _GpsParkingModeSchedulerState extends State<GpsParkingModeScheduler> {
  bool scheduleActive = true;
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // String selectedDay = 'Tue';
  List<String> selectedDays = [];

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
          Text(context.appText.parkingModeSchedulerTitle, style: AppTextStyle.h5PrimaryColor),
          8.height,
          Text(
            context.appText.parkingModeSchedulerDescription,
            style: AppTextStyle.bodyGreyColor,
          ),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.appText.scheduleActive, style: AppTextStyle.h5),
              Switch(
                value: scheduleActive,
                activeColor: Colors.white,
                activeTrackColor: AppColors.activeGreenColor,
                onChanged: (val) => setState(() => scheduleActive = val),
              ),
            ],
          ),
          15.height,
          Text(context.appText.daysOfWeek, style: AppTextStyle.h5),
          10.height,
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children:
                days.map((day) {
                  final isSelected = selectedDays.contains(day);
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
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedDays.remove(day);
                        } else {
                          selectedDays.add(day);
                        }
                      });
                    },
                  );
                }).toList(),
          ),

          15.height,
          Text(context.appText.timeRange, style: AppTextStyle.h5),
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
                          Text(context.appText.startTime, style: AppTextStyle.h5),
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
                          Text(context.appText.endTime, style: AppTextStyle.h5),
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
                  title: context.appText.cancel,
                  style: AppButtonStyle.outline,
                ),
              ),
              10.width,
              Expanded(
                child: AppButton(
                  onPressed: () async {
                    // Time validation
                    if (_startTime.isAfter(_endTime) || _startTime.isAtSameMomentAs(_endTime)) {
                      ToastMessages.error(message: context.appText.errorInvalidTime);
                      return;
                    }

                    final cubit = context.read<GpsParkingModeCubit>();
                    final result = await cubit.updateParkingSchedule(
                      id: widget.gpsParkingModeModel.id,
                      deviceId: widget.gpsParkingModeModel.deviceId,
                      parkingSchedule: scheduleActive,
                      parkingScheduleStartUtc: _formatTimeUtc(_startTime),
                      parkingScheduleEndUtc: _formatTimeUtc(_endTime),
                      parkingScheduleDays: selectedDays,
                    );
                    if (!context.mounted) return;
                    if (result is Success) {
                      Navigator.pop(context);
                      ToastMessages.success(
                        message: context.appText.successScheduleUpdated,
                      );
                    } else if (result is Error) {
                      final message = result.type.getText(context);
                      ToastMessages.error(message: message);
                    }
                  },
                  title: context.appText.save,
                ),
              ),
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

String _formatTimeUtc(DateTime time) {
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
