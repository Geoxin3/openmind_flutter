import 'package:flutter/material.dart';

class AccountRejectedPage extends StatelessWidget {
  const AccountRejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Rejected'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Your account has been rejected.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Please contact support for more information.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
