import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/User/API_Services/API_Get.dart';
import 'package:openmind_flutter/User/Models/User_model.dart';

class AccountUserFunctions with ChangeNotifier {

  bool _isLoading = false;
  //model class type
  User? _userDetails;

  //getters
  bool get isLoading => _isLoading;
  User? get userDetails => _userDetails;

  //method to fetch user profile data
  Future<void> fetchUserDetails(int? userid) async {

    //loading state
    _userDetails = null;
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      final endpoint = 'users/view_profile/$userid/';

      //api response
      final response = await ApiServicesUserGet.getRequest(endpoint);

      //if the response contains an error key  
      if(response.containsKey('error')) {
        throw Exception('Failed to load:${response['error']}');
      }

      //directly assigning the returned dictionary to the model class
      _userDetails = User.fromJson(response);
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //profile update variables and methods
  //form validation key
  final _formKey = GlobalKey<FormState>();
  
  //controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  //image 
  File? _selectedImage;

  //getters
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get dateOfBirthController => _dateOfBirthController;
  TextEditingController get bioController => _bioController;
  TextEditingController get emailController => _emailController;
  TextEditingController get oldPasswordController => _oldPasswordController;
  TextEditingController get newPasswordController => _newPasswordController;
  File? get selectedImage => _selectedImage;
  
  //method for initstate to initialize the data into textediting controllers
  void initializeData() {
    //initializing model
    final user = userDetails;
    _nameController = TextEditingController(text: user?.fullname);
    _phoneNumberController = TextEditingController(text: user?.phoneNumber);
    _dateOfBirthController = TextEditingController(text: user?.dateOfBirth);
    _bioController = TextEditingController(text: user!.bio);
    _emailController = TextEditingController(text: user.email);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    notifyListeners();
  }

  //method to pick image from gallery
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }
  
  //method to validate the form, shows snackbar and make call the api function
  void saveProfile(BuildContext context , int? userid) {
    if (_formKey.currentState!.validate()) {
      try {
        updateUserProfile(
          userid,
          _nameController.text,
          _emailController.text,
          _phoneNumberController.text,
          _bioController.text,
          _oldPasswordController.text,
          _newPasswordController.text,
          _dateOfBirthController.text,
          _selectedImage
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
      notifyListeners();
    }
  }

  //method to update user profile api
  Future<void> updateUserProfile(
    int? userid,
    String fullName,
    String email,
    String phoneNumber,
    String bio,
    String oldPassword,
    String newPassword,
    String dateOfBirth,
    File? profilePicture, //image
  ) async {
    
   //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      const endpoint = 'users/update_user_profile/';

      //for multipart request
      final url = Uri.parse('${Apibaseurl.baseUrl}$endpoint');

      var request = http.MultipartRequest('POST', url);

      //textfields
      final data = {
        'user_id': userid.toString(),
        //basic
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'date_of_birth': dateOfBirth,
        'bio': bio,
      };

      //passing password only if they are not empty
      if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
        data['old_password'] = oldPassword;
        data['new_password'] = newPassword;
      }

      request.fields.addAll(data);  

      //adds profile picture if available
      if (profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicture.path,
        ));
      }

      //api response
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      print(responseData.body);
      if (responseData.statusCode == 200) {
        //calling the fetch user details for state change
        await fetchUserDetails(userid);
      } else {
        throw Exception('Failed to update profile: ${responseData.body}');
      }

      //loading state
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //disposing controllers when not using
  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  //method to clear the prevoius data model class
  void clean() {
    _userDetails = null;
    notifyListeners();
  }

}