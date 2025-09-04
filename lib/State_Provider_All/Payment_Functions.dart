import 'package:flutter/material.dart';
import 'package:openmind_flutter/User/API_Services/API_Post.dart';

class PaymentProvider with ChangeNotifier {

   bool _isLoading = false;

  //getters
  bool get isLoading => _isLoading;

  //method to send the payment info of user
  Future<void> sendPaymentInfo(int? userid, int? mentorid, String paymentId,  String amount) async {

    //loading state
    _isLoading = true;
    notifyListeners();

    try {
      const endpoint = 'mentors/get_payment_info/';

      final data = {
        'user_id': userid,
        'mentor_id': mentorid,
        'payment_id': paymentId,
        'amount': amount,
      };

      final response = await ApiServicesUserPost.postRequest(endpoint, data);

      if (response.containsKey('message')) {
        //
      }
      //error handle

      //stop loading
      _isLoading = false;
      notifyListeners();

    } catch (e) {

      print('Error$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  //method

}