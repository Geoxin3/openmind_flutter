import 'package:flutter/material.dart';

class IdProviders with ChangeNotifier {
  int? _userid;
  int? _mentorid;
  
  //getters
  int? get userid => _userid;
  int? get mentorid => _mentorid; 

  //setters
  //method to set user id
  void setuserId(int? id) {
    _userid = null;
    _userid = id;
    notifyListeners();
  }

  //method to set mentor id
  void setmentorId(int? id) {
    _mentorid = null;
    _mentorid = id;
    notifyListeners();
  }

}