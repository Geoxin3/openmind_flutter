import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Accounts_State.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Bottom_Nav_State.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Chat_related_functions.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Home_mentor_State.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Requested_patients.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Schedule_functions.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Task_Assigning.dart';
import 'package:openmind_flutter/Splash_FIrstPage/SplashScreen.dart';
import 'package:openmind_flutter/State_Provider_All/Firebase.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Payment_Functions.dart';
import 'package:openmind_flutter/User/State_Provider_User/Accounts_state.dart';
import 'package:openmind_flutter/User/State_Provider_User/Assigned_Tasks.dart';
import 'package:openmind_flutter/User/State_Provider_User/Bottom_Nav_State.dart';
import 'package:openmind_flutter/User/State_Provider_User/Get_verified_search_mentors_state.dart';
import 'package:openmind_flutter/User/State_Provider_User/Home_user_state.dart';
import 'package:openmind_flutter/User/State_Provider_User/View_request_Mentors_state.dart';
import 'package:openmind_flutter/User/State_Provider_User/chat_releated_functions.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {

  //firebase initialize for notifications (FCM)
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final firebase = FirebaseApi();
  await firebase.initNotifications();

  //set the color and brightness of the status and navigation bars
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,

      systemNavigationBarColor: Colors.white, // Bottom nav background
      systemNavigationBarIconBrightness: Brightness.dark, // Icons in the bottom nav
    ),
  );
  
  runApp(MultiProvider(
    providers: [

    //bottom navigation bar provider mentor
    ChangeNotifierProvider<BottomNavProviderMentor>(
      create: (context)=> BottomNavProviderMentor()),

    //bottom naviagtion bar provider for user
    ChangeNotifierProvider<BottomNavProviderUser>(
      create: (context)=> BottomNavProviderUser()),

    //fetching the verified mentors for users 
    ChangeNotifierProvider<VerifiedMentorProvider>(
      create: (context)=> VerifiedMentorProvider()),

    //fetching detailed view of mentor
    ChangeNotifierProvider<DetailedViewOfMentors>(
      create: (context)=> DetailedViewOfMentors()),

    //store the id of mentor and user
    ChangeNotifierProvider<IdProviders>(
      create: (context)=> IdProviders(),),
    
    //fetching the requested patients for mentors
    ChangeNotifierProvider<RequestedPatients>(
      create: (context)=> RequestedPatients()),

    //notificaions reletaed methods (Firebase)
    ChangeNotifierProvider<FirebaseApi>(
      create: (context) => FirebaseApi()),

    //fetching the accpeted users for mentor
    ChangeNotifierProvider<Chatservice>(
      create: (context) => Chatservice()),

    //fetching the accepted mentors for user
    ChangeNotifierProvider<ChatServiceUser>
      (create: (context) => ChatServiceUser()),

    //task assigning releated functions (mentors)
    ChangeNotifierProvider<TaskAssigning>
      (create: (context) => TaskAssigning()),

    //assigned tasks releated function (Users)
    ChangeNotifierProvider<AssignedTasks>
      (create: (context) => AssignedTasks()),
    
    //mentors schedule task releated functions
    ChangeNotifierProvider<ScheduleFunctions>
      (create: (context) => ScheduleFunctions()),

    //mentor profile update functions
    ChangeNotifierProvider<AccountFunctions>
    (create: (context) => AccountFunctions()),

    //user profile update functions
    ChangeNotifierProvider<AccountUserFunctions>
    (create: (context) => AccountUserFunctions()),

    //user payment releated functions
    ChangeNotifierProvider<PaymentProvider>
    (create: (context) => PaymentProvider()),

    //mentor home provider
    ChangeNotifierProvider<MentorHomeProvider>
    (create: (context) => MentorHomeProvider()),
    
    //user home provider
    ChangeNotifierProvider<UserHomeProvider>
    (create: (context) => UserHomeProvider()),

    ],
  child:const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'openMind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home:const Splashscreen(),
      builder: (context, child) {
        // Applying the same UI overlay style inside MaterialApp builder for consistency
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
        return child!;
      },
    );
  }
}