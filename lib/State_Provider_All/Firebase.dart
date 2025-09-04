import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Post.dart';
import 'package:openmind_flutter/User/API_Services/API_Post.dart';

class FirebaseApi with ChangeNotifier {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Initialize Firebase and Local Notifications
  Future<void> initNotifications() async {
    try {
      // Firebase Messaging Initialization
      await _firebaseMessaging.requestPermission();

      // Get FCM Token
      _fcmToken = await _firebaseMessaging.getToken();

      notifyListeners();

      // Local Notification Initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen(_onMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

      // Set the background message handler (when the app is in the background or terminated)
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  // Handle foreground messages (when the app is open)
  Future<void> _onMessage(RemoteMessage message) async {
    print('Foreground message: ${message.notification?.body}');
    _showNotification(message.notification);
  }

  // Handle background messages (when the app is in the background or terminated)
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print('Background message: ${message.notification?.body}');
    // You can show a local notification here if necessary
  }

  // Handle message when the app is opened via a notification
  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    print('Opened app from notification: ${message.notification?.body}');
    // You can navigate to a specific screen if needed
  }

  // Show a local notification
  Future<void> _showNotification(RemoteNotification? notification) async {
    if (notification != null) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'your_channel_id', // Use a unique channel ID
        'your_channel_name', // Name for the channel
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      // Display the notification
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID (can use different IDs for multiple notifications)
        notification.title,
        notification.body,
        platformDetails,
        payload: 'item x', // can pass extra data if needed
      );
    }
  }

  // Refresh FCM token if expired
  Future<void> refreshToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      notifyListeners();
    } catch (e) {
      print("Error refreshing token: $e");
    }
  }

  // Send FCM token for Mentor
  Future<void> sendTokenToMentor(int mentorId) async {
    try {
      const endpoint = 'mentors/save_fcmtoken_mentor/'; // Add your API endpoint

      final data = {'fcmToken': fcmToken, 'mentor_id': mentorId};

      final response = await ApiServicesMentorPost.postRequest(endpoint, data);

      if (response.containsKey('error')) {
        throw Exception('${response['error']}');
      }
    } catch (e) {
      print("Error sending token to mentor: $e");
    }
  }

  // Send FCM token for User
  Future<void> sendTokenToUser(int userId) async {
    try {
      const endpoint = 'users/save_fcmtoken_user/';

      final data = {'fcmToken': fcmToken, 'user_id': userId};

      final response = await ApiServicesUserPost.postRequest(endpoint, data);

      if (response.containsKey('error')) {
        throw Exception('${response['error']}');
      }
    } catch (e) {
      print("Error sending token to user: $e");
    }
  }
  
}
