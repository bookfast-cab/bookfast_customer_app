import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../ui/widgets/app_button_widget.dart';
import '../ui/widgets/app_common_widgets.dart';
import 'app_colors.dart';

class CustomDateTimePicker extends StatefulWidget {
  final bool isReturn;
  final DateTime? onwardDateTime;
  final Function(DateTime) onConfirm;

  const CustomDateTimePicker({
    super.key,
    required this.isReturn,
    required this.onConfirm,
    this.onwardDateTime,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime selectedDate = DateTime.now();
  int hour = 9;
  int minute = 0;
  String period = "AM";

  List<DateTime> upcomingDates = List.generate(
    10,
    (i) => DateTime.now().add(Duration(days: i)),
  );

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();

    if (!widget.isReturn) {
      now = now.add(const Duration(minutes: 30));
    } else if (widget.onwardDateTime != null) {
      now = widget.onwardDateTime!.add(const Duration(hours: 1));
    }

    selectedDate = DateTime(now.year, now.month, now.day);
    hour = now.hour > 12 ? now.hour - 12 : now.hour;
    hour = hour == 0 ? 12 : hour;
    minute = now.minute;
    period = now.hour >= 12 ? "PM" : "AM";
  }

  DateTime getFinalDateTime() {
    int finalHour = hour % 12;
    if (period == "PM") finalHour += 12;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      finalHour,
      minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.isReturn ? "Select Return Time" : "Select Pickup Time",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close_rounded))
              ],
            ),

            const SizedBox(height: 12),

            /// TODAY / TOMORROW / FUTURE
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingDates.length,
                itemBuilder: (_, index) {
                  DateTime date = upcomingDates[index];
                  bool isSelected = date.day == selectedDate.day && date.month == selectedDate.month;

                  String label = index == 0
                      ? "Today"
                      : index == 1
                          ? "Tomorrow"
                          : DateFormat("dd MMM").format(date);

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedDate = date);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// TIME PICKER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _numberPicker(1, 12, hour, (v) => setState(() => hour = v)),
                const Text(" : "),
                _numberPicker(0, 59, minute, (v) => setState(() => minute = v)),
                const SizedBox(width: 12),
                _amPmPicker(),
              ],
            ),

            const SizedBox(height: 20),

            AppButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              onClick: () {
                DateTime finalDateTime = getFinalDateTime();
                DateTime now = DateTime.now();

                if (!widget.isReturn && finalDateTime.isBefore(now)) {
                  AppCommonWidgets.showAppToast("Sorry, time cannot be in past");
                  return;
                }

                if (widget.isReturn &&
                    widget.onwardDateTime != null &&
                    finalDateTime.isBefore(
                      widget.onwardDateTime!.add(const Duration(hours: 1)),
                    )) {
                  AppCommonWidgets.showAppToast("Return must be 1 hour after going");
                  return;
                }

                widget.onConfirm(finalDateTime);
                Navigator.pop(context);
              },
              title: "Confirm",
              bgColor: AppColors.bfPrimaryColor,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _numberPicker(int min, int max, int value, Function(int) onChanged) {
    return SizedBox(
      width: 60,
      child: DropdownButton<int>(
        value: value,
        isExpanded: true,
        items: List.generate(
          max - min + 1,
          (i) => DropdownMenuItem(
            value: min + i,
            child: Text(
              (min + i).toString().padLeft(2, '0'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget _amPmPicker() {
    return DropdownButton<String>(
      value: period,
      items: const [
        DropdownMenuItem(value: "AM", child: Text("AM")),
        DropdownMenuItem(value: "PM", child: Text("PM")),
      ],
      onChanged: (v) => setState(() => period = v!),
    );
  }
}
