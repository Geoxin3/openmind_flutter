
class User {

  //variables
  final int? id;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String? profilepicture;
  final String? bio;
  final List<RatingsandReviewMentor> ratingsandreview;

  //constructor
  User({
    this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    this.profilepicture,
    this.bio,
    required this.ratingsandreview
  });

  //body
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'], 
      dateOfBirth: json['date_of_birth'],
      profilepicture: json['profile_picture'],
      bio: json['bio'],
      ratingsandreview: (json['review_and_rating'] as List<dynamic>).map((e) => RatingsandReviewMentor.fromJson(e)).toList(),
    );
  }
  
}

//rating and review class
class RatingsandReviewMentor {

  final int? id;
  final int? mentorid;
  final String? mentor;
  final String? profilepicture;
  final int? rating;
  final String? review;
  final String? createdat; 

  //constructor
  RatingsandReviewMentor({
    this.id,
    this.mentorid,
    this.mentor,
    this.profilepicture,
    this.rating,
    this.review,
    this.createdat
  });

  //body
  factory RatingsandReviewMentor.fromJson(Map<String, dynamic> json) {
    return RatingsandReviewMentor(
      id: json['id'],
      mentorid: json['mentor_id'],
      mentor: json['mentor__full_name'],
      profilepicture: json['mentor__profile_picture'],
      rating: json['rating'],
      review: json['review'],
      createdat: json['created_at']
    );
  }

}

//user home data class 
class UserHome {

  final int? completedSessions;
  final String? latestSessionMentorName;
  final String? latestSessionStartedTime;
  final List<String>? latestPendingRequest;
  final List<RatingsandReviewMentor>? latestReview;

  UserHome({
    this.completedSessions,
    this.latestSessionMentorName,
    this.latestSessionStartedTime,
    this.latestPendingRequest,
    this.latestReview
  });

  //
  factory UserHome.fromJson(Map<String, dynamic> json) {

    var reviewsFromJson = json['latest_reviews'] as List? ?? [];
    List<RatingsandReviewMentor> reviewsList = reviewsFromJson.map((reviewJson) => RatingsandReviewMentor.fromJson(reviewJson)).toList();

    return UserHome(
      completedSessions: json['completed_session_count'],
      latestSessionMentorName: json['latest_ongoing_session_mentor_name'],
      latestSessionStartedTime: json['latest_ongoing_session_started_time'],
      latestPendingRequest: List<String>.from(json['latest_pending_requests'] ?? []),
      latestReview: reviewsList
    );
  }
}
