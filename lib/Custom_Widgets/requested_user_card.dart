import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:openmind_flutter/User/Models/Mentor_model.dart';
import 'package:openmind_flutter/State_Provider_All/Payment_Screen.dart';
import 'package:openmind_flutter/User/State_Provider_User/View_request_Mentors_state.dart';
import 'package:provider/provider.dart';

class RequestedUserCard extends StatelessWidget {
  final MentorRequest mentorRequest;

  const RequestedUserCard({super.key, required this.mentorRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Mentor Info Row ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: (mentorRequest.profilepicture != null &&
                              mentorRequest.profilepicture!.isNotEmpty)
                          ? NetworkImage('${Apibaseurl.baseUrl2}${mentorRequest.profilepicture}')
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: (mentorRequest.profilepicture == null || mentorRequest.profilepicture!.isEmpty)
                          ? const Icon(Icons.person, size: 30, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mentorRequest.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: setStatusColor(mentorRequest.status),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Status: ${mentorRequest.status}',
                                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                TimeFormat.formatDate(mentorRequest.createdat),
                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// --- Session Info ---
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text('Day: ${mentorRequest.selectedday ?? 'Not selected'}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text('Time: ${mentorRequest.selectedtimeslot ?? 'Not selected'}'),
                  ],
                ),
                const SizedBox(height: 10),
                if (mentorRequest.notes != null && mentorRequest.notes!.isNotEmpty)
                  Text(
                    'Notes: ${mentorRequest.notes}',
                    style: const TextStyle(color: Colors.black54),
                  ),

                const SizedBox(height: 20),

                // payment and session stauts
                Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (context) {
                      if (mentorRequest.status == 'PENDING') {
                        return const Text(
                          'Pay after mentor accepts the request',
                          style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500),
                        );
                      } else if (mentorRequest.status == 'ACCEPTED') {
                        if (mentorRequest.hasPayment == false) {
                          return GestureDetector(
                            onTap: () {
                              final paymentService = PaymentService();
                              paymentService.startPayment(
                                context: context,
                                userId: mentorRequest.userid,
                                mentorId: mentorRequest.mentorid,
                                fullname: mentorRequest.name,
                                sessionPrice: mentorRequest.sessionPrice!,
                                //state management calls the viewmymentor function
                                onPaymentComplete: () {
                                  Provider.of<DetailedViewOfMentors>(context, listen: false).viewmymentors(mentorRequest.userid);
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.payment, size: 18, color: Colors.blue),
                                  SizedBox(width: 6),
                                  Text('Pay Now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          );
                        } else if (mentorRequest.hasPayment == true && mentorRequest.isSessionEnded == false) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timelapse, size: 16, color: Colors.orange),
                                SizedBox(width: 6),
                                Text(
                                  'Session Ongoing',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (mentorRequest.hasPayment == true && mentorRequest.isSessionEnded == true) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 16, color: Colors.green),
                                SizedBox(width: 6),
                                Text(
                                  'Session Completed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink(); // Fallback
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to distribute colors based on status
  static Color setStatusColor(String status) {
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
