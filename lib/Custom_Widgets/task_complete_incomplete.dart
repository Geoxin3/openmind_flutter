import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Task_Assigning.dart';

class TaskStatusToggle extends StatelessWidget {
  final int? diaryId;
  final bool isTaskcomplete;
  final bool isMentor; // Determines if the user is a mentor or not
  final bool? isSessionEnded;

  const TaskStatusToggle({
    super.key,
    required this.diaryId,
    required this.isTaskcomplete,
    required this.isMentor, // Pass true for mentor, false for user
    this.isSessionEnded
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskAssigning>(context, listen: false);

    // Ensure initial state is stored only for mentors
    if (isMentor) {
      provider.setInitialStatus(diaryId, isTaskcomplete);
    }

    return Consumer<TaskAssigning>(
      builder: (context, provider, child) {
        final bool isComplete = provider.taskCompletionStatus[diaryId] ?? isTaskcomplete;

        return GestureDetector(
          onTap: (isMentor && !(isSessionEnded ?? false))
              ? () {
                  if (diaryId == null) return;
                  final bool newStatus = !isComplete;

                  provider.toggleTaskStatus(diaryId); // Update state locally
                  provider.taskComplete(newStatus, diaryId); // Sync with backend
                }
              : null, // Disable interaction for users
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isComplete ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isComplete ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  isComplete ? "Complete" : "Incomplete",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
