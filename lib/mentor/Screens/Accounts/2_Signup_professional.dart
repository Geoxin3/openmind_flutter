import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/terms_and_privacy.dart';
import 'package:openmind_flutter/Mentor/Screens/Accounts/3_Signup_profile.dart';
import 'package:openmind_flutter/mentor/API_Services/API_Post.dart';
import 'package:intl/intl.dart';
import 'package:openmind_flutter/Custom_Widgets/dialoguebox_multiselect.dart';

class Signup2Mentor extends StatefulWidget {
  final int mentorId;
  const Signup2Mentor({super.key, required this.mentorId});

  @override
  State<Signup2Mentor> createState() => _Signup2MentorState();
}

class _Signup2MentorState extends State<Signup2Mentor> {
  final _formKey = GlobalKey<FormState>();

  final _licenseNumberController = TextEditingController();
  final _issuingAuthorityController = TextEditingController();
  final _licenseExpiryDateController = TextEditingController();
  final _highestDegreeController = TextEditingController();
  final _universityController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _clinicnameController = TextEditingController();
  final _clinicadressController = TextEditingController();
  final _sessionChargeController = TextEditingController();
  final _upiId = TextEditingController();

  final List<String> specializations = [
    'Psychology', 'Career Guidance', 'Counseling', 'Wellness', 'Other', 'Life Coaching'
  ];
  List<String> specializationAreas = [];

  final List<String> languages = ['English', 'Hindi', 'Malayalam'];
  List<String> languagesSpoken = [];

  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> _availabledays = [];

  Map<String, List<String>> selectedTimeSlots = {};

  bool _isTermsAccepted = false;
  bool _isPrivacyPolicyAccepted = false;
  bool isLoading = false;  // Loading state

  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
          // Check if both terms and privacy policy are accepted
      if (!_isTermsAccepted || !_isPrivacyPolicyAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must agree to the Terms and Privacy Policy.')),
        );
        return;
      }

      setState(() {
        isLoading = true;  // Start loading
      });

      final formData = {
        'license_number': _licenseNumberController.text,
        'issuing_authority': _issuingAuthorityController.text,
        'license_expiry_date': _licenseExpiryDateController.text,
        'highest_degree': _highestDegreeController.text,
        'university': _universityController.text,
        'years_of_experiences': _yearsOfExperienceController.text,
        'clinic_name': _clinicnameController.text,
        'clinic_address': _clinicadressController.text,
        'session_price': _sessionChargeController.text,
        'upiId': _upiId.text,
        'available_days': _availabledays,
        'consultation_slots': selectedTimeSlots,
        'specialization_areas': specializationAreas,
        'languages_spoken': languagesSpoken,
        'agreed_to_terms': _isTermsAccepted,
        'agreed_to_privacy_policy': _isPrivacyPolicyAccepted,
      };

      try {
        final response = await ApiServicesMentorPost.postRequest(
          'mentors/signup/professional/${widget.mentorId}/',
          formData,
        );
        print(response);
        if (response.containsKey('message')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Signup3Mentor(mentorId: widget.mentorId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'Signup failed. Please try again.'),
          ));
        }
      } catch (e) {
        print('Network error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again later.')),
        );
      } finally {
        setState(() {
          isLoading = false;  // Stop loading
        });
      }
    }
  }

  @override
  void dispose() {
    _licenseNumberController.dispose();
    _issuingAuthorityController.dispose();
    _licenseExpiryDateController.dispose();
    _yearsOfExperienceController.dispose();
    _highestDegreeController.dispose();
    _universityController.dispose();
    _clinicnameController.dispose();
    _clinicadressController.dispose();
    _sessionChargeController.dispose();
    _upiId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mentor Professional Info")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Professional Details", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              TextFormField(
                controller: _licenseNumberController,
                decoration: inputDecoration('License Number'),
                validator: (value) => value!.isEmpty ? 'Please enter your license number' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _issuingAuthorityController,
                decoration: inputDecoration('Issuing Authority'),
                validator: (value) => value!.isEmpty ? 'Please enter your issuing authority' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _licenseExpiryDateController,
                readOnly: true,
                decoration: inputDecoration('License Expiry Date').copyWith(suffixIcon: const Icon(Icons.calendar_month)),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _licenseExpiryDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
                validator: (value) => value!.isEmpty ? 'Select your license expiry date' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _highestDegreeController,
                decoration: inputDecoration('Highest Degree'),
                validator: (value) => value!.isEmpty ? 'Please enter your highest degree' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _universityController,
                decoration: inputDecoration('University'),
                validator: (value) => value!.isEmpty ? 'Please enter your university' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _yearsOfExperienceController,
                decoration: inputDecoration('Years of Experience'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter your years of experience' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _clinicnameController,
                decoration: inputDecoration('Clinic Name'),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _clinicadressController,
                decoration: inputDecoration('Clinic Address'),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _sessionChargeController,
                decoration: inputDecoration('Session Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter your amount to get paid' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _upiId,
                decoration: inputDecoration('Upi ID'),
                validator: (value) => value!.isEmpty ? 'Please enter your Upi Id' : null,
              ),
              const SizedBox(height: 20),

              buildMultiSelectTile("Available Days", _availabledays, days, (results) => setState(() => _availabledays = results)),

              if (_availabledays.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Select Available Time Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                buildTimeSlotSelector(),
              ],

              const SizedBox(height: 20),
              buildMultiSelectTile("Specializations", specializationAreas, specializations, (results) => setState(() => specializationAreas = results)),
              buildMultiSelectTile("Languages Spoken", languagesSpoken, languages, (results) => setState(() => languagesSpoken = results)),

              const SizedBox(height: 10),

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

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
              const SizedBox(height: 10,),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMultiSelectTile(String title, List<String> selectedItems, List<String> allItems, Function(List<String>) onSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(selectedItems.isEmpty ? 'Select $title' : selectedItems.join(', ')),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () async {
          final results = await showDialog<List<String>>(
            context: context,
            builder: (context) => MultiSelectDialog(items: allItems, initiallySelected: selectedItems),
          );
          if (results != null) onSelected(results);
        },
      ),
    );
  }

  Widget buildTimeSlotSelector() {
    return Column(
      children: _availabledays.map((day) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.teal),
              onPressed: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  setState(() {
                    selectedTimeSlots.putIfAbsent(day, () => []);
                    selectedTimeSlots[day]!.add(
                      "${pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod}:${pickedTime.minute.toString().padLeft(2, '0')} ${pickedTime.period == DayPeriod.am ? 'AM' : 'PM'}",
                    );
                  });
                }
              },
            ),
          ),
          Wrap(
            spacing: 8,
            children: selectedTimeSlots[day]?.map((time) => Chip(
              label: Text(time),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  selectedTimeSlots[day]?.remove(time);
                });
              },
            )).toList() ?? [],
          ),
          const SizedBox(height: 10),
        ],
      )).toList(),
    );
  }
}
