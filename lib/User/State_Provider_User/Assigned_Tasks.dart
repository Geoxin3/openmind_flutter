import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/API_Services/API_Get.dart';
import 'package:openmind_flutter/User/API_Services/API_Post.dart';

class AssignedTasks with ChangeNotifier {

  //variable for loading state and task store
  bool _isLoading = false;
  List<Map<String, dynamic>> _assignedTasks = [];
  int? _dairyid; 
  
  //variables for expand task and dairycontorller
  final Map<int, bool> _expandedTasks = {}; //tracks which tasks are expanded
  final Map<int, TextEditingController> _dairyControllers = {}; //manage dairy controllers

  //getters
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get assignedTasks => _assignedTasks;
  int? get dairyid => _dairyid; 

  //method to check if the task isexpanded 
  bool isExpanded (int taskid) {
    return _expandedTasks[taskid] ?? false; 
  }

  //method to toogle the task expansion
  void toggleTask(int taskid) {
    _expandedTasks[taskid] = !(_expandedTasks[taskid] ?? false);
    notifyListeners();
  }

  //method to initialize the dairy contorller by assigning dairy form widget.dairyEntry
  TextEditingController getDairyController(int taskid, String? initialtext) {
    if(!_dairyControllers.containsKey(taskid)) {
      _dairyControllers[taskid] = TextEditingController(text: initialtext);
    }
    return _dairyControllers[taskid]!;
  }

  //method to fetch the assigned tasks of a user
  Future<void> getassignedTasks(int? userid, int? mentorid, int requestid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      final endpoint = 'mentors/get_assigned_tasks/$userid/$mentorid/$requestid/';

      //api response
      final response = await ApiServicesUserGet.getRequest(endpoint);

      if(response.containsKey('dairy_entries')) {
        _assignedTasks = List<Map<String, dynamic>>.from(response['dairy_entries']);
        //print(_assignedTasks);
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

  //method to submit dairy
  Future<void> submitDairy(String? dairy, int? taskid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      const endpoint = 'mentors/submited_dairy/';

      //api data to post
      final data = {"dairy": dairy, "task_id": taskid};

      //api response
      final response = await ApiServicesUserPost.postRequest(endpoint, data);

      if(response.containsKey('message')) {
        _dairyid = response['dairy_id'];
        print(_dairyid);
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

  //method to dispose contollers of the map
  //looping through each map 
  void disposeControllers() {
    for (var controller in _dairyControllers.values) {
      controller.dispose();
    }
    _dairyControllers.clear();
  }

  //dispose the controllers
  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

}