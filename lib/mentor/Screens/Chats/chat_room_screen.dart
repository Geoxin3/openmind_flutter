import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/Base_url.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/State_Provider_All/Time_format.dart';
import 'package:provider/provider.dart';

class ChatRoomScreenMentor extends StatefulWidget {
  final String roomName;
  final String name;
  final String profilepicture;
  final bool isComplete;
  final bool isPaid;

  const ChatRoomScreenMentor({
    super.key,
    required this.roomName,
    required this.name,
    required this.profilepicture,
    required this.isComplete,
    required this.isPaid
  });

  @override
  State<ChatRoomScreenMentor> createState() => _ChatRoomScreenMentorState();
}

class _ChatRoomScreenMentorState extends State<ChatRoomScreenMentor> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final int? currentMentorId = context.watch<IdProviders>().mentorid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leadingWidth: 30,
        backgroundColor: Colors.teal.shade400,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: (widget.profilepicture.isNotEmpty)
                  ? NetworkImage('${Apibaseurl.baseUrl2}${widget.profilepicture}')
                  : null,
              backgroundColor: Colors.grey[300],
              child: (widget.profilepicture.isEmpty)
                  ? const Icon(Icons.person, size: 30, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: const Text(
              'You can send text messages only.',
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.roomName)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet. Start the conversation!'));
                }

                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByMentor = currentMentorId != null && message['senderId'] == currentMentorId;

                    // Extract timestamp and formating
                    final Timestamp? timestamp = message['timestamp'] as Timestamp?;
                    final String formattedTime = TimeFormat.formatTimestamp(timestamp);

                    return Row(
                      mainAxisAlignment: isSentByMentor ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75, // Prevents overflow
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isSentByMentor ? Colors.blue[100] : Colors.grey[300],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['content'],
                                  style: const TextStyle(fontSize: 16),
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedTime,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          
          // Message Input Section (Always visible but may be disabled)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (!widget.isPaid)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${widget.name} Has not made the payment yet.',
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (widget.isComplete)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'This session is ended.',
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade400),
                          color: (!widget.isPaid || widget.isComplete) ? Colors.grey.shade200 : Colors.white,
                        ),
                        child: TextField(
                          controller: _messageController,
                          enabled: widget.isPaid && !widget.isComplete,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (widget.isPaid && !widget.isComplete) {
                          _sendMessage(_messageController.text.trim(), currentMentorId);
                          _messageController.clear();
                        }
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: (widget.isPaid && !widget.isComplete) ? Colors.teal : Colors.grey,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to send messages
  void _sendMessage(String content, int? currentUserId) async {
    if (content.isEmpty || currentUserId == null) return;

    final messagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.roomName)
        .collection('messages');

    await messagesCollection.add({
      'senderId': currentUserId,
      'content': content,
      'type': 'text',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('chats').doc(widget.roomName).set({
      'lastMessage': content,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

}
