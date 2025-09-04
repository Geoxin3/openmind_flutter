import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Schedule_functions.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:provider/provider.dart';

class ScheduleMyTime extends StatefulWidget {
  const ScheduleMyTime({super.key});

  @override
  State<ScheduleMyTime> createState() => _ScheduleMyTimeState();
}

class _ScheduleMyTimeState extends State<ScheduleMyTime> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  Future<void> _onRefresh() async {
    final mentorid = context.read<IdProviders>().mentorid;
    Provider.of<ScheduleFunctions>(context, listen: false).viewMySchedule(mentorid);
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleFunctions>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Manage Your Schedule",
          style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
        ),
        //backgroundColor: Colors.teal,
      ),
      body: scheduleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            onRefresh: _onRefresh,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Your Days & Time Slots",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
            
                    Expanded(
                      child: ListView.builder(
                        itemCount: scheduleProvider.daysOfWeek.length,
                        itemBuilder: (context, index) {
                          String day = scheduleProvider.daysOfWeek[index];
                          bool isSelected = scheduleProvider.selectedDays[day] ?? false;
            
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => scheduleProvider.toggleDaySelection(day),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.teal.withOpacity(0.15) : Colors.grey[100],
                                    border: Border.all(
                                      color: isSelected ? Colors.teal : Colors.grey.withOpacity(0.6),
                                      width: isSelected ? 2.5 : 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected ? Colors.teal[700] : Colors.black87,
                                        ),
                                      ),
                                      Icon(
                                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                                        color: isSelected ? Colors.teal : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
            
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, top: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: scheduleProvider.selectedTimeSlots[day]!
                                            .map((time) => GestureDetector(
                                                  onTap: () => scheduleProvider.removeTimeSlot(day, time),
                                                  child: Chip(
                                                    label: Text(time),
                                                    backgroundColor: Colors.teal.shade100,
                                                    deleteIcon: const Icon(Icons.close, size: 18, color: Colors.red),
                                                    onDeleted: () => scheduleProvider.removeTimeSlot(day, time),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                      const SizedBox(height: 6),
                                      TextButton.icon(
                                        onPressed: () => scheduleProvider.pickTime(context, day),
                                        icon: const Icon(Icons.add, color: Colors.teal),
                                        label: const Text(
                                          "Add Time Slot",
                                          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
            
                    // Save Button (More Visible)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final mentorid = context.read<IdProviders>().mentorid;
                            await scheduleProvider.updateSchedule(mentorid);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Updated button color
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4, // Slight shadow to make it stand out
                          ),
                          child: const Text(
                            "Save Schedule",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
