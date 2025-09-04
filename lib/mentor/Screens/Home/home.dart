import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/bottom_nav.dart';
import 'package:openmind_flutter/Mentor/Screens/Home/Settings.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Bottom_Nav_State.dart';
import 'package:provider/provider.dart';

class HomeMentor extends StatefulWidget {
  
  final int? mentorid;
  final String? fullname;
  final String? profilepicture;
  
  const HomeMentor({super.key,
   this.mentorid,
   this.fullname,
   required this.profilepicture 
  });

  @override
  State<HomeMentor> createState() => _HomeMentorState();
}

class _HomeMentorState extends State<HomeMentor> {

  //screen building
  @override
  Widget build(BuildContext context) {
    //for showing the app bar onyl on index 2 that is home
    int selectedIndex = context.watch<BottomNavProviderMentor>().selectedIndex;

    return Scaffold(

      //appbar
      appBar: selectedIndex == 2
       ? AppBar(automaticallyImplyLeading: false,
        title: Row(
        children: [
          //profile picture
          const SizedBox(width: 10,),
           Padding(
            padding:const EdgeInsets.only(top: 10),
            child: CircleAvatar(maxRadius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.profilepicture != null  
              ? NetworkImage(widget.profilepicture!)
              : null,
            child: widget.profilepicture == null 
              ? const Icon(Icons.person, size: 35, color: Colors.white,)
              : null,),
          ),
          //mentor name
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('Hi, ${widget.fullname}', style:const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          
        ],
      ),
        //trailing and other things in appbar
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsMentor()));
            }, icon:const Icon(Icons.settings, color: Colors.white, size: 30,)),
          )
        ],
        backgroundColor: Colors.teal,)
        : null,

      //body
      //displays the widgets that are passed to the bottom
      //nav provider 
      body: Consumer<BottomNavProviderMentor>(
        builder: (context, provider, child) {
          return provider.pages[provider.selectedIndex];  // Display the selected page
        },
      ),
        
      //bottom navigation bar
      bottomNavigationBar:Consumer<BottomNavProviderMentor>(
        builder: (context, provider, child) {
          return  CustomBottomNavigationBar(
        items: provider.bottomNavItems,
        //backgroundColor: Colors.white,
        selectedItemColor: Colors.teal.shade900,
        unselectedItemColor: Colors.grey,
        selectedIndex: provider.selectedIndex,
        onItemTapped: (index){
          provider.setSelectedIndex(index);
        });
    }));
  }
}