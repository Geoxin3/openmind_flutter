import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:openmind_flutter/Mentor/Screens/Accounts/mentor_login.dart';
import 'package:openmind_flutter/User/Screens/Accounts/login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Plain White Background
      body: Stack(
        children: [
          // SVG Image as background, with transparent background
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.5),
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/openMind_Logo.svg',
                  height: 150,  
                  fit: BoxFit.contain,  // Ensures the image scales nicely without distortion
                ),
              ),
            ),
          ),
          // Content in the foreground
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                const Text(
                  "Welcome to OpenMind",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Choose your role to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                // User Login Button
                _buildLoginButton(
                  context,
                  "Login as User",
                  Icons.person,
                  Colors.blueAccent,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen())
                  ),
                ),
                const SizedBox(height: 20),
                // Mentor Login Button
                _buildLoginButton(
                  context,
                  "Login as Mentor",
                  Icons.psychology,
                  Colors.teal,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MentorLoginScreen())
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Login Button
  Widget _buildLoginButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
