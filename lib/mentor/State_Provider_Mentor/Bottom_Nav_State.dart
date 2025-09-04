import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/Screens/Accounts/Account_View.dart';
import 'package:openmind_flutter/Mentor/Screens/Chats/chat_list.dart';
import 'package:openmind_flutter/Mentor/Screens/Home/Main_home.dart';
import 'package:openmind_flutter/Mentor/Screens/Patients/Patients_List.dart';
import 'package:openmind_flutter/Mentor/Screens/Schedules/Schedule.dart';

class BottomNavProviderMentor with ChangeNotifier {
  //value set to 2 cause home page is in index three in list pages
  int _selectedIndex = 2;

  int get selectedIndex => _selectedIndex;

  // Set the selected index
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();  // Notify listeners when the state changes
  }
  
  // List of BottomNavigationBarItems
  List<BottomNavigationBarItem> get bottomNavItems =>const [
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Account',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_outlined),
      label: 'Schedule',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_hospital_outlined),
      label: 'Patients',
    ),
  ];

  // List of pages
  List<Widget> get pages => [
    //list of pages in the bottom nav bar
    const ViewMyAccountMentor(),
    const ScheduleMyTime(),
    const MainHomeMentor(),
    const ChatListScreen(),
    const PatientMainPage()
  ];
}
