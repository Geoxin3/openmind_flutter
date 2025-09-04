import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Get.dart';

class Chatservice with ChangeNotifier {

  //variable for storing the retrieved users
  List<Map<String, dynamic>>? _acceptedUsers;
  bool _isLoading = false;

  //getters
  List<Map<String, dynamic>>? get accepedUsers => _acceptedUsers;
  bool get isLoading => _isLoading;

  //method to fetch the accpeted users
  Future<void> getacceptedUsers(int? mentorid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpiont
      final endpoint = 'mentors/get_accepted_users/$mentorid';

      //response
      final response = await ApiServicesMentorGet.getRequest(endpoint);

      //response contains accepted user list
      if(response.containsKey('accepted_users')) {
        _acceptedUsers = List<Map<String, dynamic>>.from(response['accepted_users']);
        notifyListeners();
      }

      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //This method is user in patient dairy class to manage state while ending the session
  //this updates the request status thus ui updates
  void updateSessionStatus(int userId, int requestId, bool isSessionEnded) {
    // Update the status in your accepted users list
    for (var user in _acceptedUsers!) {
      if (user['user_id'] == userId && user['request_id'] == requestId) {
        user['request_status'] = isSessionEnded;
        break;
      }
    }
    notifyListeners();
  }
  
  //this method is not using now
  String generateRoomName(int userId, int mentorId) {
    List<int> ids = [userId, mentorId];
    ids.sort(); // Ensures consistency
    return "${ids[0]}_${ids[1]}";
  }

}