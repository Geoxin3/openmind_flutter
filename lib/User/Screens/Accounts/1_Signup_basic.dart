import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openmind_flutter/Custom_Widgets/terms_and_privacy.dart';
import 'package:openmind_flutter/Custom_Widgets/validation.dart';
import 'package:openmind_flutter/User/API_Services/API_Post.dart';
import 'package:openmind_flutter/User/Screens/Accounts/2_Signup_profile.dart';

class Signup1User extends StatefulWidget {
  const Signup1User({super.key});

  @override
  State<Signup1User> createState() => _Signup1UserState();
}

class _Signup1UserState extends State<Signup1User> {
  final _fullName_Controller = TextEditingController();
  final _email_Controller = TextEditingController();
  final _password_Controller = TextEditingController();
  final _phone_number_Controller = TextEditingController();
  final _date_Of_Birth_Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedGender;

  bool _isLoading = false; // Variable to track the loading state
  bool _isTermsAccepted = false;
  bool _isPrivacyPolicyAccepted = false;

  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if both terms and privacy policy are accepted
      if (!_isTermsAccepted || !_isPrivacyPolicyAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the Terms and Privacy Policy.')),
        );
        return;
      }

      setState(() {
        _isLoading = true; // Set loading state to true when submission starts
      });

      final formData = {
        'full_name': _fullName_Controller.text,
        'email': _email_Controller.text,
        'password': _password_Controller.text,
        'phone_number': _phone_number_Controller.text,
        'gender': _selectedGender,
        'date_of_birth': _date_Of_Birth_Controller.text,
        'agreed_to_terms': _isTermsAccepted,
        'agreed_to_privacy_policy': _isPrivacyPolicyAccepted,
      };

      print('Form Data: $formData');

      try {
        final response = await ApiServicesUserPost.postRequest('users/signup/basic/', formData);

        print(response['message']);

        if (response.containsKey('user_id')) {
          int userId = response['user_id'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Signup2User(userId: userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'Signup failed. Please try again.'),
            ),
          );
        }
      } catch (e) {
        print('Network error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false when the submission ends
        });
      }
    }
  }

  @override
  void dispose() {
    _fullName_Controller.dispose();
    _email_Controller.dispose();
    _password_Controller.dispose();
    _phone_number_Controller.dispose();
    _date_Of_Birth_Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Your Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Full Name
              TextFormField(
                controller: _fullName_Controller,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: _email_Controller,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validator.validateEmail,
              ),
              const SizedBox(height: 15),

              // Password
              TextFormField(
                controller: _password_Controller,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                ),
                obscureText: true,
                validator: Validator.validatePassword,
              ),
              const SizedBox(height: 15),

              // Phone Number
              TextFormField(
                controller: _phone_number_Controller,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                ),
                keyboardType: TextInputType.phone,
                validator: Validator.validatePhoneNumber,
              ),
              const SizedBox(height: 15),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                ),
                value: _selectedGender,
                items: ['Male', 'Female', 'Prefer Not To Say']
                    .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null ? 'Please select your gender' : null,
              ),
              const SizedBox(height: 15),

              // Date of Birth Picker
              TextFormField(
                controller: _date_Of_Birth_Controller,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _date_Of_Birth_Controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) => value!.isEmpty ? 'Please select your date of birth' : null,
              ),
              const SizedBox(height: 20),

              // Terms and Conditions Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isTermsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isTermsAccepted = value!;
                      });
                    },
                    activeColor: Colors.teal, // Color when checkbox is selected
                  ),
                  GestureDetector(
                    onTap: () {
                      // Open Terms and Conditions link (add navigation logic here)
                    },
                    child: const Text(
                      "I agree to the Terms and Conditions",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              // Privacy Policy Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isPrivacyPolicyAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPrivacyPolicyAccepted = value!;
                      });
                    },
                    activeColor: Colors.teal, // Color when checkbox is selected
                  ),
                  GestureDetector(
                    onTap: () {
                      // Open Privacy Policy link (add navigation logic here)
                    },
                    child: const Text(
                      "I agree to the Privacy Policy",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : submitForm, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading // Show loading spinner if form is submitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 0),

              // Terms and Privacy Policy Links with GestureDetector
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'By signing up, you agree to our ',
                      style: TextStyle(fontSize: 10),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Terms and Conditions page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsAndConditionsScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Terms and Conditions',
                        style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline),
                      ),
                    ),
                    const Text(
                      ' and ',
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Privacy Policy page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),

              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
