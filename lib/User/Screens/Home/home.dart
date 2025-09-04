import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/bottom_nav.dart';
import 'package:openmind_flutter/User/Screens/Home/Settings_user.dart';
import 'package:openmind_flutter/User/State_Provider_User/Bottom_Nav_State.dart';
import 'package:provider/provider.dart';

class HomeUser extends StatefulWidget {
  //constructor for mentor id
  final String? fullname;
  final String? profilepicture;
  
  const HomeUser({super.key,
   this.fullname,
   this.profilepicture 
  });

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {

  //screen building
  @override
  Widget build(BuildContext context) {
    //for showing the app bar onyl on index 2 that is home
    int selectedIndex = context.watch<BottomNavProviderUser>().selectedIndex;

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
            backgroundColor: Colors.grey[200],
            backgroundImage: widget.profilepicture != null  
            ? NetworkImage(widget.profilepicture!)
            : null,
            child: widget.profilepicture == null 
            ? const Icon(Icons.person, size: 35, color: Colors.grey,)
            : null,),
          ),
          //user name
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('Hi, ${widget.fullname}', style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
          ),
          // //newly added call this in logout
          // //
          // ElevatedButton(onPressed: () async{
          //   await clearData();
          // },
          //  child: Text('Logout'))
          // //
        ],
      ),
        //trailing and other things in appbar
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsUser()));
            }, icon:const Icon(Icons.settings, color: Colors.white, size: 30,)),
          )
        ],
        backgroundColor: Colors.teal,)
        : null,

      //body
      //displays the widgets that are passed to the bottom
      //nav provider 
      body: Consumer<BottomNavProviderUser>(
        builder: (context, provider, child) {
          return provider.pages[provider.selectedIndex];  // Display the selected page
        },
      ),
        
      //bottom navigation bar
      bottomNavigationBar:Consumer<BottomNavProviderUser>(
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