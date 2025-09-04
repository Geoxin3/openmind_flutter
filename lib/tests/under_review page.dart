import 'package:flutter/material.dart';

class AccountUnderReviewPage extends StatelessWidget {
  const AccountUnderReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Under Review'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              'Your account is under review.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'You will be notified once the admin approves your account.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
