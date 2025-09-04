import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/API_Services/API_Get.dart';

class ChatServiceUser with ChangeNotifier {

  //variable for storing the retrieved users
  List<Map<String, dynamic>>? _acceptedMentors;
  bool _isLoading = false;

  //getters
  List<Map<String, dynamic>>? get accepedMentors => _acceptedMentors;
  bool get isLoading => _isLoading;

  //method to fetch the accpeted users
  Future<void> getacceptedMentors(int? userid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpiont
      final endpoint = 'mentors/get_accepted_mentors/$userid';

      //response
      final response = await ApiServicesUserGet.getRequest(endpoint);

      //response contains accepted user list
      if(response.containsKey('accepted_mentors')) {
        _acceptedMentors = List<Map<String, dynamic>>.from(response['accepted_mentors']);
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

  //this method is not used now
  String generateRoomName(int userId, int mentorId) {
    List<int> ids = [userId, mentorId];
    ids.sort(); // Ensures consistency
    return "${ids[0]}_${ids[1]}";
  }

}