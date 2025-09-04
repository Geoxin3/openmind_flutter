import 'package:flutter/material.dart';
import 'package:openmind_flutter/Splash_FIrstPage/FirstPage.dart';
import 'package:openmind_flutter/State_Provider_All/Shared_preference.dart';

class SettingsMentor extends StatelessWidget {
  const SettingsMentor({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              //
              await clearData();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder:(context)=> const WelcomePage()),
                  (Route<dynamic>route)=>false,);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              onTap: () => _showLogoutDialog(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.red.withOpacity(0.05),
            ),
          ],
        ),
      ),
    );
  }
}
