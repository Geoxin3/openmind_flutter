import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/Screens/Patients/Patient_dairy.dart';
import 'package:openmind_flutter/Mentor/Screens/Patients/Requested_patients.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:provider/provider.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Chat_related_functions.dart';

class PatientMainPage extends StatefulWidget {
  const PatientMainPage({super.key});

  @override
  PatientMainPageState createState() => PatientMainPageState();
}

class PatientMainPageState extends State<PatientMainPage> {
  String selectedStatus = 'ONGOING'; // Filter options for status (ONGOING, COMPLETED, ALL)
  String? selectedPaymentFilter; // New filter for payment status

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  // Refresh Function
  Future<void> _onRefresh() async {
    final mentorId = context.read<IdProviders>().mentorid;
    context.read<Chatservice>().getacceptedUsers(mentorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Accepted Patients',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestedPatientsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<Chatservice>(
        builder: (context, chatService, child) {
          if (chatService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final acceptedUsers = chatService.accepedUsers;

          // Filtering logic based on selectedStatus and selectedPaymentFilter
          final filteredUsers = acceptedUsers?.where((user) {
            final requestStatus = user['request_status'];
            final hasPayment = user['has_payment'];

            // Determine user status (COMPLETED or ONGOING)
            final status = requestStatus == true ? 'COMPLETED' : 'ONGOING';
            // Determine payment status (PAID or NOT PAID)
            final paymentStatus = hasPayment != null ? 'PAID' : 'NOT PAID';

            // Apply status and payment filter conditions
            final matchStatus = selectedStatus == 'ALL' || selectedStatus == status;
            final matchPayment = selectedPaymentFilter == null || paymentStatus == selectedPaymentFilter;

            return matchStatus && matchPayment;
          }).toList();

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: Column(
              children: [
                const SizedBox(height: 18),
                _buildStatusFilterChips(), // Filter for mentor status (ONGOING, COMPLETED)
                const SizedBox(height: 10),
                const Divider(),
                Expanded(
                  child: filteredUsers == null || filteredUsers.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                            Icon(Icons.sentiment_very_dissatisfied, size: 48, color: Colors.grey),
                            const SizedBox(height: 10,),
                            const Center(child: Text('No ongoing sessions found.', style: TextStyle(fontSize: 16, color: Colors.grey))),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDairy(user: user),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: user['profile_picture'] != null &&
                                              user['profile_picture'].isNotEmpty
                                          ? NetworkImage('${Apibaseurl.baseUrl2}${user['profile_picture']}')
                                          : null,
                                      backgroundColor: Colors.grey[300],
                                      child: (user['profile_picture'] == null || user['profile_picture'].isEmpty)
                                          ? const Icon(Icons.person, size: 36, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['user_fullname'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.email, size: 16, color: Colors.grey),
                                              const SizedBox(width: 6),
                                              Text(
                                                user['user_email'],
                                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'View') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TaskDairy(user: user),
                                            ),
                                          );
                                        } else if (value == 'Report') {
                                          print('Report clicked for ${user['user_fullname']}');
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                          value: 'View',
                                          child: Row(
                                            children: [
                                              Icon(Icons.remove_red_eye, color: Colors.blue, size: 18),
                                              SizedBox(width: 10),
                                              Text('View Details'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'Report',
                                          child: Row(
                                            children: [
                                              Icon(Icons.report_problem_outlined, color: Colors.red, size: 18),
                                              SizedBox(width: 10),
                                              Text('Report This Patient'),
                                            ],
                                          ),
                                        ),
                                      ],
                                      child: const Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build the status filter chips (ONGOING, COMPLETED, ALL)
  Widget _buildStatusFilterChips() {
    final statuses = ['ALL', 'ONGOING', 'COMPLETED'];
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: statuses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = statuses[index];
                final isSelected = selectedStatus == status;

                return ChoiceChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedStatus = status),
                  selectedColor: Colors.teal,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  backgroundColor: Colors.grey[200],
                );
              },
            ),
          ),
          // Icon button to show payment filter modal
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.teal),
            onPressed: () => _showPaymentFilterModal(),
          ),
        ],
      ),
    );
  }

  // Show the payment filter modal (PAID, NOT PAID)
  void _showPaymentFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                "Payment Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: const Text("Paid"),
                    selected: selectedPaymentFilter == 'PAID',
                    onSelected: (_) {
                      setState(() {
                        selectedPaymentFilter = selectedPaymentFilter == 'PAID' ? null : 'PAID';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text("Not Paid"),
                    selected: selectedPaymentFilter == 'NOT_PAID',
                    onSelected: (_) {
                      setState(() {
                        selectedPaymentFilter = selectedPaymentFilter == 'NOT_PAID' ? null : 'NOT_PAID';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedPaymentFilter = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Clear Filter"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
