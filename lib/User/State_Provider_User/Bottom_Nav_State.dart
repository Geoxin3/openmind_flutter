
import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/Screens/Accounts/Account_View.dart';
import 'package:openmind_flutter/User/Screens/Chats/chat_list.dart';
import 'package:openmind_flutter/User/Screens/Home/Main_home.dart';
import 'package:openmind_flutter/User/Screens/My%20Mentors/Mentor_List.dart';
import 'package:openmind_flutter/User/Screens/Searchs/Get_Verfifed_and_Search_Mentors.dart';

class BottomNavProviderUser with ChangeNotifier {
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
      icon: Icon(Icons.search_rounded),
      label: 'Search',
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
      icon: Icon(Icons.groups),
      label: 'My Mentors',
    ),
  ];

  // List of pages
  List<Widget> get pages => [
    //list of pages in the bottom nav bar
    const ViewMYAccountUser(),
    const SearchMentors(),
    const MainHomeUser(),
    const ChatListScreenUser(),
    const MyMentorsList()
  ];
}
