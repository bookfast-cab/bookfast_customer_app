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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 12,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top Drag Handle
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              /// Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isReturn ? "Select Return Time" : "Select Pickup Time",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 20, color: Colors.black54),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),

              /// TODAY / TOMORROW / FUTURE (Dates)
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: upcomingDates.length,
                  physics: const BouncingScrollPhysics(),
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade300,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.bfprimarythemeColor2.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              /// MODERN TIME PICKER
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _timeDropdownContainer(1, 12, hour, (v) => setState(() => hour = v)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        ":",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                    _timeDropdownContainer(0, 59, minute, (v) => setState(() => minute = v)),
                    const SizedBox(width: 20),
                    _amPmDropdownContainer(),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// CONFIRM BUTTON
              AppButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                onClick: () {
                  DateTime finalDateTime = getFinalDateTime();
                  DateTime now = DateTime.now();

                  if (!widget.isReturn && finalDateTime.isBefore(now)) {
                    AppCommonWidgets.showAppToast("Sorry, time cannot be in the past");
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
                title: "Confirm Selection",
                bgColor: AppColors.bfprimarythemeColor2,
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Styled Container for Hours and Minutes
  Widget _timeDropdownContainer(int min, int max, int value, Function(int) onChanged) {
    return Container(
      width: 75,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          icon: const SizedBox.shrink(), // Dropdown का डिफ़ॉल्ट Arrow छुपा दिया है
          dropdownColor: Colors.white,
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(16),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          items: List.generate(
            max - min + 1,
            (i) => DropdownMenuItem(
              value: min + i,
              alignment: Alignment.center,
              child: Text((min + i).toString().padLeft(2, '0')),
            ),
          ),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }

  /// Styled Container for AM / PM
  Widget _amPmDropdownContainer() {
    return Container(
      width: 70,
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.bfprimarythemeColor2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bfprimarythemeColor2.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: period,
          isExpanded: true,
          icon: const SizedBox.shrink(),
          dropdownColor: Colors.white,
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(16),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.bfprimarythemeColor2,
          ),
          items: const [
            DropdownMenuItem(value: "AM", alignment: Alignment.center, child: Text("AM")),
            DropdownMenuItem(value: "PM", alignment: Alignment.center, child: Text("PM")),
          ],
          onChanged: (v) => setState(() => period = v!),
        ),
      ),
    );
  }
}