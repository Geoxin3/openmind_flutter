import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';

class MentorCard extends StatelessWidget {
  final Map<String, dynamic> mentor;
  final VoidCallback onTap;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String specializationText = (mentor['specialization'] is List)
        ? mentor['specialization'].join(', ')
        : mentor['specialization']?.toString() ?? 'No Specialization';

    bool isSpecializationLong = specializationText.length > 40;
    String displayedSpecialization =
        isSpecializationLong ? '${specializationText.substring(0, 40)}...' : specializationText;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and Name/Rating
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: mentor['profile_picture'] != null && mentor['profile_picture'].isNotEmpty
                      ? NetworkImage('${Apibaseurl.baseUrl2}${mentor['profile_picture']}')
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: (mentor['profile_picture'] == null || mentor['profile_picture'].isEmpty)
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              mentor['full_name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, color: Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${mentor['average_rating'] ?? 0.0}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Specialization
            Row(
              children: [
                const Icon(Icons.psychology_outlined, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    displayedSpecialization,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Experience
            Row(
              children: [
                const Icon(Icons.work_history, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  '${mentor['years_of_experiences'] ?? '0'}+ Years of Experience',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Price Tag
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 20, color: Colors.teal),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Session Price: ₹${mentor['session_price'] ?? '0'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                label: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
