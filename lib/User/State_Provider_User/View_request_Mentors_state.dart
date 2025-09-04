import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/API_Services/API_Get.dart';
import 'package:openmind_flutter/User/API_Services/API_Post.dart';
import 'package:openmind_flutter/User/Models/Mentor_model.dart';

class DetailedViewOfMentors with ChangeNotifier{

  //model class for mentor details
  Mentor? _mentorDetils;
  bool _isLoading = false;
  
  //textediting controllers for the mentors profile page 
  //these are used in same class
  final TextEditingController _reviewController = TextEditingController();
  String? _selectedDay;
  String? _selectedTime;
  num _selectedRating = 0;
  bool _isaccepted = false;
  bool _hasActiverequest = false;

  //setter for time slots (Day and Time) and rating
  set selectedDay(String? newday) {
    _selectedDay = newday;
    notifyListeners();
  }

  set selectedTime(String? newtime) {
    _selectedTime = newtime;
    notifyListeners();
  }

  set selectedRating(num rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  //getter for text editing controllers
  TextEditingController get reviewController => _reviewController;
  String? get selectedDay => _selectedDay;
  String? get selectedTime => _selectedTime;
  num get selectedRating => _selectedRating;
  bool get isaccepted => _isaccepted;
  bool get hasActiverequest => _hasActiverequest;

  //getters
  Mentor? get mentorDetils => _mentorDetils;
  bool get isLoading => _isLoading;

  //method to fetch detailed view of mentor
  Future<void> fetchMentordetails(int mentorid) async {
    
    //loading state
    _mentorDetils = null;
    _isLoading = true;
    //clean(); //calling this method for clearing day, time and rating slots 
    //not necessary calling this here while requesting
    //called this while navigating to the profile page
    //get verified mentors  
    notifyListeners();

    try {
      //api endpoint
      final endpoint = 'mentors/get_detailed_view_of_mentor/$mentorid/';

      //api response
      final response = await ApiServicesUserGet.getRequest(endpoint);
      
      //if the response contains an error key  
      if(response.containsKey('error')) {
        throw Exception('Failed to load:${response['error']}');
      }

      //directly assigning the returned dictionary to the mentor model
      _mentorDetils = Mentor.fromJson(response);
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to make a request
  Future<void> requestMentor(int mentorid, int? userid, String? notes, String? selectedday, String? selectedtimeslot) async{
      
    //loading state    
    _isLoading = true;
    notifyListeners();
    
    try {
      //api endpoint
      const endpoint = 'mentors/request_mentor/';

      //mentor id, user id and optional notes 
      final data = {
        'mentor_id': mentorid,
        'user_id': userid,
        'notes': notes,
        'selected_day': selectedday,
        'selected_time_slot': selectedtimeslot};

      //api response
      final response = await ApiServicesUserPost.postRequest(endpoint, data);

      //if the response contains an error key  
      if(response.containsKey('error')) {
        throw Exception('${response['error']}');
      }
      
    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  //model class for requested mentor
  List<MentorRequest>? _requestedmentor;

  //getter
  List<MentorRequest>? get requestedmentors => _requestedmentor;

  //method to view my mentor request
  Future<void> viewmymentors(int? userid) async {

    //loading state
    _requestedmentor = null;
    _isLoading = true;
    notifyListeners();

    try {

      //api endpoint
      final endpoint = 'mentors/view_requested_mentors/$userid/';

      //api response
      final response = await ApiServicesUserGet.getRequest(endpoint);

      //if the api response has an error returned
      if(response.containsKey('error')) {
        throw Exception('${response['error']}') ;     
      }

      //handling the the response assignig the returned list 
      //to each MentorRequest objects
      if(response.containsKey('requests')) {
        var requestlist = response['requests'] as List;
        _requestedmentor = requestlist.map((data) => MentorRequest.fromJson(data)).toList();
      } else {
        _requestedmentor = null;
      }

      //stop loading
      _isLoading = false;
      notifyListeners();
      
    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  //method to submit the review 
  Future<void> submitReview(int? userid, int mentorid, String? reviewnote, num? starrating) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      const endpoint = 'mentors/submit_review_and_rating/';

      final data = {
        'user_id': userid,
        'mentor_id': mentorid,
        'review_note': reviewnote,
        'star_rating': starrating
        };

      final response = await ApiServicesUserPost.postRequest(endpoint, data);

      if (response.containsKey('message')) {
        //calling the fetchmentor details when response is success
        await fetchMentordetails(mentorid);
      }
      //error handle

      //stop loading
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method to check if the user has a previous request with this mentor if does then checks if it was accepted
  Future<void> isThisMymentor(int mentorid, int? userid) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {

      //api endpoint
      final endpoint = 'mentors/is_this_my_mentor/$mentorid/$userid';

      final response = await ApiServicesUserGet.getRequest(endpoint);

      if(response.containsKey('is_accepted')) {
        _isaccepted = response['is_accepted'];
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

  //method to check if the user has already an active or uncompleted session
  Future<void> checkMentorRequestforPayment(int mentorid, int? userid) async {
  
    //loading state
    _isLoading = true;
    notifyListeners();

    try {

      //api endpoint
      final endpoint = 'mentors/check_active_mentor_request/$mentorid/$userid';

      final response = await ApiServicesUserGet.getRequest(endpoint);

      if(response.containsKey('has_active_request')) {
        _hasActiverequest = response['has_active_request'];
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

  //this method is for clearing all data while navigating to different mentor profile
  void clean() {
     _mentorDetils = null;
    _reviewController.clear();
    _selectedDay = null;
    _selectedTime = null;
    _selectedRating = 0;
    notifyListeners();
  }

  //dispose method to clean up controllers when no longer needed
  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

}