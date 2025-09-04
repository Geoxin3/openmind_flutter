//mentor class
class Mentor {

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
  final String sessionPrice;
  final String? averageRating;
  final List<String> specialization;
  final List<String> language;
  //seprate model class for these tables in django
  final List<Availabledays> availabledays;
  final List<RatingsandReview> ratingsandreview;
  
  //constructor
  Mentor({
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
    this.averageRating,
    required this.specialization,
    required this.language,
    required this.availabledays,
    required this.ratingsandreview,
  });

  //body
  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
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
      averageRating: json['average_rating'],
      specialization: List<String>.from(json['specialization']),
      language: List<String>.from(json['languages']),
      availabledays: (json['available_days'] as List<dynamic>).map((e) => Availabledays.fromJson(e)).toList(),
      ratingsandreview: (json['review_and_rating'] as List<dynamic>).map((e) => RatingsandReview.fromJson(e)).toList(),
    );
  }

}

//availabledays class
class Availabledays {

  final int? id;
  final String availabledays;
  final List<String> consultationslots;

  //constructors
  Availabledays({
     this.id,
    required this.availabledays,
    required this.consultationslots
    });

  //body
  factory Availabledays.fromJson(Map<String, dynamic> json) {
    return Availabledays(
      id: json['id'],
      availabledays: json['available_days'],
      consultationslots: (json['consultation_slots'] as List<dynamic>).map((e) => e.toString()).toList(),

    );
  }

}

//rating and review class
class RatingsandReview {

  final int? id;
  final int? userid;
  final String? user;
  final String? profilepicture;
  final int? rating;
  final String? review;
  final String? createdat; 

  //constructor
  RatingsandReview({
    this.id,
    this.userid,
    this.user,
    this.profilepicture,
    this.rating,
    this.review,
    this.createdat
  });

  //body
  factory RatingsandReview.fromJson(Map<String, dynamic> json) {
    return RatingsandReview(
      id: json['id'],
      userid: json['user_id'],
      user: json['user__full_name'],
      profilepicture: json['user__profile_picture'],
      rating: json['rating'],
      review: json['review'],
      createdat: json['created_at']
    );
  }

}

//mentor request class
class MentorRequest {

 final int id;
 final int? userid;
 final int? mentorid;
 final String name;
 final String? profilepicture;
 final String status;
 final String? notes;
 final String? selectedday;
 final String? selectedtimeslot;
 final String createdat;
 final String? sessionPrice;
 final bool? hasPayment;
 final bool isSessionEnded;

 //constructor
 MentorRequest({
  required this.id,
  this.userid,
  this.mentorid,
  required this.name,
  this.profilepicture,
  required this.status,
  this.notes,
  this.selectedday,
  this.selectedtimeslot,
  required this.createdat,
  this.sessionPrice,
  this.hasPayment,
  required this.isSessionEnded
 });

  //body
  factory MentorRequest.fromJson(Map<String, dynamic> json) {
    return MentorRequest(
      id: json['id'],
      userid: json['user_id'],
      mentorid: json['mentor_id'],
      name: json['name'],
      profilepicture: json['profile_picture'],
      status: json['status'],
      notes: json['notes'],
      selectedday: json['selected_day'],
      selectedtimeslot: json['selected_time_slot'],
      createdat: json['created_at'],
      sessionPrice: json['session_price'],
      hasPayment: json['has_payment'],
      isSessionEnded: json['issession_complete']
    );
  }
  
}
