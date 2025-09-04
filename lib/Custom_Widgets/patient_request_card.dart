import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Requested_patients.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:openmind_flutter/User/Models/Mentor_model.dart';
import 'package:provider/provider.dart';

class PatientRequestCard extends StatelessWidget {
  final MentorRequest request;

  const PatientRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestedPatients>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile and Name
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: request.profilepicture != null && request.profilepicture!.isNotEmpty
                    ? NetworkImage('${Apibaseurl.baseUrl2}${request.profilepicture}')
                    : null,
                  backgroundColor: Colors.grey[300],
                  child: (request.profilepicture == null || request.profilepicture!.isEmpty)
                    ? const Icon(Icons.person, size: 36, color: Colors.white)
                    : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            request.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          
                          const Spacer(),
                          Text(TimeFormat.formatDate(request.createdat), style:const TextStyle(fontWeight: FontWeight.w400),)
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Time Slot: ${request.selectedday} ${request.selectedtimeslot}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notes
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Note: ${request.notes ?? 'No notes provided'}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[900],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reject Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await provider.updateRequestStatus(request.id, 'REJECTED');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Accept Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await provider.updateRequestStatus(request.id, 'ACCEPTED');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
