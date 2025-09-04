import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Get.dart';
import 'package:openmind_flutter/Mentor/Models/Mentor_Class.dart';

class MentorHomeProvider with ChangeNotifier {

  bool _isLoading = false;
  MentorHome? _homeDetails;

  //getters
  bool get isLoading => _isLoading;
  MentorHome? get homeDetails => _homeDetails;

  //method to get mentor home data
  Future<void> fetchMentorHomedata(int? mentorid) async {

    //loading state
    _homeDetails = null;
    _isLoading = true;
    notifyListeners();

    try{
      
      final endpoint = 'mentors/load_home_mentor/$mentorid/';

      final response = await ApiServicesMentorGet.getRequest(endpoint);

      if(response.containsKey('error')) {
        print(response['error']);
      }

      _homeDetails = MentorHome.fromJson(response);
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      
      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method
}