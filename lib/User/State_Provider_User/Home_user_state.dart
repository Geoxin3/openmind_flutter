import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/API_Services/API_Get.dart';
import 'package:openmind_flutter/User/Models/User_model.dart';

class UserHomeProvider with ChangeNotifier {

  bool _isLoading = false;
  UserHome? _userHome;

  //getter
  bool get isLoading => _isLoading;
  UserHome? get userHome => _userHome;

  //method to load user home data
  Future<void> fetchUserHomedata(int? userid) async {

    //loading state
    _userHome = null;
    _isLoading = true;
    notifyListeners();

    try{
      
      final endpoint = 'mentors/load_home_user/$userid/';

      final response = await ApiServicesUserGet.getRequest(endpoint);

      if(response.containsKey('error')) {
        print(response['error']);
      }
       
      _userHome = UserHome.fromJson(response);
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //
}