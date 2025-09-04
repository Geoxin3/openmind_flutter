import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/dialoguebox_multiselect.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:provider/provider.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Accounts_State.dart';

class EditMentorProfile extends StatefulWidget {
  const EditMentorProfile({super.key});

  @override
  State<EditMentorProfile> createState() => _EditMentorProfileState();
}

class _EditMentorProfileState extends State<EditMentorProfile> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
  
    // Defer execution until after the first build is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accountProvider = Provider.of<AccountFunctions>(context, listen: false);
      accountProvider.initializeData();  // Call the function after build
    });
  }


  @override
  Widget build(BuildContext context) {
    final mentorid = Provider.of<IdProviders>(context, listen: false).mentorid;
    final provider = Provider.of<AccountFunctions>(context);
    final mentor = provider.mentorDetail;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: provider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.check, color: Colors.white),
            onPressed: provider.isLoading ? null : () => provider.saveProfile(context, mentorid),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: provider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: provider.selectedImage != null
                          ? FileImage(provider.selectedImage!)
                          : (mentor?.profilepicture != null && mentor!.profilepicture!.isNotEmpty
                              ? NetworkImage('${Apibaseurl.baseUrl2}${mentor.profilepicture}') as ImageProvider
                              : null),
                      child: (mentor?.profilepicture == null || mentor!.profilepicture!.isEmpty) &&
                              provider.selectedImage == null
                          ? const Icon(Icons.person, size: 70, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: provider.pickImage,
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Bio
              _buildSectionTitle('Bio'),
              _buildTextField(provider.bioController, 'Bio', maxLines: 3, icon: Icon(Icons.description)),

              // Basic Info
              _buildSectionTitle('Basic Info'),
              _buildTextField(provider.nameController, 'Full Name', validator: _validateField, icon: Icon(Icons.person)),
              _buildTextField(provider.emailController, 'Email', keyboardType: TextInputType.emailAddress, validator: _validateField, icon: Icon(Icons.email)),
              _buildTextField(provider.phoneNumberController, 'Phone', keyboardType: TextInputType.phone, validator: _validateField, icon: Icon(Icons.phone)),
              //_buildTextField(provider.dateOfBirthController, 'Date of Birth', keyboardType: TextInputType.datetime, validator: _validateField),
              _buildDateOfBirthField(provider.dateOfBirthController, 'Date of Birth'),
              _buildTextField(provider.sessionPriceController, 'Session Price',keyboardType: TextInputType.number, validator: _validateField, icon: Icon(Icons.price_change)),
              _buildTextField(provider.upiId, 'Upi Id', validator: _validateField, icon: Icon(Icons.credit_card)),

              // Password Section
              _buildSectionTitle('Change Password'),
              _buildPasswordField(provider.oldPasswordController, 'Current Password', isNewPassword: false),
              _buildPasswordField(provider.newPasswordController, 'New Password', isNewPassword: true),

              // Professional Info
              _buildSectionTitle('Professional Info'),
              _buildTextField(provider.degreeController, 'Highest Degree', validator: _validateField, icon: Icon(Icons.school)),
              _buildTextField(provider.universityController, 'University', validator: _validateField, icon: Icon(Icons.location_city)),
              //_buildTextField(provider.licenseExpiryController, 'License Expiry Date', validator: _validateField),
              //same date picker
              _buildDateOfBirthField(provider.licenseExpiryController, 'License Expiry Date'),
              _buildTextField(provider.experienceController, 'Years of Experience', keyboardType: TextInputType.number, validator: _validateField, icon: Icon(Icons.timelapse)),
              _buildTextField(provider.clinicNameController, 'Clinic Name', maxLines: 2, icon: Icon(Icons.local_hospital)),
              _buildTextField(provider.clinicAddressController, 'Clinic Address', maxLines: 3, icon: Icon(Icons.location_on)),
              
              //django ManyToMany fields
              _buildMultiSelectTile('Specializations', provider.specializationAreas, provider.specializations, provider.updateSpecializations),
              _buildMultiSelectTile('Languages Spoken', provider.languagesSpoken, provider.languages, provider.updateLanguages),

            ],
          ),
        ),
      ),
    );
  }

  //helper functions
  //build the heading for each item 
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
    );
  }

  // Date of Birth Picker
  Widget _buildDateOfBirthField(TextEditingController controller, String  text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_month),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000), // Set initial date (can be changed)
            firstDate: DateTime(1900), // The earliest year
            lastDate: DateTime.now(), // Can't pick a future date
          );
          if (pickedDate != null) {
            setState(() {
              controller.text = '${pickedDate.toLocal()}'.split(' ')[0]; // Format date
            });
          }
        },
        validator: (value) => value == null ? 'Please select your date' : null,
      ),
    );
  }

  //build text field function
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator, int maxLines = 1, Icon? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(),
          suffixIcon: icon
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, {bool isNewPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isNewPassword ? _obscureNewPassword : _obscureOldPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              isNewPassword ? (_obscureNewPassword ? Icons.visibility_off : Icons.visibility)
                          : (_obscureOldPassword ? Icons.visibility_off : Icons.visibility),
            ),
            onPressed: () {
              setState(() {
                if (isNewPassword) {
                  _obscureNewPassword = !_obscureNewPassword;
                } else {
                  _obscureOldPassword = !_obscureOldPassword;
                }
              });
            },
          ),
        ),
        validator: (value) {
          if (isNewPassword) {
            if (_currentPasswordEntered() && (value == null || value.isEmpty)) {
              return 'New password is required';
            }
          }
          return null;
        },
      ),
    );
  }

  bool _currentPasswordEntered() {
    return context.read<AccountFunctions>().oldPasswordController.text.isNotEmpty;
  }

  String? _validateField(String? value) {
    return (value == null || value.isEmpty) ? 'This field is required' : null;
  }

  Widget _buildMultiSelectTile(String title, List<String> selectedItems, List<String> allItems, Function(List<String>) onSelected) {
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

}
