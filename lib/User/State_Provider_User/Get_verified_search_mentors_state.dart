import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/API_Services/API_Get.dart';
import 'package:async/async.dart'; // For debounce

class VerifiedMentorProvider with ChangeNotifier {
  List<dynamic> _mentors = [];
  bool _isLoading = false;

  List<dynamic> get mentors => _mentors;
  bool get isLoading => _isLoading;

  CancelableOperation? _debounce;

  // Method to fetch mentors
  Future<void> fetchMentors(String? searchQuery) async {
    // If a previous search is still ongoing, cancel it.
    _debounce?.cancel();

    // Start the loading state
    _isLoading = true;
    notifyListeners();

    // Debounce logic
    _debounce = CancelableOperation.fromFuture(
      Future.delayed(const Duration(milliseconds: 500), () async {
        try {
          final endpoint = searchQuery != null && searchQuery.isNotEmpty
              ? 'mentors/get_verified_mentors/?search=$searchQuery'
              : 'mentors/get_verified_mentors/';

          //api response
          final response = await ApiServicesUserGet.getRequest(endpoint);

          if (response.containsKey('error')) {
            throw Exception('Failed to load mentors: ${response['error']}');
          }
          
          _mentors = response['mentors'];
          _isLoading = false;
          notifyListeners();
          
        } catch (e) {

          print('Error: $e');
          _isLoading = false;
          notifyListeners();
        }
      }),
    );
  }
  
}
