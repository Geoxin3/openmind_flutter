import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/Screens/Chats/chat_room_screen.dart';
import 'package:openmind_flutter/User/State_Provider_User/chat_releated_functions.dart';
import 'package:provider/provider.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';

class ChatListScreenUser extends StatefulWidget {
  const ChatListScreenUser({super.key});

  @override
  ChatListScreenUserState createState() => ChatListScreenUserState();
}

class ChatListScreenUserState extends State<ChatListScreenUser> {
  String selectedStatus = 'ONGOING';
  String? selectedPaymentFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = context.read<IdProviders>().userid;
      context.read<ChatServiceUser>().getacceptedMentors(userId);
    });
  }

  Future<void> _onRefresh() async {
    final userId = context.read<IdProviders>().userid;
    await context.read<ChatServiceUser>().getacceptedMentors(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Message Mentors',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Consumer<ChatServiceUser>(
        builder: (context, chatService, child) {
          if (chatService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final acceptedMentors = chatService.accepedMentors;

          final filteredMentors = acceptedMentors?.where((mentor) {
            final requestStatus = mentor['request_status'];
            final hasPayment = mentor['has_payment'];

            final status = requestStatus == true ? 'COMPLETED' : 'ONGOING';
            final paymentStatus = hasPayment ? 'PAID' : 'NOT PAID';

            final matchStatus = selectedStatus == 'ALL' || selectedStatus == status;
            final matchPayment = selectedPaymentFilter == null || paymentStatus == selectedPaymentFilter;

            return matchStatus && matchPayment;
          }).toList();

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: Column(
              children: [
                const SizedBox(height: 18),
                _buildStatusFilterChips(),
                const SizedBox(height: 10),
                const Divider(),
                Expanded(
                  child: filteredMentors == null || filteredMentors.isEmpty
                      ? ListView(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                          children: const [
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.sentiment_very_dissatisfied, size: 48, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text(
                                    'No ongoing sessions found.',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          itemCount: filteredMentors.length,
                          itemBuilder: (context, index) {
                            final mentor = filteredMentors[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomScreenUser(
                                      name: mentor['mentor_fullname'],
                                      profilepicture: mentor['profile_picture'],
                                      roomName: '${mentor['mentor_id']}${mentor['user_id']}',
                                      isComplete: mentor['request_status'] == true,
                                      hasPayment: mentor['has_payment'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade200, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: (mentor['profile_picture'] != null &&
                                              mentor['profile_picture'].isNotEmpty)
                                          ? NetworkImage('${Apibaseurl.baseUrl2}${mentor['profile_picture']}')
                                          : null,
                                      backgroundColor: Colors.grey[300],
                                      child: (mentor['profile_picture'] == null || mentor['profile_picture'].isEmpty)
                                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mentor['mentor_fullname'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Tap to start a chat',
                                            style: TextStyle(fontSize: 14, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chat, size: 22, color: Colors.grey),
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
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.teal),
            onPressed: () => _showPaymentFilterModal(),
          ),
        ],
      ),
    );
  }

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
