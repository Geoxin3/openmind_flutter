import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Get.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Post.dart'; // Import for POST request

class ScheduleFunctions with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<String> daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  Map<String, bool> selectedDays = {};
  Map<String, List<String>> selectedTimeSlots = {};

  ScheduleFunctions() {
    // Initialize empty state
    selectedDays = {for (var day in daysOfWeek) day: false};
    selectedTimeSlots = {for (var day in daysOfWeek) day: []};
  }

  //fetch Mentor's Schedule
  Future<void> viewMySchedule(int? mentorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final endpoint = 'mentors/view_my_schedule/$mentorId';
      final response = await ApiServicesMentorGet.getRequest(endpoint);

      if (response.containsKey('consultation_slots')) {
        Map<String, dynamic> slots = response['consultation_slots'];

        // Update selected days & time slots from API response
        selectedDays = {for (var day in daysOfWeek) day: slots.containsKey(day)};
        selectedTimeSlots = {for (var day in daysOfWeek) day: List<String>.from(slots[day] ?? [])};
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle a day's availability
  void toggleDaySelection(String day) {
    selectedDays[day] = !(selectedDays[day] ?? false);
    if (!selectedDays[day]!) selectedTimeSlots[day]?.clear();
    notifyListeners();
  }

  //add a time slot for a selected day
  Future<void> pickTime(BuildContext context, String day) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      String hour = (picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod).toString();
      String minute = picked.minute.toString().padLeft(2, '0');
      String period = picked.period == DayPeriod.am ? "AM" : "PM";
      String formattedTime = "$hour:$minute $period";

      selectedTimeSlots[day]?.add(formattedTime);
      notifyListeners();
    }
  }

  // Remove a time slot
  void removeTimeSlot(String day, String time) {
    selectedTimeSlots[day]?.remove(time);
    notifyListeners();
  }

  //update Mentor's Schedule API Call
  Future<void> updateSchedule(int? mentorId) async {

    _isLoading = true;
    notifyListeners();

    try {
      // Prepare data to send
      Map<String, dynamic> scheduleData = {
        "available_days": selectedDays.entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
        "consultation_slots": selectedTimeSlots,
      };

      print("Updating Schedule: $scheduleData");

      final endpoint = 'mentors/update_schedule/$mentorId/';
      final response = await ApiServicesMentorPost.postRequest(endpoint, scheduleData);

      if (response.containsKey('message')) {
        print(response['message']);
      } else {
        print("Failed to Update Schedule: ${response['error']}");
      }
    } catch (e) {
      print('Error updating schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
