import 'package:flutter/material.dart';

class TermsAndPrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Privacy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By continuing, you agree to our:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Terms and Conditions link
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen(),
                  ),
                );
              },
              child: Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 15),

            // Privacy Policy link
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicyScreen(),
                  ),
                );
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Please read the terms and conditions and privacy policy carefully before proceeding.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  final List<String> termsList = [
    'By using this app, you agree to our terms and conditions.',
    'The app is provided "as is," and we make no warranties or guarantees about its performance or accuracy.',
    'We are not responsible for any damages or losses caused by the use of this app.',
    'You agree to follow all the guidelines and policies set by the app.',
    'You must not use the app for illegal activities.',
    'Any personal data you provide may be used for app-related services and updates.',
    'The app reserves the right to suspend or terminate your account at any time for violations of these terms.',
    'We reserve the right to modify these terms at any time, and you will be notified of any changes.',
    'All content on the app is copyrighted and may not be reproduced without permission.',
    'You agree to settle any disputes through arbitration rather than legal action.',
    'If you do not agree with these terms, you should not use the app.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: termsList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      termsList[index],
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  final List<String> privacyList = [
    'We respect your privacy and are committed to protecting your personal information.',
    'We only collect information necessary to provide the services of the app, including your name, email address, and usage data.',
    'We do not share or sell your personal information to third parties without your consent, except as required by law.',
    'We use encryption and secure protocols to safeguard your data.',
    'You have the right to access, modify, or delete your personal data at any time through the app settings.',
    'We may use cookies to enhance your experience and analyze app usage.',
    'We may update this privacy policy from time to time. Any changes will be communicated via the app.',
    'By using this app, you consent to the collection and processing of your information as described in this policy.',
    'If you do not agree with this policy, you should not use the app.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: privacyList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      privacyList[index],
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}