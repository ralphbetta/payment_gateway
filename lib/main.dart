import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gpay/.env.keys.dart';
import 'package:gpay/gpay/pay.dart';
import 'package:gpay/paypal/Payment.dart';
import 'package:gpay/razorpay/services.dart';
// import 'package:gpay/stripe/controller.dart';
import 'package:gpay/stripe/stripe_pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Paywith(),
    );
  }
}

class Paywith extends StatefulWidget {
  const Paywith({Key? key}) : super(key: key);

  @override
  State<Paywith> createState() => _PaywithState();
}

class _PaywithState extends State<Paywith> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    //initialize razorpay and it functionalities
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        PayNow(context: context).handleExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        PayNow(context: context).handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        PayNow(context: context).handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment method"),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hr(),
            ElevatedButton(
                onPressed: () {
                  StripeController(context: context).makePayment();
                },
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child: const Text("Pay with Stripe")),
            hr(),
            GPayServices().getGpayButton(),
            hr(),
            // ignore: deprecated_member_use
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                payPalNavigation(context, _scaffoldKey);
              },
              child: const Text(
                'Pay with Paypal',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),

            hr(),

            ElevatedButton(
                onPressed: () {
                  PayNow(context: context).openCheckout(_razorpay);
                },
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child: const Text("Pay with Razorpay")),
          ],
        ),
      ),
    );
  }
}

Widget hr() {
  return Container(
    color: Colors.grey,
    height: 0.5,
  );
}

payPalNavigation(BuildContext context, scaffoldKey) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => Payment(
        onFinish: (number) async {
          // payment done
          final snackBar = SnackBar(
            content: Text("Successfull! - $number"),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          scaffoldKey.currentState!.showSnackBar(snackBar);
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(snackBar);
          print('order id: ' + number);
          print('ddasdas');
        },
      ),
    ),
  );
}
