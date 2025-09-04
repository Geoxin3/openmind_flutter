import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/Dilaogue_box.dart';
import 'package:openmind_flutter/Custom_Widgets/expandable_task_mentor.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Chat_related_functions.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Task_Assigning.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:provider/provider.dart';

class TaskDairy extends StatefulWidget {
  final Map<String, dynamic> user;

  const TaskDairy({super.key, required this.user});

  @override
  TaskDairyState createState() => TaskDairyState();
}

class TaskDairyState extends State<TaskDairy> {
  late TaskAssigning taskProvider;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void _fetchTasks() {
    taskProvider = Provider.of<TaskAssigning>(context, listen: false);
    final mentorid = context.read<IdProviders>().mentorid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskProvider.clean();
      taskProvider.getassignedTasks(widget.user['user_id'], mentorid, widget.user['request_id']);
    });
  }

  Future<void> _onRefresh() async {
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: Text("${widget.user['user_fullname']}'s Tasks", style:const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: Consumer<Chatservice>(
              builder: (context, chatService, child) {
                // Check if session is ended
                final isSessionEnded = widget.user['request_status'] == true;

                return ElevatedButton(
                  onPressed: isSessionEnded
                      ? null
                      : () {
                        //end session reusable
                          BoldDialog.show(
                            bgColor: Colors.white,
                            context,
                            title: 'End Session !',
                            content:
                                "Are you sure you want to end this session? Once it's done, there is no going back.",
                            icon: Icons.warning,
                            onSubmit: () async {
                              await taskProvider.completeSession(
                                widget.user['user_id'],
                                widget.user['mentor_id'],
                                widget.user['request_id'],
                              );
                                                            
                              // Update request_status in provider
                              context.read<Chatservice>().updateSessionStatus(
                                  widget.user['user_id'], widget.user['request_id'], true);

                              // Refresh accepted users
                              await context
                                  .read<Chatservice>()
                                  .getacceptedUsers(widget.user['mentor_id']);
                            },
                            onClose: () {},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          textStyle:const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        child: Row(
                        mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('End Session', style: TextStyle(color: isSessionEnded ? Colors.grey[400] :Colors.white),),
                            const SizedBox(width: 5),
                            Icon(Icons.exit_to_app_rounded, color: isSessionEnded ? Colors.grey[400] :Colors.white, size: 20),
                          ],
                        ),
                );
              },
            ),
          ),
        ],
      ),
      //show only if the user has made the payment
      body: widget.user['has_payment'] ?
      Consumer<TaskAssigning>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.assignedTasks.isEmpty
                  ? ListView(
                      children: [
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.9,  // Set height to 60% of the screen height
                            child: const Text(
                              "No entries yet",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: provider.assignedTasks.length,
                          itemBuilder: (context, index) {
                            final task = provider.assignedTasks[index];
                              return MentorTaskCard(
                                diaryId: task['id'],
                                userid: task['task__user_id'],
                                requestId: widget.user['request_id'],
                                title: task['task__title'],
                                description: task['task__description'],
                                date: task['created_at'],
                                emotions: task['emotions'],
                                diaryEntry: task['dairy'],
                                //pass the request status to the task card to 
                                //disable the buttons when session is ended
                                isSessionEnded: widget.user['request_status'],
                                //for tracking each task complete or not
                                isTaskComplete: task['task__completed'],
                              );
                            },
                          ),
              ),

              // Floating action button menu (disabled when session ended is true)
              if (!widget.user['request_status'])
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: provider.isMenuVisible
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                provider.toggleMenu();
                                _showDairyDialog(context);
                              },
                              child: _menuItem(
                                  Icons.edit, "New Dairy", Colors.green),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                provider.toggleMenu();
                                //
                              },
                              child: _menuItem(
                                  Icons.task, "New Task", Colors.yellow),
                            ),
                          ],
                        )
                      : Container(),
                ),

              // Floating button (disabled when request_status is true)
              if (!widget.user['request_status'])
                Positioned(
                  bottom: 20,
                  right: 30,
                  child: FloatingActionButton(
                    onPressed: () {
                      provider.toggleMenu();
                    },
                    backgroundColor: Colors.teal.shade400,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ) : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
                const SizedBox(height: 30,),
                Text(widget.user['user_fullname'] != null
                  ? '${widget.user['user_fullname'].split(' ')[0]} has not made the payment yet.'
                  : 'User has not made the payment yet.',
                  style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
            ),
    );
  }

  void _showDairyDialog(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: "Today's diary");
    TextEditingController descriptionController =
        TextEditingController(text: "Write about the day...");

    showDialog(
      context: context,
      builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title:const Row(
          children: [
            Icon(Icons.note_add, color: Colors.teal),
            SizedBox(width: 10),
            Text(
              "New Diary",
              style: TextStyle(fontWeight: FontWeight.w600,),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6,),
            const Text(
              "Title",
              style: TextStyle(fontWeight: FontWeight.w500,),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter diary title...",
                //filled: true,
                //fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  //borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.w500,),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write about the day...",
                //filled: true,
                //fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  //borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final provider = Provider.of<TaskAssigning>(context, listen: false);
              final mentorId = context.read<IdProviders>().mentorid;

              await provider.assignNewDairy(
                mentorId,
                widget.user['user_id'],
                titleController.text,
                descriptionController.text,
                widget.user['request_id'],
              );

                // Delay this until after current build frame finishes
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await provider.getassignedTasks(
                    widget.user['user_id'],
                    mentorId,
                    widget.user['request_id'],
                  );
                });

              Navigator.pop(context);
            },
            //icon: const Icon(Icons.check_circle_outline),
            label: const Text("Assign"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    });
  }

  Widget _menuItem(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
