import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openmind_flutter/Mentor/API_Services/API_Get.dart';
import 'package:openmind_flutter/Mentor/Models/Mentor_Class.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';

class AccountFunctions with ChangeNotifier {

  bool _isLoading = false;
  //used model class for mentor profile update
  MentorProfile? _mentorDetail;
  String? _selectedDay;
  String? _selectedTime;

  //getters
  bool get isLoading => _isLoading; 
  MentorProfile? get mentorDetail => _mentorDetail; 
  String? get selectedDay => _selectedDay;
  String? get selectedTime => _selectedTime;

  //setters
  set selectedDay(String? day) {
    _selectedDay = day;
    notifyListeners();
  }

  set selectedTime(String? time) {
    _selectedTime = time;
    notifyListeners();
  }

  //method to fetch detailed view of mentor
  Future<void> fetchMentordetails(int? mentorid) async {
    
    //loading state
    _mentorDetail = null;
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      final endpoint = 'mentors/view_profile/$mentorid/';

      //api response
      final response = await ApiServicesMentorGet.getRequest(endpoint);

      //if the response contains an error key  
      if(response.containsKey('error')) {
        throw Exception('Failed to load:${response['error']}');
      }

      //directly assigning the returned dictionary to the mentor model
      _mentorDetail = MentorProfile.fromJson(response);
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
  
  final List<String> specializations = [
    'Psychology', 'Career Guidance', 'Counseling', 'Wellness', 'Other', 'Life Coaching'
  ];
  // Map specialization names to IDs
  final Map<String, String> specializationMap = {
    'Psychology': '1',
    'Career Guidance': '2',
    'Counseling': '3',
    'Wellness': '4',
    'Other': '5',
    'Life Coaching': '6',
  };

  //method to get selected specialization IDs
  List<String> getSelectedSpecializationIds(List<String> selectedNames) {
    return selectedNames.map((name) => specializationMap[name] ?? "").where((id) => id.isNotEmpty).toList();
  }
  //this variable is for ui update
  List<String> _specializationAreas = [];
  
  //languages spoken
  final List<String> languages = ['English', 'Hindi', 'Malayalam'];
  // Map specialization names to IDs
  final Map<String, String> languagesMap = {
    'English': '1',
    'Hindi': '2',
    'Malayalam': '3',
  };
  //method to get selected lanaguages IDs
  List<String> getSelectedLanguageIds(List<String> selectedNames) {
    return selectedNames.map((name) => languagesMap[name] ?? "").where((id) => id.isNotEmpty).toList();
  }
  List<String> _languagesSpoken = [];

  late TextEditingController _nameController;
  late TextEditingController _degreeController;
  late TextEditingController _bioController;
  late TextEditingController _experienceController;
  late TextEditingController _clinicNameController;
  late TextEditingController _clinicAddressController;
  late TextEditingController _emailController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _sessionPriceController;
  late TextEditingController _upiId;
  late TextEditingController _licenseExpiryController;
  late TextEditingController _universityController;
  //image 
  File? _selectedImage;

  //getters
  GlobalKey<FormState> get formKey => _formKey;
  List<String> get specializationAreas => _specializationAreas;
  List<String> get languagesSpoken => _languagesSpoken;
  TextEditingController get nameController => _nameController;
  TextEditingController get degreeController => _degreeController;
  TextEditingController get bioController => _bioController;
  TextEditingController get experienceController => _experienceController;
  TextEditingController get clinicNameController => _clinicNameController;
  TextEditingController get clinicAddressController => _clinicAddressController;
  TextEditingController get emailController=> _emailController;
  TextEditingController get oldPasswordController => _oldPasswordController;
  TextEditingController get newPasswordController=> _newPasswordController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get dateOfBirthController => _dateOfBirthController;
  TextEditingController get sessionPriceController => _sessionPriceController;
  TextEditingController get upiId => _upiId;
  TextEditingController get licenseExpiryController => _licenseExpiryController;
  TextEditingController get universityController => _universityController;
  File? get selectedImage => _selectedImage;

  //method for initstate to initialize the data into textediting controllers
  void initializeData() {
    //initializing the model
    final mentor = mentorDetail;
    _nameController = TextEditingController(text: mentor?.fullname);
    _degreeController = TextEditingController(text: mentor?.highestDegree);
    _bioController = TextEditingController(text: mentor?.bio);
    _experienceController = TextEditingController(text: mentor?.yearsofexperiences.toString());
    _clinicNameController = TextEditingController(text: mentor?.clinicName);
    _clinicAddressController = TextEditingController(text: mentor?.clinicAddress);
    _emailController = TextEditingController(text: mentor?.email);
    _sessionPriceController = TextEditingController(text: mentor?.sessionPrice);
    _upiId = TextEditingController(text: mentor?.upiId);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _phoneNumberController = TextEditingController(text: mentor?.phoneNumber);
    _dateOfBirthController = TextEditingController(text: mentor?.dateOfBirth);
    _licenseExpiryController = TextEditingController(text: mentor?.licenseExpiryDate);
    _universityController = TextEditingController(text: mentor?.university);

    //load mentor's existing specializations if available
    if (_mentorDetail?.specialization != null) {
      updateSpecializations(mentorDetail!.specialization);
    }
    //load mentor's existing lanaguages if available
    if (_mentorDetail?.language != null) {
      updateLanguages(mentorDetail!.language);
    }
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

  //method to update the selected specilazation
  void updateSpecializations(List<String> newSpecializations) {
    _specializationAreas = newSpecializations;
    notifyListeners();
  }

  //method to update the selected language
  void updateLanguages(List<String> newLanguages) {
    _languagesSpoken = newLanguages;
    notifyListeners();
  }

  //method to validate the form, shows snackbar and make call the api function
  void saveProfile(BuildContext context, int? mentorid) {
    if (_formKey.currentState!.validate()) {
      try {
        updateMentorProfile(
          mentorid,
          _nameController.text,
          _emailController.text,
          _phoneNumberController.text,
          _degreeController.text,
          _universityController.text,
          _bioController.text,
          _sessionPriceController.text,
          _upiId.text,
          _oldPasswordController.text,
          _newPasswordController.text,
          _experienceController.text,
          _clinicNameController.text,
          _clinicAddressController.text,
          _dateOfBirthController.text,
          _licenseExpiryController.text,
          _specializationAreas,
          _languagesSpoken,
          _selectedImage
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
        Navigator.pop(context, true);
        } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
      notifyListeners();
    }
  }

  //method to update the profile MultipartRequest
  Future<void> updateMentorProfile(
    int? mentorid,
    String fullName,
    String email,
    String phoneNumber,
    String highestDegree,
    String university,
    String bio,
    String sessionPrice,
    String upiId,
    String oldPassword,
    String newPassword,
    String yearsOfExperience,
    String clinicName,
    String clinicAddress,
    String dateOfBirth,
    String licenseExpiryDate,
    List<String> specialization,
    List<String> lanaguages,
    File? profilePicture, //image
  ) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      //api endpoint
      const endpoint = 'mentors/update_mentor_profile/';

      //for multipart request
      final url = Uri.parse('${Apibaseurl.baseUrl}$endpoint');

      var request = http.MultipartRequest('POST', url);

      //textfields
      final data = {
        'mentor_id': mentorid.toString(),
        //basic
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'date_of_birth': dateOfBirth,
        'bio':bio,
        //professional
        'highest_degree': highestDegree,
        'university': university,
        'session_price': sessionPrice,
        'upiId': upiId,
        'license_expiry_date': licenseExpiryDate,
        'years_of_experiences': yearsOfExperience,
        'specialization_areas': getSelectedSpecializationIds(specialization).join(','),
        'languages_spoken': getSelectedLanguageIds(lanaguages).join(','),
        'clinic_name': clinicName,
        'clinic_address': clinicAddress
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

      if (responseData.statusCode == 200) {
        //calling the fetch mentor details for state change
        await fetchMentordetails(mentorid);
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
    _degreeController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _clinicNameController.dispose();
    _clinicAddressController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _licenseExpiryController.dispose();
    _universityController.dispose();
    _sessionPriceController.dispose();
    _upiId.dispose();
    super.dispose();
  }

  //method to clear the prevoius data
  void clean() {
    _mentorDetail = null;
    _selectedDay = null;
    _selectedTime = null;
    notifyListeners();
  }

  
  //this class is not used now later in the modification time...
  // these methods are not used now
   
  //controllers
  // final _fullNameController = TextEditingController();
  // final _emailController = TextEditingController();
  // final _phoneNumberController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _dateOfBirthController = TextEditingController();

  // //form validate key
  // final _formKey = GlobalKey<FormState>();

  // //gender variable
  // String? _selectedGender;

  // int? _Mentor_id;

  // //method to submit the form
  // Future <void> submitForm() async {

  //   if(_formKey.currentState?.validate() ?? false) {

  //     final data = {
  //       'full_name': _fullNameController.text,
  //       'email': _emailController.text,
  //       'phone_number': _phoneNumberController.text,
  //       'password': _passwordController.text,
  //       'gender': _selectedGender,
  //       'date_of_birth': _dateOfBirthController.text,
  //     };

  //     try {
  //       //api endpoint
  //       const endpoint = 'mentors/signup/basic/';

  //       //response
  //       final response = await ApiServicesMentorPost.postRequest(endpoint, data);

  //       if(response.containsKey('mentor_id')) {
          
  //         _Mentor_id = response['mentor_id'];
  //         notifyListeners();
          
  //       }
  //     } catch(e) {
  //       print("Error:$e");

  //     }
  //   }
  // }
  
}