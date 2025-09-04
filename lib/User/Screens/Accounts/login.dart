import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openmind_flutter/Custom_Widgets/validation.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/Firebase.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Shared_preference.dart';
import 'package:openmind_flutter/User/Screens/Accounts/1_Signup_basic.dart';
import 'package:openmind_flutter/User/Screens/Home/home.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  final String baseUrl = '${Apibaseurl.baseUrl}users'; // Backend API URL

  Future<void> loginUser() async {
    final firebaseapi = Provider.of<FirebaseApi>(context, listen: false);
    await firebaseapi.initNotifications(); // Generate Firebase token

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/user/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _email,
          "password": _password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final int userId = data['user_id'];
        final String fullname = data['full_name'];
        final String? profilepicture = data['profile_picture'];

        //saving the data to shared_prefs
        await saveData(
          isLoggedIn: true,
          userType: 'user',
          userId: userId,
          userName: fullname,
          profilePicUrl: profilepicture ?? '',
        );

        await firebaseapi.sendTokenToUser(userId);
        //setting id to id provider
        context.read<IdProviders>().setuserId(userId);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeUser(
              fullname: fullname,
              profilepicture: profilepicture,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        final error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
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
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: Validator.validateEmail,
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 15),

                // Password Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                  validator: Validator.validatePassword,
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 15),

                // Login Button with loading state
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_loginFormKey.currentState!.validate()) {
                              // Only save and login if the form is valid
                              _loginFormKey.currentState!.save();
                              loginUser();
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
                        ? const CircularProgressIndicator(color: Colors.white,)
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
                          MaterialPageRoute(builder: (context) => const Signup1User()),
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
                    const Text(' as user')
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
