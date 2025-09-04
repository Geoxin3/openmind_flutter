import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:openmind_flutter/State_Provider_All/Base_url.dart';

class ApiServicesUserGet {
  // Base URL of your API (replace with your actual API URL)
  static const String baseUrl = Apibaseurl.baseUrl;

  // GET method
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    final Uri url = Uri.parse(baseUrl + endpoint);

    try {
      // Sending the GET request
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Handling the response based on status code
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        return json.decode(response.body);
      } else {
        // If the server returns an error, return the error message
        return {'error': 'Failed to fetch data: ${response.statusCode}'};
      }
    } catch (e) {
      // In case of a network error or any exception
      return {'error': 'Network error: $e'};
    }
  }
}
