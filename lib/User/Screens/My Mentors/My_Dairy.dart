import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/expandable_task_card.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/User/State_Provider_User/Assigned_Tasks.dart';
import 'package:provider/provider.dart';

class TaskDairyEntryPage extends StatefulWidget {
  final int? mentorid;
  final Map<String, dynamic> mentor;

  const TaskDairyEntryPage({super.key, this.mentorid, required this.mentor});

  @override
  TaskDairyEntryPageState createState() => TaskDairyEntryPageState();
}

class TaskDairyEntryPageState extends State<TaskDairyEntryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssignedTasks>(context, listen: false);
      final userid = context.read<IdProviders>().userid;
      provider.getassignedTasks(userid, widget.mentorid, widget.mentor['request_id']);
    });
  }

  Future<void> _refreshTasks() async {
    final provider = Provider.of<AssignedTasks>(context, listen: false);
    final userid = context.read<IdProviders>().userid;
    await provider.getassignedTasks(userid, widget.mentorid, widget.mentor['request_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.mentor['mentor_fullname']}'s Tasks", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      body: widget.mentor['has_payment']
          ? Consumer<AssignedTasks>(
              builder: (context, provider, child) {
                return provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                      onRefresh: _refreshTasks,
                      child: provider.assignedTasks.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.9,
                                child: const Center(
                                  child: Text("No tasks assigned yet"),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                              itemCount: provider.assignedTasks.length +
                              (widget.mentor['request_status'] ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < provider.assignedTasks.length) {
                                  final task = provider.assignedTasks[index];
                                    return ExpandableTaskCard(
                                      taskId: task['id'],
                                      title: task['task__title'],
                                      description: task['task__description'],
                                      date: task['created_at'],
                                      dairyEntry: task['dairy'],
                                      isSessionEnded:
                                          widget.mentor['request_status'],
                                      isTaskComplete: task['task__completed'],
                                    );
                                  } else {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                      child: Center(
                                        child: Text(
                                          'This session is ended.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                      );
              },
            )
          : const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
                  SizedBox(height: 30),
                  Text(
                    "Make a payment to start the session!",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
    );
  }
}
