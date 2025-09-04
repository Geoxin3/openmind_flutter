import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/task_complete_incomplete.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:openmind_flutter/User/State_Provider_User/Assigned_Tasks.dart';
import 'package:provider/provider.dart';

class ExpandableTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String? dairyEntry;
  final int taskId;
  final bool isSessionEnded;
  final bool isTaskComplete;

  const ExpandableTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.dairyEntry,
    required this.taskId,
    required this.isSessionEnded,
    required this.isTaskComplete,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssignedTasks>(context);
    final bool isExpanded = provider.isExpanded(taskId);
    final TextEditingController dairyController = provider.getDairyController(taskId, dairyEntry);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            provider.toggleTask(taskId);
          },
          child: Card(
            elevation: 2.6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title, Desc, Date, Toggle Icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Assigned on: ${TimeFormat.formatDate(date)}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade600,
                        size: 28,
                      ),
                    ],
                  ),

                  // Expanded Details
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Diary Entry
                          const Row(
                            children: [
                              Text(
                                'Diary Entry',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.edit_document, color: Colors.teal, size: 25),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade50,
                            ),
                            child: TextField(
                              controller: dairyController,
                              maxLines: null,
                              style: const TextStyle(fontSize: 16, height: 1.6),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: (isTaskComplete || isSessionEnded)
                                    ? 'You cannot write dairy'
                                    : 'Write your dairy...',
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                              ),
                              enabled: !(isTaskComplete || isSessionEnded),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Task Status
                          TaskStatusToggle(diaryId: taskId, isTaskcomplete: isTaskComplete, isMentor: false),
                          const SizedBox(height: 12),

                          // Submit Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: isTaskComplete || isSessionEnded
                                    ? null
                                    : () async {
                                        provider.submitDairy(dairyController.text, taskId);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Diary Submitted!')),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                                child: const Icon(Icons.send, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
