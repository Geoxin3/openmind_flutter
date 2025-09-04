import 'package:flutter/material.dart';

class TimeRangePicker extends StatefulWidget {
  const TimeRangePicker({super.key});

  @override
  TimeRangePickerState createState() => TimeRangePickerState();
}

class TimeRangePickerState extends State<TimeRangePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  bool isValid() {
    if (startTime == null || endTime == null) {
      return false;
    }
    return startTime!.hour < endTime!.hour || (startTime!.hour == endTime!.hour && startTime!.minute < endTime!.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            final TimeOfDay? selectedStartTime = await showTimePicker(
              context: context,
              initialTime: startTime ?? TimeOfDay.now(),
            );
            if (selectedStartTime != null) {
              setState(() {
                startTime = selectedStartTime;
              });
            }
          },
          child: Text(startTime == null ? "Select Start Time" : startTime!.format(context)),
        ),
        TextButton(
          onPressed: () async {
            final TimeOfDay? selectedEndTime = await showTimePicker(
              context: context,
              initialTime: endTime ?? TimeOfDay.now(),
            );
            if (selectedEndTime != null) {
              setState(() {
                endTime = selectedEndTime;
              });
            }
          },
          child: Text(endTime == null ? "Select End Time" : endTime!.format(context)),
        ),
      ],
    );
  }
}
