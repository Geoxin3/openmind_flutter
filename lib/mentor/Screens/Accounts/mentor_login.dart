import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/validation.dart';
import 'package:openmind_flutter/Mentor/Screens/Accounts/1_Signup_basic.dart';
import 'package:openmind_flutter/Mentor/Screens/Home/home.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/Firebase.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Shared_preference.dart';
import 'package:provider/provider.dart';

// Mentor login API endpoint
const String apiUrl = "${Apibaseurl.baseUrl}mentors/mentor_login/";

class MentorLoginScreen extends StatefulWidget {
  const MentorLoginScreen({super.key});

  @override
  MentorLoginScreenState createState() => MentorLoginScreenState();
}

class MentorLoginScreenState extends State<MentorLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _loginFormKey = GlobalKey<FormState>();

  // Function to handle login
  Future<void> mentorLogin() async {
    final firebaseapi = Provider.of<FirebaseApi>(context, listen: false);
    await firebaseapi.initNotifications(); // Generate Firebase token

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final mentorId = responseData['mentor_id'];
        final fullname = responseData['full_name'];
        final profilepicture = responseData['profile_picture'];

        //saving to shared_prefs
        await saveData(
          isLoggedIn: true,
          userType: 'mentor',
          userId: mentorId,
          userName: fullname,
          profilePicUrl: profilepicture ?? '',
        );

        await firebaseapi.sendTokenToMentor(mentorId);
        //setting id to id provider
        context.read<IdProviders>().setmentorId(mentorId);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeMentor(
              mentorid: mentorId,
              fullname: fullname,
              profilepicture: profilepicture,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        // Display error using Snackbar
        final error = jsonDecode(response.body)['error'] ?? 'Login failed. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$error")),
        );
        print(response.body);
      }
    } catch (error) {
      // Display error using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back !",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
            
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: Validator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
            
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: Validator.validatePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
            
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading 
                      ? null
                      : () {
                          if (_loginFormKey.currentState!.validate()) {
                            mentorLogin(); // Only call login if form is valid
                          }
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 15),
            
                // Register Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Signup1Mentor()),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(' as mentor')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
