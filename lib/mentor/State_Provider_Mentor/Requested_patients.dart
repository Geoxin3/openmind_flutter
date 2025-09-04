import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Get.dart';
import 'package:openmind_flutter/User/Models/Mentor_model.dart';
import 'package:openmind_flutter/mentor/API_Services/API_Post.dart';

class RequestedPatients with ChangeNotifier {

  //model class reused form the user model
  //accepted and rejected request are stored
  List<MentorRequest>? _requesteduser;
  bool _isLoading = false;
  //only pending requst storing 
  List<MentorRequest>? _pendingRequest;

  //getters
  List<MentorRequest>? get requesteduser => _requesteduser;
  bool get isLoading => _isLoading;
  List<MentorRequest>? get pendingRequest => _pendingRequest;
  
  //variable for sorting the mentorid form the fetch function
  //and use it in the update function
  int? _mentorId;

  //method to fetch reqeuested users
  Future<void> fetchmyPatients(int? mentorid) async {
    
    //stores the argument to the global variable
    _mentorId = mentorid;

    //loading state
    _isLoading = true;
    notifyListeners();

    try {

      //api endpoint
      final endpoint = 'mentors/view_my_patients/$mentorid/';

      //api response
      final response = await ApiServicesMentorGet.getRequest(endpoint);

      //if the respone has returned error
      if(response.containsKey('error')) {
        throw Exception('${response['error']}');
      }

      //handle the response
      if(response.containsKey('requests')) {
        var requestlist = response['requests'] as List;
        //only pending request
        _pendingRequest = requestlist.map((data) => MentorRequest.fromJson(data))
        .where((request) => request.status == 'PENDING') //for showing only the pending request
        .toList();
        //all other request for showing the history of requests
        _requesteduser = requestlist.map((data) => MentorRequest.fromJson(data))
        .where((request) => request.status == 'ACCEPTED' || request.status == 'REJECTED')
        .toList();
      } else {
        _requesteduser = null;
      }

      //stop loading
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to update request status 
  Future<void> updateRequestStatus(int id, String status) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      
      //api endpoint
      const endpoint = 'mentors/accept_or_reject_request/';

      //data for posting the request id and status
      final data = {'id': id, 'status': status};

      //api resopnse
      final response = await ApiServicesMentorPost.postRequest(endpoint, data);

      //if the response returns error
      if(response.containsKey('error')) {
        throw Exception('${response['error']}');
      }

      //handle response
      if(response.containsKey('message')) {
        print(response['message']);
        
      }

      //refreshing the request list of model 
      await fetchmyPatients(_mentorId);

      //stop loading
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      
      print('Error: ${(e)}');
      _isLoading = false;
      notifyListeners();
    }
  }

}