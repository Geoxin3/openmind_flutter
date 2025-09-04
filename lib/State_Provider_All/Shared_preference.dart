import 'package:shared_preferences/shared_preferences.dart';

/// Save login info + user details
Future<void> saveData({
  required bool isLoggedIn,
  required String userType,
  required int userId, // Changed from String to int
  required String userName,
  required String profilePicUrl,
}) async {
  final SharedPreferences store = await SharedPreferences.getInstance();
  await store.setBool('isLoggedIn', isLoggedIn);
  await store.setString('userType', userType);
  await store.setInt('userId', userId); // Changed from setString to setInt
  await store.setString('userName', userName);
  await store.setString('profilePicUrl', profilePicUrl);
}

/// Get login info + user details
Future<Map<String, dynamic>> getData() async {
  final SharedPreferences store = await SharedPreferences.getInstance();
  bool isLoggedIn = store.getBool('isLoggedIn') ?? false;
  String userType = store.getString('userType') ?? '';
  int userId = store.getInt('userId') ?? 0; // Changed from getString to getInt
  String userName = store.getString('userName') ?? '';
  String profilePicUrl = store.getString('profilePicUrl') ?? '';

  return {
    'isLoggedIn': isLoggedIn,
    'userType': userType,
    'userId': userId,
    'userName': userName,
    'profilePicUrl': profilePicUrl,
  };
}

/// Clear all saved data (for logout)
Future<void> clearData() async {
  final SharedPreferences store = await SharedPreferences.getInstance();
  await store.clear(); // wipes everything
}
