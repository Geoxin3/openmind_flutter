import 'package:flutter/material.dart';
import 'package:openmind_flutter/State_Provider_All/Payment_Functions.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  final Razorpay _razorpay = Razorpay();

  late BuildContext _context;
  int? _userId;
  int? _mentorId;
  String? _amount;
  VoidCallback? _onPaymentComplete;

  PaymentService() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // // Simulate order ID generation (Not recommended for production)
  // String generateOrderId() {
  //   // This is just a placeholder. Ideally, the order ID should come from the backend.
  //   return "order_${DateTime.now().millisecondsSinceEpoch}";
  // }  

  void startPayment({
    required BuildContext context,
    required int? userId,
    required int? mentorId,
    required String fullname,
    required String? sessionPrice,
    required VoidCallback onPaymentComplete,
  }) {

    int amountInPaise;
    try {
      amountInPaise = (double.parse(sessionPrice ?? '0') * 100).toInt();
    } catch (e) {
      print('Invalid price format: $sessionPrice');
      return;
    }

    // Store only necessary data
    _context = context;
    _userId = userId;
    _mentorId = mentorId;
    _amount = sessionPrice;
    _onPaymentComplete = onPaymentComplete;

    //final orderId = generateOrderId();

    var options = {
      'key': 'YOUR_TEST_KEY_HERE', // replace with your razorpey test key
      'amount': amountInPaise,
      'name': fullname,
      'description': 'Request Payment',
      //no need for this now
      //'order_id': orderId //randomly generated orderid for demo only
    };

    _razorpay.open(options);
  }

  //after payment success 
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      //payment provider to send payment info
      final paymentProvider = Provider.of<PaymentProvider>(_context, listen: false);
    
      //sending payment info to server
      await paymentProvider.sendPaymentInfo(
        _userId,
        _mentorId,
        response.paymentId ?? '',
        _amount ?? ''
      );

      // Check if widget is still mounted before showing the dialog
      if (_context.mounted) {
        showDialog(
          context: _context,
          barrierDismissible: false, // Prevent closing the dialog by tapping outside
          builder: (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Payment Successful',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Your payment was processed successfully.\n\nPayment ID: ${response.paymentId}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_context.mounted) {
                      Navigator.of(_context, rootNavigator: true).pop(); // dismiss dialog
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Ensure widget is still mounted before proceeding
                        if (_context.mounted) {
                          _onPaymentComplete?.call(); // safely call callback after payment completion
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Ok', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error while sending payment info: $e');
    }
  }


  //after payment is failed
  void _handlePaymentError(PaymentFailureResponse response) {
    //print("Payment Failed: ${response.code} | ${response.message}");
    //dialog on payment failed
    showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Payment Failed',
          style: TextStyle(fontWeight: FontWeight.bold,),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            SizedBox(height: 12),
            Text(
              'Oops! Something went wrong during the payment.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // not handling this now 
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print("External Wallet Selected: ${response.walletName}");s
  // }

  void dispose() {
    _razorpay.clear();
  }
}
