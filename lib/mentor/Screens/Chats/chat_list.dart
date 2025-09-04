import 'package:flutter/material.dart';
import 'package:openmind_flutter/Mentor/Screens/Chats/chat_room_screen.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Chat_related_functions.dart';
import 'package:provider/provider.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  String selectedStatus = 'ONGOING'; // Filter options
  String? selectedPaymentFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _onRefresh();
    });
  }

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
          'Message Patients',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Consumer<Chatservice>(
        builder: (context, chatService, child) {
          if (chatService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final acceptedUsers = chatService.accepedUsers;

          final filteredUsers = acceptedUsers?.where((user) {
            final requestStatus = user['request_status'];
            final hasPayment = user['has_payment'];
            final status = requestStatus == true ? 'COMPLETED' : 'ONGOING';
            final paymentStatus = hasPayment ? 'PAID' : 'NOT_PAID';
            // print('is completed status${user['request_status'] == true}');
            // print('has payment${user['has_payment']}');
            final matchStatus = selectedStatus == 'ALL' || selectedStatus == status;
            final matchPayment = selectedPaymentFilter == null || paymentStatus == selectedPaymentFilter;

            return matchStatus && matchPayment;
          }).toList();

          return Column(
            children: [
              const SizedBox(height: 18),
              _buildStatusFilterChips(),
              const SizedBox(height: 10),
              const Divider(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: (filteredUsers == null || filteredUsers.isEmpty)
                      ? ListView(
                          children: [
                            const SizedBox(height: 200),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.sentiment_very_dissatisfied,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
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
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomScreenMentor(
                                      name: user['user_fullname'],
                                      profilepicture: user['profile_picture'],
                                      roomName: '${user['mentor_id']}${user['user_id']}',
                                      isComplete: user['request_status'] == true,
                                      isPaid: user['has_payment'], 
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
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
                                      backgroundImage: (user['profile_picture'] != null &&
                                              user['profile_picture'].isNotEmpty)
                                          ? NetworkImage('${Apibaseurl.baseUrl2}${user['profile_picture']}')
                                          : null,
                                      backgroundColor: Colors.grey[300],
                                      child: (user['profile_picture'] == null || user['profile_picture'].isEmpty)
                                          ? const Icon(Icons.person, size: 40, color: Colors.white)
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
                                    Icon(user['request_status'] == true ? Icons.lock : Icons.message, size: 22, color: Colors.grey),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
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
            onPressed: _showPaymentFilterModal,
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
