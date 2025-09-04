import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/mentor_card.dart';
import 'package:openmind_flutter/Custom_Widgets/search_box.dart';
import 'package:openmind_flutter/User/Screens/Searchs/View_request_Mentors.dart';
import 'package:openmind_flutter/User/State_Provider_User/Get_verified_search_mentors_state.dart';
import 'package:openmind_flutter/User/State_Provider_User/View_request_Mentors_state.dart';
import 'package:provider/provider.dart';

class SearchMentors extends StatefulWidget {
  const SearchMentors({super.key});

  @override
  State<SearchMentors> createState() => _SearchMentorsState();
}

class _SearchMentorsState extends State<SearchMentors> {
  late final TextEditingController _searchfield;

  @override
  void initState() {
    super.initState();
    _searchfield = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMentors();
    });
  }

  void _fetchMentors([String? query]) {
    context.read<VerifiedMentorProvider>().fetchMentors(query?.trim());
  }

  @override
  void dispose() {
    _searchfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text("Search Mentors", style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.white
          ),),
        ),
        body: Column(
          children: [
            // Search Field (Now Below AppBar)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SearchField(
                autofocus: true,
                controller: _searchfield,
                hintText: 'Search ... ',
                onSearch: _fetchMentors,
              ),
            ),

            // Mentor List
            Expanded(
              child: Consumer<VerifiedMentorProvider>(
                builder: (context, provider, child) => _buildMentorList(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorList(VerifiedMentorProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    //no search result
    if (provider.mentors.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text(
            'No mentors found!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          const Text(
            'Try searching with different keywords',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _fetchMentors(),
      child: ListView.builder(
        itemCount: provider.mentors.length,
        itemBuilder: (context, index) {
          final mentor = provider.mentors[index];
          return MentorCard(
            mentor: mentor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestMentors(mentorId: mentor['mentor_id']),
                ),
              );
              context.read<DetailedViewOfMentors>().clean(); // Clears previous data
            },
          );
        },
      ),
    );
  }
}
