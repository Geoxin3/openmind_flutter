import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:openmind_flutter/User/Screens/My%20Mentors/Requested_Mentors.dart';
import 'package:openmind_flutter/User/State_Provider_User/Bottom_Nav_State.dart';
import 'package:openmind_flutter/User/State_Provider_User/Home_user_state.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:provider/provider.dart';

class MainHomeUser extends StatefulWidget {
  const MainHomeUser({super.key});

  @override
  State<MainHomeUser> createState() => _MainHomeUserState();
}

class _MainHomeUserState extends State<MainHomeUser> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  Future<void> _onRefresh() async {
    final userid = context.read<IdProviders>().userid;
    await context.read<UserHomeProvider>().fetchUserHomedata(userid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserHomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
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
                    title: "Total Sessions",
                    icon: Icons.history_edu,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${provider.userHome?.completedSessions ?? 0} Completed sessions",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.check_circle, color: Colors.teal, size: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    title: "Latest Ongoing Session",
                    icon: Icons.timelapse_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Session with ${provider.userHome?.latestSessionMentorName ?? 'No mentor'}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Started on ${TimeFormat.formatDate(provider.userHome?.latestSessionStartedTime ?? '')}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: () {
                              context.read<BottomNavProviderUser>().setSelectedIndex(4);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const MyMentorsList()
                              //   ),
                              // );
                          }, child: const Text("View Details")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    title: "Pending Requests",
                    icon: Icons.pending_actions_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${provider.userHome?.latestPendingRequest?.length ?? 0} Requests Pending',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        if (provider.userHome?.latestPendingRequest?.isNotEmpty ?? false)
                          ...List.generate(
                            provider.userHome!.latestPendingRequest!.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(left: 10, bottom: 4),
                              child: Text("• Request to ${provider.userHome!.latestPendingRequest![index] ?? 'Unknown'}"),
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.only(left: 10, top: 6),
                            child: Text("No pending requests", style: TextStyle(color: Colors.grey)),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: () {
                            //calling this to navigate to the mymentorlist were the requestedmentors is located
                            context.read<BottomNavProviderUser>().setSelectedIndex(4);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RequestedMentors()
                                ),
                              );
                          }, child: const Text("Manage Requests")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    title: "Recently Reviewed Mentors",
                    icon: Icons.reviews_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRatingsAndReviews(provider.userHome?.latestReview ?? []),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: () {
                            //navigate to account view were reviews are
                            context.read<BottomNavProviderUser>().setSelectedIndex(0);
                          }, child: const Text("View All Reviews")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCard(
                    title: "Recommended for You",
                    icon: Icons.lightbulb_outline,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.self_improvement, color: Colors.deepPurple),
                      title: const Text("Mindfulness Tips"),
                      subtitle: const Text("Check out daily exercises for better focus."),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () {},
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
          const Text("Your Latest Reviews",
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
                                      review.mentor ?? 'Unknown',
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
