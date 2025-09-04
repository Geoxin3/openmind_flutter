import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/validation.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/User/State_Provider_User/Accounts_state.dart';
import 'package:provider/provider.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;

  @override
  void initState() {
    super.initState();
  
    // Defer execution until after the first build is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accountProvider = Provider.of<AccountUserFunctions>(context, listen: false);
      accountProvider.initializeData();  // Call the function after build
    });
  }

  @override
  Widget build(BuildContext context) {
    final userid = Provider.of<IdProviders>(context, listen: false).userid;
    final provider = Provider.of<AccountUserFunctions>(context);
    final user = provider.userDetails;

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
            onPressed: provider.isLoading ? null : () => provider.saveProfile(context, userid),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                            : (user?.profilepicture != null && user!.profilepicture!.isNotEmpty
                              ? NetworkImage('${Apibaseurl.baseUrl2}${user.profilepicture}') as ImageProvider
                              : null),
                        child: (user?.profilepicture == null || user!.profilepicture!.isEmpty) &&
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

                _buildSectionTitle('Bio'),
                _buildTextField(provider.bioController, 'Bio', maxLines: 3, icon: const Icon(Icons.description)),

                //basic info
                _buildSectionTitle('Basic Info'),
                _buildTextField(provider.nameController, 'Full name', validator: _validateField, icon: Icon(Icons.person)),
                _buildTextField(provider.emailController, 'Email', keyboardType: TextInputType.emailAddress, validator: Validator.validateEmail, icon: Icon(Icons.email)),
                _buildTextField(provider.phoneNumberController, 'Phone', keyboardType: TextInputType.phone, validator: Validator.validatePhoneNumber, icon: Icon(Icons.phone)),
                //_buildTextField(provider.dateOfBirthController, 'Date of Birth', keyboardType: TextInputType.datetime, validator: _validateField),
                _buildDateOfBirthField(provider.dateOfBirthController),
                // Password Section
                _buildSectionTitle('Change Password'),
                _buildPasswordField(provider.oldPasswordController, 'Current Password', isNewPassword: false),
                _buildPasswordField(provider.newPasswordController, 'New Password', isNewPassword: true),
                
                
              ],
            )
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

  //build textfield function
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator, int maxLines = 1, Icon? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(),
        suffixIcon: icon ?? null
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  // Date of Birth Picker
  Widget _buildDateOfBirthField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
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
        validator: (value) => value == null ? 'Please select your date of birth' : null,
      ),
    );
  }

  String? _validateField(String? value) {
    return (value == null || value.isEmpty) ? 'This field is required' : null;
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
    return context.read<AccountUserFunctions>().oldPasswordController.text.isNotEmpty;
  }

}