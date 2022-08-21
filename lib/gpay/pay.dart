import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class Donate extends StatelessWidget {
  const Donate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //app pay requires registering with google developers program cost $99
          // ApplePayButton(
          //   paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
          //   paymentItems: GPayServices().paymentItems,
          //   style: ApplePayButtonStyle.black,
          //   type: ApplePayButtonType.buy,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: GPayServices().onApplePayResult,
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
          GooglePayButton(
            paymentConfigurationAsset:
                'default_payment_profile_google_pay.json',
            paymentItems: GPayServices().paymentItems, //_paymentItems,
            style: GooglePayButtonStyle.black,
            type: GooglePayButtonType.pay,
            width: 200,
            margin: const EdgeInsets.only(top: 15.0, left: 100),
            onPaymentResult: GPayServices().onGooglePayResult,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class GPayServices {
  final List<PaymentItem> paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  getGpayButton() {
    return GooglePayButton(
      paymentConfigurationAsset: 'default_payment_profile_google_pay.json',
      paymentItems: paymentItems, //_paymentItems,
      style: GooglePayButtonStyle.black,
      type: GooglePayButtonType.pay,
      width: 150,

      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      onPaymentResult: GPayServices().onGooglePayResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
