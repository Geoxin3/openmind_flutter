import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Get.dart';
import 'package:openmind_flutter/mentor/API_Services/API_Post.dart';

class TaskAssigning with ChangeNotifier {

  //variable for extending the floating action button
  bool _isMenuVisible = false; // for floating action button 
  bool _isLoading = false; //for tracking loading state
  int? _taskid;
  int? _dairyid;
  bool _isSessionCompleted = false;
  List<Map<String, dynamic>> _assignedTasks = [];
  final Map<int?, bool> _taskExpansionState = {}; //map for tracking the task card expansion 

  //getters
  bool get isMenuVisible => _isMenuVisible;
  bool get isLoading => _isLoading;
  int? get taskid => _taskid;
  int? get dairyid => _dairyid;
  bool get isSessionCompleted => _isSessionCompleted;
  List<Map<String, dynamic>> get assignedTasks => _assignedTasks;
  Map<int?, bool> get taskExpansionState => _taskExpansionState;
  
  //
  //used this in reusable task status toggle
  final Map<int, bool> _taskCompletionStatus = {}; // Store task status (diaryId -> isComplete)
  //getter
  Map<int, bool> get taskCompletionStatus => _taskCompletionStatus;

  //method to toggle the task status
  void toggleTaskStatus(int? diaryId) {
    if (diaryId == null) return;
    
    _taskCompletionStatus[diaryId] = !(_taskCompletionStatus[diaryId] ?? false);

    notifyListeners(); // Update UI immediately
  }

  //method to handle the toggle state properly
  void delayedToggleTaskExpansion(int? taskId) {
    Future.delayed(Duration.zero, () {
      toggleTaskExpansion(taskId);  //original method that toggles task expansion
    });
  }

  //method to set the initial state of the task state
  void setInitialStatus(int? taskId, bool initialState) {
    if (taskId != null && !_taskCompletionStatus.containsKey(taskId)) {
      _taskCompletionStatus[taskId] = initialState;
      notifyListeners();
    }
  }

  //method to update the task as complete or incomplete for mentors
  Future<void> taskComplete(bool iscomplete, int? taskid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try{

      const endpoint = 'mentors/complete_task/';

      final data = {'is_complete': iscomplete, 'task_id': taskid};

      final repsonse = await ApiServicesMentorPost.postRequest(endpoint, data);

      if(repsonse.containsKey('message')) {
        //
      }

      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to toggle the floating action button
  void toggleMenu() {
    _isMenuVisible = !_isMenuVisible;
    notifyListeners();
  }

  //method to clear the state of visibility of floating action button
  void clean() {
    _isMenuVisible = false;
    notifyListeners();
  }
  
  //method to toggle the expansion of task cards for a users multiple tasks
  void toggleTaskExpansion(int? taskId) {
    // Toggle expansion state for the given task
    _taskExpansionState[taskId] = !(_taskExpansionState[taskId] ?? false);
    
    notifyListeners();
  }

  //method to assign a new task to user
  Future<void> assignNewDairy(int? mentorid, int userid, String title, String description, int requestid) async {

    //loading state
    _isLoading = true;
    notifyListeners();
    
    try {
      //api endpoint
      const endpoint = 'mentors/assign_new_dairy/';

      //data for posting
      final data = {
        'mentor_id': mentorid, 
        'user_id': userid,
        'task_title': title,
        'task_description': description,
        'request_id': requestid
      };

      //api response
      final response = await ApiServicesMentorPost.postRequest(endpoint, data);

      if(response.containsKey('message')) {
        _taskid = response['task_id'];
        _dairyid = response['dairy_id']; 
      } else {
        print(response['error']);
      }
      
      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
}

  //method to fetch the assigned tasks to a user can also used for the user
  Future<void> getassignedTasks(int? userid, int? mentorid, int requestid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      final endpoint = 'mentors/get_assigned_tasks/$userid/$mentorid/$requestid/';

      //api response
      final response = await ApiServicesMentorGet.getRequest(endpoint);

      if(response.containsKey('dairy_entries')) {
        _assignedTasks = List<Map<String, dynamic>>.from(response['dairy_entries']);
        // print(_assignedTasks);
      } else {
        print(response['error']);
        _assignedTasks = [];
      }

      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method for analysing emotions of dairy (ML MODEL)
  Future<void> analyseEmotion(int? dairyid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      const endpoint = 'mentors/analyse_dairy_emotion/';

      //data for posting 
      final data = {'dairy_id': dairyid};
      
      //api response
      final response = await ApiServicesMentorPost.postRequest(endpoint, data);

      if(response.containsKey('message')) {
        print(response);
      } else {
        print(response['error']);
      }

      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      
      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to complete or end a session
  Future<void> completeSession(int userid, int mentorid, int requestid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {

      const endpoint = 'mentors/complete_session/';

      final data = {
        'user_id': userid,
        'mentor_id': mentorid,
        'request_id': requestid
      };

      final response = await ApiServicesMentorPost.postRequest(endpoint, data);

      if(response.containsKey('message')) {
        _isSessionCompleted = true;
        notifyListeners();
      }
      
      

      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  //mehthod to delete a task (dairy)
  Future<void> deleteTask(int taskid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {

      const endpoint = 'mentors/delete_task/';

      final data = {'task_id': taskid};

      final response = await ApiServicesMentorPost.postRequest(endpoint, data);

      if(response.containsKey('message')) {
        //print(response['message']);
      }

      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      
      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to assgin a new type of task (currently not using this) 
  Future<void> assignNewTask() async {
    //
  } 

}