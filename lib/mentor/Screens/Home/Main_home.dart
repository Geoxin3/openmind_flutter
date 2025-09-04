import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/Screens/Patients/Requested_patients.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Bottom_Nav_State.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Home_mentor_State.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:provider/provider.dart';

class MainHomeMentor extends StatefulWidget {
  const MainHomeMentor({super.key});

  @override
  State<MainHomeMentor> createState() => _MainHomeMentorState();
}

class _MainHomeMentorState extends State<MainHomeMentor> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  Future<void> _onRefresh() async {
    final mentorid = context.read<IdProviders>().mentorid;
    await context.read<MentorHomeProvider>().fetchMentorHomedata(mentorid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MentorHomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = provider.homeDetails;
        //use tryparse to handle any null values.
        final double lifetimeEarnings = double.tryParse(data?.lifeTimeEarnings?.toString() ?? '0') ?? 0.0;
        final double monthlyPayout = double.tryParse(data?.monthlyPayout?.toString() ?? '0') ?? 0.0;

        //calculate progress as a ratio of monthly payout to lifetime earnings.
        //adjusts the result between 0.0 and 1.0 to ensure it's in range for the progress bar.
        final double progress = lifetimeEarnings > 0
          ? (monthlyPayout / lifetimeEarnings).clamp(0.0, 1.0)
          : 0.0;

        if (data == null) {
          return const Scaffold(
            body: Center(child: Text("No data available")),
          );
        }

        return Scaffold(
          // appBar: AppBar(
          //   title: const Text(
          //     'Welcome to Your Dashboard',
          //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          //   ),
          //   centerTitle: true,
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          //   iconTheme: const IconThemeData(color: Colors.black),
          // ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Your Dashboard', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    title: "Lifetime Earnings",
                    icon: Icons.monetization_on_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("₹${provider.homeDetails?.lifeTimeEarnings ?? 0}",
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Pending Payout",
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text("₹${data.pendingPayout}",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade300
                        ),
                        const SizedBox(height: 12),
                        Text("This Month’s Payout: ₹${data.monthlyPayout}",
                            style: const TextStyle(fontSize: 15, color: Colors.grey)),
                        const SizedBox(height: 50),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(onPressed: () {}, child: const Text("View All Earnings")),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    title: "Ongoing Sessions",
                    icon: Icons.event_available,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${data.activeSessions} Active",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                            const Icon(Icons.event_available, color: Colors.green, size: 28),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (data.upcomingSession.isEmpty)
                          const Text("No upcoming sessions"),
                        ...data.upcomingSession.map((session) => Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text("${session.datetime} with ${session.user}",
                                  style: const TextStyle(fontWeight: FontWeight.w500)),
                            )),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: () {
                            context.read<BottomNavProviderMentor>().setSelectedIndex(4);
                          }, child: const Text("View All Sessions")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    title: "Pending Requests",
                    icon: Icons.pending_actions_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${data.pendingRequests} New Request",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                            const Icon(Icons.pending_actions_rounded, color: Colors.orange, size: 28),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          (data.pendingRequestsUserName != null && data.pendingRequestsUserName!.trim().isNotEmpty)
                            ? "New request from ${data.pendingRequestsUserName} is waiting for your response"
                            : "No new requests at the moment",
                              style: const TextStyle(fontWeight: FontWeight.w500),
                        ),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: () {
                            context.read<BottomNavProviderMentor>().setSelectedIndex(4);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RequestedPatientsScreen()
                                ));
                          }, child: const Text("Go To Requests")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    title: "Reviews & Ratings",
                    icon: Icons.star_rate_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${data.averageRating} ",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                            const Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("${data.reviewCount ?? 0} Reviews",
                            style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        _buildRatingsAndReviews(data.latestReview ?? []),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: () {
                            context.read<BottomNavProviderMentor>().setSelectedIndex(0);
                          }, child: const Text("Manage Reviews")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({required String title, required Widget child, IconData? icon}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Icon(icon, color: Colors.teal, size: 22),
                if (icon != null)
                  const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStars(int? rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < (rating ?? 0) ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildRatingsAndReviews(List reviews) {
    reviews.sort((a, b) => b.createdat.compareTo(a.createdat));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Latest Reviews About you",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          reviews.isNotEmpty
              ? Column(
                  children: reviews.map((review) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.user ?? 'Unknown',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                          _buildStars(review.rating),
                          const SizedBox(height: 6),
                          Text(
                            review.review ?? 'No review provided.',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          Container(height: 1, color: Colors.grey.shade300),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No reviews available.',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ),
                ),
        ],
      ),
    );
  }
}
