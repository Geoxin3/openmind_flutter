import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:openmind_flutter/User/Screens/Accounts/Edit_profile.dart';
import 'package:openmind_flutter/User/State_Provider_User/Accounts_state.dart';
import 'package:provider/provider.dart';

class ViewMYAccountUser extends StatefulWidget {
  const ViewMYAccountUser({super.key});

  @override
  State<ViewMYAccountUser> createState() => _ViewMYAccountUserState();
}

class _ViewMYAccountUserState extends State<ViewMYAccountUser> {

    @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  // Function to handle refresh
  Future<void> _onRefresh() async {
    Provider.of<AccountUserFunctions>(context, listen: false).clean();
    final userid = context.read<IdProviders>().userid;
    context.read<AccountUserFunctions>().fetchUserDetails(userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Consumer<AccountUserFunctions>(
          builder: (context, provider, _) {
            return const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Your Profile',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            );
          },
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>const EditUserProfile()));
          }, icon:const Icon(Icons.edit, color: Colors.white,))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Consumer<AccountUserFunctions>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
        
            final user = provider.userDetails;
        
            if (user == null) {
              return const Center(child: Text('Something went Wrong. Try again later'));
            }
        
            return SingleChildScrollView(
              child: Padding(
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
                              backgroundImage: user.profilepicture != null && user.profilepicture!.isNotEmpty
                                  ? NetworkImage('${Apibaseurl.baseUrl2}${user.profilepicture}')
                                  : null,
                              child: user.profilepicture == null || user.profilepicture!.isEmpty
                                  ? const Icon(Icons.person, size: 70, color: Colors.grey)
                                  : null,
                            ),
                          ),
        
                          const SizedBox(height: 10),
        
                          //name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                              user.fullname,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
                        (user.bio == null || user.bio!.isEmpty)
                        ? 'You havn`t added a bio yet.'
                        : user.bio!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    //email
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
                          const Text('Email',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 15),
                          //email
                          Row(children: [
                            const Icon(Icons.email, color: Colors.teal, size: 25),
                            const SizedBox(width: 8),
                            Expanded(child: Text(
                              (user.email.isEmpty)
                              ? 'No Email Provided.'
                              : user.email,
                              style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                            )),
                          ]),
                        ],
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    //phone number
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
                          const Text('Phone Number',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 15),
                          //phone
                          Row(children: [
                            const Icon(Icons.phone, color: Colors.green, size: 25),
                            const SizedBox(width: 8),
                            Expanded(child: Text(
                              (user.phoneNumber.isEmpty)
                              ? 'No Phone Number Provided.'
                              : '+91 ${user.phoneNumber}',
                              style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                            )),
                          ]),
                        ],
                      ),
                    ),
        
                    const SizedBox(height: 20,),
        
                    //date of birth
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
                          const Text('Date Of Birth',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 15),
                          //phone
                          Row(children: [
                            const Icon(Icons.cake, color: Colors.blue, size: 25),
                            const SizedBox(width: 8),
                            Expanded(child: Text(
                              (user.dateOfBirth.isEmpty)
                              ? 'No Date Of Birth Provided.'
                              : user.dateOfBirth,
                              style:const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                            )),
                          ]),
                        ],
                      ),
                    ),
        
                    const SizedBox(height: 10,),
                    // reviews by user of all mentors 
                    _buildRatingsAndReviews(provider.userDetails!.ratingsandreview)
                  ],
                ),
              ),
            );
        }),
      )
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

  // to build the reviews of mentors user gave
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
          "Reviewed Mentors",
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
                                    review.mentor ?? 'Anonymous',
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

}