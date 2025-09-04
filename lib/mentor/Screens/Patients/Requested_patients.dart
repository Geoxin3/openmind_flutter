import 'package:flutter/material.dart';
import 'package:openmind_flutter/Custom_Widgets/patient_request_card.dart';
import 'package:openmind_flutter/Custom_Widgets/requested_mentor_card.dart';
import 'package:openmind_flutter/Mentor/State_Provider_Mentor/Requested_patients.dart';
import 'package:openmind_flutter/State_Provider_All/ID_providers.dart';
import 'package:provider/provider.dart';

class RequestedPatientsScreen extends StatefulWidget {
  const RequestedPatientsScreen({super.key});

  @override
  State<RequestedPatientsScreen> createState() => _RequestedPatientsScreenState();
}

class _RequestedPatientsScreenState extends State<RequestedPatientsScreen> {
  String selectedStatus = 'PENDING'; // 'ALL', 'PENDING', etc.
  String? selectedPaymentFilter; // 'PAID', 'NOT_PAID'
  String? selectedSessionStatus; // 'COMPLETED', 'ONGOING'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();  
    });
  }

  Future<void> _onRefresh() async {
    final mentorId = context.read<IdProviders>().mentorid;
    Provider.of<RequestedPatients>(context, listen: false).fetchmyPatients(mentorId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestedPatients>(context);
    final allRequests = [...(provider.pendingRequest ?? []), ...(provider.requesteduser ?? [])];

    final filteredRequests = allRequests.where((request) {
      final matchesStatus = selectedStatus == 'ALL' || request.status == selectedStatus;
      final matchesPayment = selectedPaymentFilter == null ||
          (selectedPaymentFilter == 'PAID' && request.hasPayment == true) ||
          (selectedPaymentFilter == 'NOT_PAID' && request.hasPayment == false);
      final matchesSession = selectedSessionStatus == null ||
          (selectedSessionStatus == 'COMPLETED' && request.isSessionEnded == true) ||
          (selectedSessionStatus == 'ONGOING' && request.isSessionEnded == false);
      return matchesStatus && matchesPayment && matchesSession;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text("Requested Patients", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white,),
            tooltip: "More Filters",
            onPressed: _showFilterModal,
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
                    onRefresh: _onRefresh,
                    child: filteredRequests.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                            const Center(child: Text("No matching patient requests found.", style: TextStyle(fontSize: 15),)),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                            itemCount: filteredRequests.length,
                            itemBuilder: (context, index) {
                              final request = filteredRequests[index];
                              return request.status == 'PENDING'
                                  ? PatientRequestCard(request: request)
                                  : RequestedMentorCard(mentorRequest: request);
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
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
            backgroundColor: Colors.grey[200],
          );
        },
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text("Payment Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: const Text("Paid"),
                    selected: selectedPaymentFilter == 'PAID',
                    onSelected: (_) {
                      setState(() =>
                          selectedPaymentFilter = selectedPaymentFilter == 'PAID' ? null : 'PAID');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text("Not Paid"),
                    selected: selectedPaymentFilter == 'NOT_PAID',
                    onSelected: (_) {
                      setState(() => selectedPaymentFilter =
                          selectedPaymentFilter == 'NOT_PAID' ? null : 'NOT_PAID');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Session Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: const Text("Ongoing"),
                    selected: selectedSessionStatus == 'ONGOING',
                    onSelected: (_) {
                      setState(() =>
                          selectedSessionStatus = selectedSessionStatus == 'ONGOING' ? null : 'ONGOING');
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text("Completed"),
                    selected: selectedSessionStatus == 'COMPLETED',
                    onSelected: (_) {
                      setState(() =>
                          selectedSessionStatus = selectedSessionStatus == 'COMPLETED' ? null : 'COMPLETED');
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
                      selectedSessionStatus = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Clear Filters"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
