import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:openmind_flutter/State_Provider_All/Base_url.dart';

class ApiServicesMentorPost {
  //base url of mentor
  //for emultaor 10.0.2.2:8000
  //for web 127.0.0.1:8000
  static const String baseUrl = Apibaseurl.baseUrl;
  
  //POST method
  static Future<Map<String, dynamic>> postRequest (String endpoint, Map<String, dynamic> data) async {
    //merging baseurl of mentor and endpoint of a request
    final Uri url = Uri.parse(baseUrl + endpoint);

    try {
      //encoding th data for post request
      final response = await http.post(url,
      headers: {'Content-Type': 'application/json',},
      body: json.encode(data),
      );

    //parse the response
      Map<String, dynamic> responseBody = json.decode(response.body);
  
      if (response.statusCode == 200) {
        //returning response
        return responseBody;
      } else if (responseBody.containsKey('error')) {
        //returning the server response error
        return {'error': responseBody['error']}; 
      } else {
        //generic error
        return {'error': 'Failed to connect Server: ${response.statusCode}'};
      }
      
    } catch (e){
      return {'error': 'Network error: $e'};
    }
  }
}