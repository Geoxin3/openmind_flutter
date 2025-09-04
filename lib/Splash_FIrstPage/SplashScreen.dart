import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:openmind_flutter/Mentor/Screens/Home/home.dart';
import 'package:openmind_flutter/Splash_FIrstPage/FirstPage.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Shared_preference.dart';
import 'package:openmind_flutter/User/Screens/Home/home.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    super.initState();
    splash();
  }

  //method to check the shared_prefs
  void splash() async {
    //splash delay
    await Future.delayed(const Duration(seconds: 2));

    final data = await getData();

    if (data['isLoggedIn']) {
      if (data['userType'] == 'user') {
        //setting the id to id provider
        context.read<IdProviders>().setuserId(data['userId']);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:(context)=> HomeUser(
              fullname: data['userName'],
              profilepicture: data['profilePicUrl'],
            )),
            (Route<dynamic>route)=>false,);
        
      } else if (data['userType'] == 'mentor') {
        //setting the id to id provider
        context.read<IdProviders>().setmentorId(data['userId']);
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:(context)=> HomeMentor(
              mentorid: data['userId'],
              fullname: data['userName'],
              profilepicture: data['profilePicUrl'],
            )),
            (Route<dynamic>route)=>false,);
      } else {
          Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:(context)=> const WelcomePage()),
            (Route<dynamic>route)=>false,);
      }
    } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:(context)=> const WelcomePage()),
            (Route<dynamic>route)=>false,);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.4,
          left: MediaQuery.of(context).size.width * 0.1,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          child: Lottie.asset("assets/openMind_anim_light.json"),
        ),
      ),
    ),
  );
}
}