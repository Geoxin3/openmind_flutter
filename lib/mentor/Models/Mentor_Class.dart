import 'package:openmind_flutter/User/Models/Mentor_model.dart';

//mentor model class used to show mentor profile
//this model varies from og model class of mentor from user
//for available days and specilzation from user class used
class MentorProfile {

  //variables
  final int? id;
  final String fullname;
  final String? profilepicture;
  final String? bio;
  final int? yearsofexperiences;
  final String accountcreatedat;
  final String highestDegree;
  final String? clinicName;
  final String? clinicAddress; 
  final String? averageRating;
  final String? sessionPrice;
  final String? upiId;
  final List<String> specialization;
  final List<String> language;
  
  //new profile edit values 
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? licenseExpiryDate;
  final String? university;

  //seprate model class for these tables in django
  final List<Availabledays> availabledays;
  final List<RatingsandReview> ratingsandreview;

  //constructor
  MentorProfile({
    this.id,
    required this.fullname,
    this.profilepicture,
    this.bio,
    this.yearsofexperiences,
    required this.accountcreatedat,
    required this.highestDegree,
    required this.clinicName,
    required this.clinicAddress,
    required this.sessionPrice,
    required this.upiId,
    this.averageRating,
    required this.specialization,
    required this.language,
    //new
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.licenseExpiryDate,
    required this.university,

    required this.availabledays,
    required this.ratingsandreview,
  });

  //body
  factory MentorProfile.fromJson(Map<String, dynamic> json) {
    return MentorProfile(
      id: json['id'],
      fullname: json['full_name'],
      profilepicture: json['profile_picture'],
      bio: json['bio'],
      yearsofexperiences: json['years_of_experiences'],
      accountcreatedat: json['created_at'],
      highestDegree: json['highest_degree'],
      clinicName: json['clinic_name'],
      clinicAddress: json['clinic_address'],
      sessionPrice: json['session_price'],
      upiId: json['upiId'],
      averageRating: json['average_rating'],
      //new
      email: json['email'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      licenseExpiryDate: json['license_expiry_date'],
      university: json['university'],

      specialization: List<String>.from(json['specialization']),
      language: List<String>.from(json['languages']),
      availabledays: (json['available_days'] as List<dynamic>).map((e) => Availabledays.fromJson(e)).toList(),
      ratingsandreview: (json['review_and_rating'] as List<dynamic>).map((e) => RatingsandReview.fromJson(e)).toList(),
    );
  }

}

//class for storing upcoming session data list of obj
class UpcomingSession {
  final String user;
  final String datetime;

  UpcomingSession({
    required this.user,
    required this.datetime,
  });

  factory UpcomingSession.fromJson(Map<String, dynamic> json) {
    return UpcomingSession(
      user: json['user'],
      datetime: json['datetime'],
    );
  }
}

//class for mentor home data
class MentorHome {

  final String? lifeTimeEarnings;
  final String? pendingPayout;
  final String? monthlyPayout;
  final int? activeSessions;
  final List<UpcomingSession> upcomingSession;
  final int? pendingRequests;
  final String? pendingRequestsUserName;
  final String? averageRating;
  final int? reviewCount;
  final List<RatingsandReview>? latestReview;

  MentorHome({
    this.lifeTimeEarnings,
    this.pendingPayout,
    this.monthlyPayout,
    this.activeSessions,
    required this.upcomingSession,
    this.pendingRequests,
    this.pendingRequestsUserName,
    this.averageRating,
    this.reviewCount,
    this.latestReview
  });

  factory MentorHome.fromJson(Map<String, dynamic> json) {

    var upcomingList = json['upcoming_session'] as List<dynamic>? ?? [];
      List<UpcomingSession> upcomingSessions = upcomingList
      .map((sessionJson) => UpcomingSession.fromJson(sessionJson))
      .toList();
    
    var reviewsFromJson = json['latest_reviews'] as List? ?? [];
    List<RatingsandReview> reviewsList = reviewsFromJson.map((reviewJson) => RatingsandReview.fromJson(reviewJson)).toList();

    return MentorHome(
      lifeTimeEarnings: json['life_time_earnings'],
      pendingPayout: json['pending_payout'],
      monthlyPayout: json['monthly_payout'],
      activeSessions: json['active_sessions'],
      upcomingSession: upcomingSessions,
      pendingRequests: json['pending_requests_count'],
      pendingRequestsUserName: json['pending_request_user_name'],
      averageRating: json['average_rating'],
      reviewCount: json['review_count'],
      latestReview: reviewsList
    );
  }

}
