import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart' as pay;
import 'package:stripe_example/config.dart';
import 'package:stripe_example/widgets/example_scaffold.dart';

import '../../.env.dart';

const _paymentItems = [
  pay.PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: pay.PaymentItemStatus.final_price,
  )
];

class GooglePayScreen extends StatefulWidget {
  const GooglePayScreen({super.key});

  @override
  _GooglePayScreenState createState() => _GooglePayScreenState();
}

class _GooglePayScreenState extends State<GooglePayScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Google Pay',
      padding: EdgeInsets.all(16),
      tags: ['Android', 'Pay plugin'],
      children: [
        pay.GooglePayButton(
          paymentConfiguration: pay.PaymentConfiguration.fromJsonString(
            _paymentProfile,
          ),
          paymentItems: _paymentItems,
          margin: const EdgeInsets.only(top: 15),
          onPaymentResult: onGooglePayResult,
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
          onPressed: () async {},
          childOnError: Text('Google Pay is not available in this device'),
          onError: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'There was an error while trying to perform the payment'),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> onGooglePayResult(paymentResult) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      debugPrint(paymentResult.toString());
      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['clientSecret'];
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      debugPrint(tokenJson.toString());

      final params = PaymentMethodParams.cardFromToken(
        paymentMethodData: PaymentMethodDataCardFromToken(
          token: tokenJson['id'], // TODO extract the actual token
        ),
      );

      // 3. Confirm Google pay payment method
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: params,
      );

      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
              content: Text('Google Pay payment successfully completed')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse('$kApiUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': 'example@gmail.com',
        'currency': 'usd',
        'items': ['id-1'],
        'request_three_d_secure': 'any',
      }),
    );
    return json.decode(response.body);
  }
}

final _paymentProfile = """{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "stripe",
            "stripe:version": "2020-08-27",
            "stripe:publishableKey": "$stripePublishableKey"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}""";
