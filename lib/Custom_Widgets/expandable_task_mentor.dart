import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/emotion_bar.dart';
import 'package:openmind_flutter/Custom_Widgets/task_complete_incomplete.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Task_Assigning.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:provider/provider.dart';

class MentorTaskCard extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final Map<String, dynamic>? emotions;
  final String? diaryEntry;
  final int requestId;
  final int? diaryId;
  final int? userid;
  final bool isSessionEnded;
  final bool isTaskComplete;

  const MentorTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.emotions,
    this.diaryEntry,
    required this.requestId,
    required this.diaryId,
    this.userid,
    required this.isSessionEnded,
    required this.isTaskComplete,
  });

  @override
  MentorTaskCardState createState() => MentorTaskCardState();
}

class MentorTaskCardState extends State<MentorTaskCard> {
  @override
  Widget build(BuildContext context) {
    //changed the listen false the widget need to list for the changes in the provider and default is true 
    final provider = Provider.of<TaskAssigning>(context); //default is true 

    Widget taskCard = GestureDetector(
      onTap: () {
        provider.delayedToggleTaskExpansion(widget.diaryId);
      },
      child: Card(
        //margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        elevation: 2.6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header: Title, Desc, Date, Toggle Icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          "Assigned on: ${TimeFormat.formatDate(widget.date)}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            //fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    provider.taskExpansionState[widget.diaryId] ?? false
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade600,
                    size: 28,
                  ),
                ],
              ),

              /// Expanded Details
              if (provider.taskExpansionState[widget.diaryId] ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Diary Entry
                      const Row(
                        children: [
                          Text(
                            'Diary Entry',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 5,),
                          Icon(Icons.edit_document, color: Colors.teal, size: 25,)
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
                        child: Text(
                          widget.diaryEntry ?? "No entry yet...",
                          style: const TextStyle(fontSize: 16, height: 1.6),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// Emotion Analysis Section
                      const Row(
                        children: [
                          Text(
                            'Emotions Analysis',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 5,),
                          Icon(Icons.psychology, color: Colors.blue, size: 30,)
                        ],
                      ),
                      const SizedBox(height: 8),

                      provider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : (widget.emotions != null &&
                                  widget.emotions!.containsKey('emotion_summary') &&
                                  widget.emotions!['emotion_summary'] is Map<String, dynamic>)
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget.emotions!['emotion_summary']
                                      .entries
                                      .where((entry) => (entry.value as num) >= 0.0001)
                                      .length,
                                  itemBuilder: (context, index) {
                                    final filteredEmotions = widget.emotions!['emotion_summary']
                                        .entries
                                        .where((entry) => (entry.value as num) >= 0.0001)
                                        .toList()
                                      ..sort((a, b) => (b.value as num).compareTo(a.value as num));

                                    String key = filteredEmotions[index].key;
                                    double value = (filteredEmotions[index].value as num) * 100;

                                    return EmotionProgressBar(label: key, percentage: value);
                                  },
                                )
                              : const Text(
                                  "No emotions detected yet",
                                  style: TextStyle(fontSize: 15, color: Colors.grey),
                                ),

                      const SizedBox(height: 20),

                      /// Task Toggle + Analyze Button
                      if (widget.diaryEntry != null)
                        Row(
                          children: [
                            TaskStatusToggle(
                              diaryId: widget.diaryId,
                              isTaskcomplete: widget.isTaskComplete,
                              isMentor: true,
                              isSessionEnded: widget.isSessionEnded,
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: widget.isSessionEnded
                                  ? null
                                  : () async {
                                      if (widget.diaryId != null) {
                                        final mentorid = context.read<IdProviders>().mentorid;
                                        await provider.analyseEmotion(widget.diaryId);
                                        await provider.getassignedTasks(
                                            widget.userid, mentorid, widget.requestId);
                                      }
                                    },
                              icon: const Icon(Icons.psychology, size: 18, color: Colors.white,),
                              label: provider.isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    )
                                  : const Text('Emotion Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                textStyle: const TextStyle(fontSize: 14),
                                backgroundColor:
                                    widget.isSessionEnded ? Colors.grey : Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
    );

    // Wrap with Dismissible only if session is **not** ended
    return widget.isSessionEnded
        ? taskCard
        : Dismissible(
            key: Key(widget.diaryId.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Delete Task"),
                    content: const Text("Are you sure you want to delete this task?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                          final mentorid = context.read<IdProviders>().mentorid;
                          await provider.deleteTask(widget.diaryId!);
                          await provider.getassignedTasks(widget.userid, mentorid, widget.requestId);
                        },
                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            child: taskCard,
          );
  }
}
