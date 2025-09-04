import 'package:flutter/material.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:http/http.dart' as http; // For HTTP Requests
import 'package:openmind_flutter/Mentor/Screens/Accounts/mentor_login.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';

class Signup3Mentor extends StatefulWidget {
  // Constructor for mentor id
  final int mentorId;

  const Signup3Mentor({super.key, required this.mentorId});

  @override
  State<Signup3Mentor> createState() => _Signup3MentorState();
}

class _Signup3MentorState extends State<Signup3Mentor> {
  // Controllers for text and image
  final _bioController = TextEditingController();
  File? _selectedImage; // Holds the selected image

  // Global key to manage form data
  final _formKey = GlobalKey<FormState>();

  // Loading state
  bool _isLoading = false;

  // Image picker function
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Convert to File
      });
    }
  }

  // Upload function
  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      final bio = _bioController.text;
      // For emulator 10.0.2.2:8000, for web 127.0.0.1:8000
      // In Django while running the server for emulator use this 
      //(python manage.py runserver 0.0.0.0:8000)
      final url = '${Apibaseurl.baseUrl}mentors/signup/profile/${widget.mentorId}/';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['bio'] = bio; // Add bio field

      if (_selectedImage != null) {
        // Add image file to the request
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          _selectedImage!.path
        ));
      }

      // Send the request
      var response = await request.send();

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MentorLoginScreen(),
          ),
        );
      } else {
        // Error message
        print(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile. Status: ${response.statusCode}'))
        );
      }
    }
  }

  // Dispose the controller to avoid memory leaks
  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  // Screen building
  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentor Sign-Up"),
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // Heading
              const Text(
                "Mentor Profile",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),

              // Profile photo picker
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 40,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!) // Show selected image
                      : null,
                  child: _selectedImage == null
                      ? const Icon(Icons.add_a_photo, size: 36, color: Colors.white,) // Placeholder
                      : null,
                ),
              ),
              const SizedBox(height: 50),

              // Bio field
              TextFormField(
                controller: _bioController,
                decoration: inputDecoration('bio'),
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              // Button to submit data
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadData, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator
                    : const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
