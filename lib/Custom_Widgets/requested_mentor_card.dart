import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:openmind_flutter/User/Models/Mentor_model.dart';

class RequestedMentorCard extends StatelessWidget {
  final MentorRequest mentorRequest;

  const RequestedMentorCard({super.key, required this.mentorRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 12,
                  spreadRadius: 3,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Top Row: Avatar, Name + Status, Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: (mentorRequest.profilepicture != null &&
                              mentorRequest.profilepicture!.isNotEmpty)
                          ? NetworkImage('${Apibaseurl.baseUrl2}${mentorRequest.profilepicture}')
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: (mentorRequest.profilepicture == null || mentorRequest.profilepicture!.isEmpty)
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 14),

                    /// Name & Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mentorRequest.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: setStatusColor(mentorRequest.status),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black26, width: 0.5),
                            ),
                            child: Text(
                              'Status: ${mentorRequest.status}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Date
                    Text(
                      TimeFormat.formatDate(mentorRequest.createdat),
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// --- Notes
                if (mentorRequest.notes != null && mentorRequest.notes!.isNotEmpty) ...[
                  Text(
                    'Notes: ${mentorRequest.notes}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                ],

                /// --- Day, Time & Session Status
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      mentorRequest.selectedday != null
                          ? 'Day: ${mentorRequest.selectedday}'
                          : 'Day: Not selected',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 18, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      mentorRequest.selectedtimeslot != null
                          ? 'Time: ${mentorRequest.selectedtimeslot}'
                          : 'Time: Not selected',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// --- Session Status
                if (mentorRequest.status.toUpperCase() != 'REJECTED')
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: mentorRequest.hasPayment!
                            ? mentorRequest.isSessionEnded
                                ? Colors.green.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: mentorRequest.hasPayment!
                              ? mentorRequest.isSessionEnded
                                  ? Colors.green
                                  : Colors.orange
                              : Colors.red,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            mentorRequest.hasPayment!
                                ? (mentorRequest.isSessionEnded
                                    ? Icons.check_circle
                                    : Icons.timelapse)
                                : Icons.cancel,
                            size: 16,
                            color: mentorRequest.hasPayment!
                                ? (mentorRequest.isSessionEnded ? Colors.green : Colors.orange)
                                : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            mentorRequest.hasPayment!
                                ? (mentorRequest.isSessionEnded ? 'Completed' : 'Session Ongoing')
                                : 'Not Paid Yet',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: mentorRequest.hasPayment!
                                  ? (mentorRequest.isSessionEnded ? Colors.green : Colors.orange)
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color setStatusColor(String status) {
    switch (status) {
      case 'ACCEPTED':
        return Colors.green.shade300;
      case 'REJECTED':
        return Colors.red.shade300;
      case 'PENDING':
        return Colors.yellow.shade300;
      default:
        return Colors.grey.shade300;
    }
  }
}
  