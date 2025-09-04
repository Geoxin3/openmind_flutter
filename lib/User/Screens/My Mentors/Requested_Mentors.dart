import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/requested_user_card.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:openmind_flutter/User/State_Provider_User/View_request_Mentors_state.dart';
import 'package:provider/provider.dart';

class RequestedMentors extends StatefulWidget {
  const RequestedMentors({super.key});

  @override
  State<RequestedMentors> createState() => _RequestedMentorsState();
}

class _RequestedMentorsState extends State<RequestedMentors> {
  String selectedStatus = 'ALL'; // ALL, PENDING, ACCEPTED, REJECTED
  String? selectedPaymentFilter; // PAID, NOT_PAID
  String? selectedSessionFilter; // COMPLETED, ONGOING

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int? userId = context.read<IdProviders>().userid;
      context.read<DetailedViewOfMentors>().viewmymentors(userId);
    });
  }

  Future<void> _refreshMentors() async {
    final int? userId = context.read<IdProviders>().userid;
    await context.read<DetailedViewOfMentors>().viewmymentors(userId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetailedViewOfMentors>();
    final allRequests = provider.requestedmentors ?? [];

    //Combined filter logic
    final filteredRequests = allRequests.where((request) {
      final matchesStatus = selectedStatus == 'ALL' || request.status == selectedStatus;
      final matchesPayment = selectedPaymentFilter == null ||
          (selectedPaymentFilter == 'PAID' && request.hasPayment == true) ||
          (selectedPaymentFilter == 'NOT_PAID' && request.hasPayment == false);
      final matchesSession = selectedSessionFilter == null ||
          (selectedSessionFilter == 'COMPLETED' && request.isSessionEnded == true) ||
          (selectedSessionFilter == 'ONGOING' && request.isSessionEnded == false);

      return matchesStatus && matchesPayment && matchesSession;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text("Requested Mentors", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white,),
            tooltip: "More Filters",
            onPressed: _showPaymentFilterModal,
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 18),
                _buildStatusFilterChips(),
                const SizedBox(height: 10),
                const Divider(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshMentors,
                    child: filteredRequests.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 200),
                              Center(child: Text("No matching mentor requests found.")),
                            ],
                          )
                        : ListView.builder(
                            itemCount: filteredRequests.length,
                            itemBuilder: (context, index) {
                              final request = filteredRequests[index];
                              return RequestedUserCard(mentorRequest: request);
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatusFilterChips() {
    final statuses = ['ALL', 'PENDING', 'ACCEPTED', 'REJECTED'];
    return SizedBox(
      height: 42,
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
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87),
            backgroundColor: Colors.grey[200],
          );
        },
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
              const Text("Payment Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: const Text("Paid"),
                    selected: selectedPaymentFilter == 'PAID',
                    onSelected: (_) {
                      setState(() => selectedPaymentFilter = selectedPaymentFilter == 'PAID' ? null : 'PAID');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text("Not Paid"),
                    selected: selectedPaymentFilter == 'NOT_PAID',
                    onSelected: (_) {
                      setState(() => selectedPaymentFilter = selectedPaymentFilter == 'NOT_PAID' ? null : 'NOT_PAID');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Session Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: const Text("Completed"),
                    selected: selectedSessionFilter == 'COMPLETED',
                    onSelected: (_) {
                      setState(() => selectedSessionFilter = selectedSessionFilter == 'COMPLETED' ? null : 'COMPLETED');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text("Ongoing"),
                    selected: selectedSessionFilter == 'ONGOING',
                    onSelected: (_) {
                      setState(() => selectedSessionFilter = selectedSessionFilter == 'ONGOING' ? null : 'ONGOING');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedPaymentFilter = null;
                      selectedSessionFilter = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Clear Filters"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
