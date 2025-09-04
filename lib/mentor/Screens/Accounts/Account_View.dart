import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openmind_flutter/Mentor/Models/Mentor_Class.dart';
import 'package:openmind_flutter/Mentor/Screens/Accounts/Edit_profile.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Accounts_State.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:provider/provider.dart';

class ViewMyAccountMentor extends StatefulWidget {
  const ViewMyAccountMentor({super.key});

  @override
  State<ViewMyAccountMentor> createState() => _ViewMyAccountMentorState();
}

class _ViewMyAccountMentorState extends State<ViewMyAccountMentor> {
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  //function to handle refresh
  Future<void> _onRefresh() async {
    Provider.of<AccountFunctions>(context, listen: false).clean();
    final mentorid = context.read<IdProviders>().mentorid;
    context.read<AccountFunctions>().fetchMentordetails(mentorid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Consumer<AccountFunctions>(
          builder: (context, provider, _) {
            return const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('Your Profile',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            );
          },
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>const EditMentorProfile()));
          }, icon:const Icon(Icons.edit, color: Colors.white,))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Consumer<AccountFunctions>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
        
            final mentor = provider.mentorDetail;
        
            if (mentor == null) {
              return const Center(child: Text('Something went Wrong. Try again later'));
            }
        
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
        
                        //profile picture
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300)
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: mentor.profilepicture != null && mentor.profilepicture!.isNotEmpty
                                ? NetworkImage('${Apibaseurl.baseUrl2}${mentor.profilepicture}')
                                : null,
                            child: mentor.profilepicture == null || mentor.profilepicture!.isEmpty
                                ? const Icon(Icons.person, size: 70, color: Colors.grey)
                                : null,
                          ),
                        ),
        
                        const SizedBox(height: 10),
        
                        //name and badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mentor.fullname,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6,),
                            const Icon(Icons.verified, color: Colors.blue,)
                          ],
                        ),
        
                        const SizedBox(height: 5),
        
                        //highest degree
                        Text(mentor.highestDegree, style:const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500
                        ),),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  //bio
                  _buildSectionTitle('Bio'),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      (mentor.bio == null || mentor.bio!.isEmpty)
                      ? 'This Mentor hasn’t added a bio yet.'
                      : mentor.bio!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  //experience and average ratings
                  Container(
                    width: double.infinity, // Full width
                    padding: const EdgeInsets.all(12), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures space between the two sections
                      children: [
                        // Total Experience Section
                        Row(children: [
                          const Icon(Icons.work, color: Colors.brown),
                          const SizedBox(width: 8),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Experience',
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              Text("${mentor.yearsofexperiences}+ Years",
                                style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ]),
                        // Rating Section
                        Row(children: [
                          const Icon(Icons.star, color: Colors.amber), // Star icon
                          const SizedBox(width: 8),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Avearge Rating',
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              Text("${mentor.averageRating}  (${mentor.ratingsandreview.length})",
                                style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ]),  
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 20),
                  
                  //specializations
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Specializations',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 15),
                        mentor.specialization.isNotEmpty
                          ? Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: mentor.specialization.map((spec) => Container(
                              padding:const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                spec,
                                style:const TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            )).toList(),
                          )
                          : const Text('Not Specialized', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  //languages spoken
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ 
                        const Text('Languages Spoken',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        mentor.language.isNotEmpty
                          ? Column(
                              children: mentor.language.map((lang) => Container(
                              margin:const EdgeInsets.symmetric(vertical: 5),
                              padding:const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                const Icon(Icons.language, color: Colors.blue, size: 18),
                                const SizedBox(width: 8),
                                Expanded(child: Text(
                                  lang,
                                  style:const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                                )),
                              ]),
                            )).toList(),
                          )
                          :const Text('No languages specified', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  //clinic information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Title
                        const Text('Clinic Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 15),
                        // Clinic Name
                        Row(children: [
                          const Icon(Icons.local_hospital, color: Colors.blue, size: 25),
                          const SizedBox(width: 8),
                          Expanded(child: Text(
                            (mentor.clinicName == null || mentor.clinicName!.isEmpty)
                            ? 'No Clinic Name Provided.'
                            : mentor.clinicName!,
                            style:const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                          )),
                        ]),
                        const SizedBox(height: 15),
        
                        // Clinic Address
                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, color: Colors.redAccent, size: 25),
                            const SizedBox(width: 8),
                            Expanded(child: Text(
                              (mentor.clinicAddress == null || mentor.clinicAddress!.isEmpty)
                              ? 'No Clinic Address Provided'
                              : mentor.clinicAddress!,
                              style:const TextStyle(fontSize: 15, color: Colors.black54),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  //available days
                  _buildSectionTitle('Available days'),
                  const SizedBox(height: 20,),
                  //custom time slot selctor can only select and view 
                  customTimeslotPicker(provider, mentor),
            
                  //view all ratings and reviews
                  _buildRatingsAndReviews(mentor.ratingsandreview),
        
              ]),
            );
          },
        ),
      ),
    );
  }

  //helper functions
  
  //to build the title 
  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600));
  }

  //to build rating star 
  Widget _buildStars(int? rating) {
    return Row(
      children: List.generate(
          5, (index) => Icon(index < (rating ?? 0) ? Icons.star : Icons.star_border, color: Colors.amber)),
    );
  }

  // to build the reviews of other user about the mentor
  Widget _buildRatingsAndReviews(List reviews) {
  // Sort reviews by date (newest first)
  reviews.sort((a, b) => b.createdat.compareTo(a.createdat));

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Section Title
        const Text(
          "Reviews About you",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        // Divider for separation
        Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 10),

        // Display Reviews
        reviews.isNotEmpty
            ? Column(
                children: reviews.map((review) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Picture
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: review.profilepicture != null && review.profilepicture.isNotEmpty
                                  ? NetworkImage('${Apibaseurl.baseUrl2}${review.profilepicture}')
                                  : null,
                              backgroundColor: Colors.grey[300],
                              child: (review.profilepicture == null || review.profilepicture.isEmpty)
                                  ? const Icon(Icons.person, size: 26, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 12),

                            // Name & Date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.user ?? 'Anonymous',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    TimeFormat.formatDate(review.createdat),
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Star Rating
                        _buildStars(review.rating),

                        const SizedBox(height: 6),

                        // Review Text
                        Text(
                          review.review ?? 'No review provided.',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),

                        const SizedBox(height: 10),

                        // Subtle divider
                        Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No reviews available.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
      ],
    ),
  );
}
  
  //avilable day and time picker
  Widget customTimeslotPicker(AccountFunctions provider, MentorProfile mentor) {
  DateTime today = DateTime.now();

  // Generate the week's days with dates
  List<Map<String, String>> fullWeek = List.generate(7, (index) {
    DateTime date = today.add(Duration(days: index));
    return {
      "day": DateFormat('EEEE').format(date), // Full day name (Monday, Tuesday)
      "date": DateFormat('d').format(date) // Numeric date (4, 5, 6...)
    };
  });

  // Extract available days and their slots from mentor data
  Map<String, List<String>> availableTimesByDay = {
    for (var daySlot in mentor.availabledays)
      daySlot.availabledays: daySlot.consultationslots
  };

  return Column(
    children: [
      // Days selector
      SizedBox(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: fullWeek.map((dayData) {
            String day = dayData["day"]!;
            String date = dayData["date"]!;
            bool isAvailable = availableTimesByDay.containsKey(day);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: isAvailable
                    ? () {
                        provider.selectedDay = day;
                        provider.selectedTime = null;
                      }
                    : null,
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: provider.selectedDay == day
                        ? Colors.teal
                        : isAvailable
                            ? Colors.white
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.substring(0, 3), // Mon, Tue
                        style: TextStyle(
                          color: isAvailable
                              ? (provider.selectedDay == day ? Colors.white : Colors.black)
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        date,
                        style: TextStyle(
                          color: isAvailable
                              ? (provider.selectedDay == day ? Colors.white : Colors.black)
                              : Colors.grey,
                          fontSize: 16,fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),

      const SizedBox(height: 20),

      // Show time slots for the selected day
      if (provider.selectedDay != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Time Slots",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _generateTimeSlots(
                provider.selectedDay!,
                availableTimesByDay,
                provider,
              ),
            ),
          ],
        ),
    ],
  );
}

// Function to generate time slots, including mentor's custom slots
  List<Widget> _generateTimeSlots(
  String selectedDay,
  Map<String, List<String>> availableTimesByDay,
  AccountFunctions provider,
) {
  List<String> fixedTimeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM",
    "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"
  ];

  List<String> mentorSlots = availableTimesByDay[selectedDay] ?? [];

  // Merge and sort all available time slots
  List<String> allSlots = [...fixedTimeSlots, ...mentorSlots];
  allSlots.sort((a, b) => _compareTime(a, b));

  return allSlots.map((slot) {
    bool isAvailable = mentorSlots.contains(slot);

    return GestureDetector(
      onTap: isAvailable
          ? () {
              provider.selectedTime = slot;
            }
          : null,
      child: Container(
        height: 40,
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: provider.selectedTime == slot
              ? Colors.teal.shade300
              : isAvailable
                  ? Colors.white
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(10)),
        child: Text(
          slot,
          style: TextStyle(
            color: isAvailable
                ? (provider.selectedTime == slot ? Colors.white : Colors.black)
                : Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }).toList();
}

// Helper function to sort time slots correctly in generateTimeSots
  int _compareTime(String timeA, String timeB) {
  DateFormat format = DateFormat("h:mm a");

  try {
    DateTime parsedA = format.parse(timeA);
    DateTime parsedB = format.parse(timeB);
    return parsedA.compareTo(parsedB);
  } catch (e) {
    return 0; // Fallback if parsing fails
  }
}

}
