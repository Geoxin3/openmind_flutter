import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/User/Screens/My%20Mentors/Requested_Mentors.dart';
import 'package:provider/provider.dart';
import 'package:openmind_flutter/User/State_Provider_User/View_request_Mentors_state.dart';

class RequestConsultationDialog extends StatefulWidget {
  final int mentorId;
  final String? selectedday;
  final String? selectedtimeslot;
  final String mentorPrice;

  const RequestConsultationDialog({
    super.key,
    required this.mentorId,
    this.selectedday,
    this.selectedtimeslot,
    required this.mentorPrice,
  });

  @override
  RequestConsultationDialogState createState() => RequestConsultationDialogState();
}

class RequestConsultationDialogState extends State<RequestConsultationDialog> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      //canPop: false, //disable android back button
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Request Consultation',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Row(
            //   children: [
            //     Icon(Icons.check_circle, color: Colors.green, size: 20),
            //     SizedBox(width: 8),
            //     Text(
            //       'Payment Successful',
            //       style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 12),
      
            const Text(
              'Are you sure you want to request a session?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
      
            if (widget.selectedday != null && widget.selectedtimeslot != null) ...[
              _buildInfoRow(Icons.calendar_today, "Date", widget.selectedday!, Colors.blue),
              _buildInfoRow(Icons.access_time, "Time Slot", widget.selectedtimeslot!, Colors.black54),
              _buildInfoRow(Icons.credit_card_rounded, "Pay in rupees", widget.mentorPrice, Colors.blueAccent),
              const SizedBox(height: 12),
            ],

            // const Divider(),

            // const Text(
            //   'You can pay the amount after the request  is accepted by mentor!',
            //   style: TextStyle(fontSize: 16),
            // ),

            // const SizedBox(height: 10,),

            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Optional Notes',
                hintText: 'Add any additional details for the mentor...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 6,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                backgroundColor: Colors.teal),
            onPressed: () async {
              final int? userId = context.read<IdProviders>().userid;
      
              try {
                await context.read<DetailedViewOfMentors>().requestMentor(
                      widget.mentorId,
                      userId,
                      _notesController.text,
                      widget.selectedday,
                      widget.selectedtimeslot,
                    );
      
                Navigator.pop(context);
      
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Consultation requested successfully!')),
                );
      
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const RequestedMentors()));
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            "$label - ",
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
