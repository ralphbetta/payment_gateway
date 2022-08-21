import 'package:flutter/material.dart';
import 'package:gpay/.env.keys.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PayNow {
  PayNow({required this.context});
  final BuildContext context;

  void openCheckout(Razorpay _razorpay) async {
    var options = {
      'key': razorKey,
      'amount': 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      return _razorpay.open(options);
    } catch (e) {
      return debugPrint('Error: e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    showMyDialog(context, "SUCCESS", response.paymentId.toString());
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    showMyDialog(context, "ERROR", response.message.toString());
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    showMyDialog(context, "EXTERNAL WALLET", response.walletName.toString());
  }
}

Future<void> showMyDialog(
    BuildContext context, String msg, String response) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msg),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(response),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Done!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
