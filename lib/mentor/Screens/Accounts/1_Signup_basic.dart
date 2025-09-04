import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/validation.dart';
import 'package:openmind_flutter/Mentor/Screens/Accounts/2_Signup_professional.dart';
import 'package:openmind_flutter/mentor/API_Services/API_Post.dart';
import 'package:intl/intl.dart';

class Signup1Mentor extends StatefulWidget {
  const Signup1Mentor({super.key});

  @override
  State<Signup1Mentor> createState() => _Signup1MentorState();
}

class _Signup1MentorState extends State<Signup1Mentor> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  // Variable to track loading state
  bool _isLoading = false;

  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Set loading state to true when submitting
      });

      final formData = {
        'full_name': _fullNameController.text,
        'email': _emailController.text,
        'phone_number': _phoneNumberController.text,
        'password': _passwordController.text,
        'gender': _selectedGender,
        'date_of_birth': _dateOfBirthController.text,
      };

      print('Form Data: $formData');

      try {
        final response = await ApiServicesMentorPost.postRequest('mentors/signup/basic/', formData);
        print('this is res${response['message']}');

        if (response.containsKey('message')) {
          int mentorId = response['mentor_id'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Signup2Mentor(mentorId: mentorId)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'Signup failed. Please try again.'),
          ));
        }
      } catch (e) {
        print('Network error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Reset loading state after submission
        });
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mentor Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Your Mentor Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validator.validateEmail,
              ),
              const SizedBox(height: 15),

              // Phone Number
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
                validator: Validator.validatePhoneNumber,
              ),
              const SizedBox(height: 15),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
                validator: Validator.validatePassword,
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
                controller: _dateOfBirthController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                      _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) => value!.isEmpty ? 'Please select your date of birth' : null,
              ),
              const SizedBox(height: 20),

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
              const SizedBox(height: 10),

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
