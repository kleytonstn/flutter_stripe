import 'package:flutter/material.dart';
import 'package:stripe_example/screens/address_sheet/address_sheet.dart';
import 'package:stripe_example/screens/customer_sheet/customer_sheet_screen.dart';
import 'package:stripe_example/screens/others/can_add_to_wallet_screen.dart';
import 'package:stripe_example/screens/payment_sheet/express_checkout/express_checkout_element.dart';
import 'package:stripe_example/screens/payment_sheet/payment_element/payment_element.dart';
import 'package:stripe_example/screens/payment_sheet/payment_sheet_deffered_screen.dart';
import 'package:stripe_example/screens/payment_sheet/payment_sheet_screen.dart';
import 'package:stripe_example/screens/payment_sheet/payment_sheet_screen_custom_flow.dart';
import 'package:stripe_example/screens/regional_payment_methods/affirm_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/ali_pay_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/aubecs_debit.dart';
import 'package:stripe_example/screens/regional_payment_methods/cash_app_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/fpx_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/ideal_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/klarna_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/p24_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/paypal_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/revolutpay_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/sofort_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/us_bank_account_direct_debit_screen.dart';
import 'package:stripe_example/screens/regional_payment_methods/us_bank_account_screen.dart';
import 'package:stripe_example/screens/setup_future_payments/setup_future_payments_screen.dart';
import 'package:stripe_example/screens/wallets/apple_pay_screen.dart';
import 'package:stripe_example/screens/wallets/apple_pay_screen_plugin.dart';
import 'package:stripe_example/screens/wallets/google_pay_screen.dart';
import 'package:stripe_example/screens/wallets/google_pay_stripe_screen.dart';
import 'package:stripe_example/screens/wallets/mobile_pay_create_payment_method_screen.dart';
import 'package:stripe_example/screens/wallets/open_apple_pay_setup_screen.dart';
import 'package:stripe_example/widgets/platform_icons.dart';

import 'card_payments/custom_card_payment_screen.dart';
import 'card_payments/no_webhook_payment_cardform_screen.dart';
import 'card_payments/no_webhook_payment_screen.dart';
import 'card_payments/webhook_payment_screen.dart';
import 'financial_connections.dart/financial_connections_session_screen.dart';
import 'others/cvc_re_collection_screen.dart';
import 'others/legacy_token_bank_screen.dart';
import 'others/legacy_token_card_screen.dart';
import 'regional_payment_methods/grab_pay_screen.dart';
import 'themes.dart';
import 'wallets/apple_pay_create_payment_method.dart';
import 'wallets/payment_sheet_screen_subscription.dart';

class ExampleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool expanded;

  const ExampleSection({
    super.key,
    required this.title,
    required this.children,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      initiallyExpanded: expanded,
      childrenPadding: EdgeInsets.only(left: 20),
      title: Text(title),
      children:
          ListTile.divideTiles(tiles: children, context: context).toList(),
    );
  }
}

class Example extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Widget? leading;
  final List<DevicePlatform> platformsSupported;

  final WidgetBuilder builder;

  const Example({
    super.key,
    required this.title,
    required this.builder,
    this.style,
    this.leading,
    this.platformsSupported = DevicePlatform.values,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final route = MaterialPageRoute(builder: builder);
        Navigator.push(context, route);
      },
      title: Text(title, style: style),
      leading: leading,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        PlatformIcons(supported: platformsSupported),
        Icon(Icons.chevron_right_rounded),
      ]),
    );
  }

  static List<Example> paymentMethodScreens = [];

  static List<Widget> screens = [
    ExampleSection(
      title: 'Payment Sheet',
      expanded: true,
      children: [
        Example(
          title: 'Single Step',
          builder: (context) => PaymentSheetScreen(),
          platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
        ),
        Example(
          title: 'Single Step (deffered payment)',
          builder: (context) => PaymentSheetDefferedScreen(),
          platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
        ),
        Example(
          title: 'Custom Flow',
          builder: (context) => PaymentSheetScreenWithCustomFlow(),
          platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
        ),
        Example(
          title: 'Web Payment Element',
          builder: (c) => PaymentElementExample(),
          platformsSupported: [
            DevicePlatform.web,
          ],
        ),
        Example(
          title: 'ExpressCheckout',
          builder: (c) => ExpressCheckoutElementExample(),
          platformsSupported: [
            DevicePlatform.web,
          ],
        ),
        Example(
          title: 'Setup future payments',
          builder: (_) => SetupFuturePaymentsScreen(),
          platformsSupported: [
            DevicePlatform.android,
            DevicePlatform.ios,
            DevicePlatform.web,
          ],
        )
      ],
    ),
    ExampleSection(title: 'Address sheet', children: [
      Example(
        title: 'Address sheet',
        builder: (context) => AddressSheetExample(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
    ]),
    ExampleSection(title: 'Customer sheet', children: [
      Example(
        title: 'Customer sheet',
        builder: (context) => CustomerSheetScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
    ]),
    ExampleSection(
      title: 'Card Payments',
      children: [
        Example(
          title: 'Simple - Using webhooks',
          style: TextStyle(fontWeight: FontWeight.w600),
          builder: (c) => WebhookPaymentScreen(),
        ),
        Example(
          title: 'Without webhooks',
          builder: (c) => NoWebhookPaymentScreen(),
        ),
        Example(
          title: 'Card Field themes',
          builder: (c) => ThemeCardExample(),
        ),
        Example(
          title: 'Card Form',
          builder: (c) => NoWebhookPaymentCardFormScreen(),
          platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
        ),
        Example(
          title: 'Flutter UI (not PCI compliant)',
          builder: (c) => CustomCardPaymentScreen(),
          platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
        ),
      ],
    ),
    ExampleSection(
      title: 'Wallets',
      children: [
        Example(
          title: 'Apple Pay',
          leading: Image.asset(
            'assets/apple_pay.png',
            width: 48,
          ),
          builder: (c) => ApplePayScreen(),
          platformsSupported: [DevicePlatform.ios],
        ),
        Example(
          title: 'Apple Pay - Pay Plugin',
          leading: Image.asset(
            'assets/apple_pay.png',
            width: 48,
          ),
          builder: (c) => ApplePayExternalPluginScreen(),
          platformsSupported: [DevicePlatform.ios],
        ),
        Example(
          title: 'Apple Pay - Create payment method',
          leading: Image.asset(
            'assets/apple_pay.png',
            width: 48,
          ),
          builder: (c) => ApplePayCreatePaymentMethodScreen(),
          platformsSupported: [DevicePlatform.ios],
        ),
        Example(
          title: 'Apple Pay - Paymentsheet subscription',
          leading: Image.asset(
            'assets/apple_pay.png',
            width: 48,
          ),
          builder: (c) => ApplePayPaymentSheetScreen(),
          platformsSupported: [DevicePlatform.ios],
        ),
        Example(
          title: 'Open Apple Pay setup',
          leading: Image.asset(
            'assets/apple_pay.png',
            width: 48,
          ),
          builder: (c) => OpenApplePaySetup(),
          platformsSupported: [DevicePlatform.ios],
        ),
        Example(
          leading: Image.asset(
            'assets/google_play.png',
            width: 48,
          ),
          title: 'Google Pay',
          builder: (c) => GooglePayStripeScreen(),
          platformsSupported: [DevicePlatform.android],
        ),
        Example(
          leading: Image.asset(
            'assets/google_play.png',
            width: 48,
          ),
          title: 'Google Pay - Pay Plugin',
          builder: (c) => GooglePayScreen(),
          platformsSupported: [DevicePlatform.android],
        ),
        Example(
          title: 'Google/Apple Pay - Create payment method',
          builder: (c) => MobilePayCreatePaymentMethodScreen(),
          platformsSupported: [DevicePlatform.web],
        ),
      ],
    ),
    ExampleSection(title: 'Regional Payment Methods', children: [
      Example(
        title: 'Ali Pay',
        leading: Image.asset(
          'assets/alipay.png',
          width: 48,
        ),
        builder: (context) => AliPayScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Affirm',
        leading: SizedBox(),
        builder: (context) => AffirmScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Cash app Pay',
        builder: (context) => CashAppScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Ideal',
        leading: Image.asset(
          'assets/ideal_pay.png',
          width: 48,
        ),
        builder: (context) => IdealScreen(),
      ),
      Example(
        title: 'Sofort',
        leading: SizedBox(),
        builder: (context) => SofortScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Aubecs',
        builder: (context) => AubecsExample(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Fpx',
        leading: Image.asset(
          'assets/fpx.png',
          width: 48,
        ),
        builder: (contex) => FpxScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Grab pay',
        leading: Image.asset(
          'assets/grab_pay.png',
          width: 48,
        ),
        builder: (contex) => GrabPayScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Klarna',
        leading: Image.asset(
          'assets/klarna.jpg',
          width: 48,
        ),
        builder: (contex) => KlarnaScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'PayPal',
        leading: Image.asset(
          'assets/paypal.png',
          width: 48,
        ),
        builder: (contex) => PayPalScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'RevolutPay',
        leading: Image.asset(
          'assets/revolut.png',
          width: 48,
        ),
        builder: (context) => RevolutPayScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Us bank accounts (ACH)',
        builder: (contex) => UsBankAccountScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Us bank accounts Direct debit(ACH)',
        builder: (contex) => UsBankAccountDirectDebitScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'P24 Payment',
        leading: SizedBox(),
        builder: (context) => P24Screen(),
      ),
      // TODO: uncomment when we can re-enable wechat pay
      // Example(
      //   title: 'WeChat Pay',
      //   leading: Image.asset(
      //     'assets/wechat_pay.png',
      //     width: 48,
      //   ),
      //   builder: (context) => WeChatPayScreen(),
      // ),
    ]),
    ExampleSection(
      title: 'Financial connections',
      children: [
        Example(
          title: 'Financial connection sessions',
          builder: (_) => FinancialConnectionsScreen(),
          platformsSupported: [
            DevicePlatform.android,
            DevicePlatform.ios,
          ],
        ),
      ],
    ),
    ExampleSection(title: 'Others', children: [
      Example(
        title: 'Re-collect CVC',
        builder: (c) => CVCReCollectionScreen(),
        platformsSupported: [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Create token for card (legacy)',
        builder: (context) => LegacyTokenCardScreen(),
        platformsSupported: [
          DevicePlatform.android,
          DevicePlatform.ios,
          DevicePlatform.web,
        ],
      ),
      Example(
        title: 'Create token for bank (legacy)',
        builder: (context) => LegacyTokenBankScreen(),
        platformsSupported: [
          DevicePlatform.android,
          DevicePlatform.ios,
          DevicePlatform.web,
        ],
      ),
      Example(
        title: 'Can add card to wallet',
        builder: (context) => CanAddToWalletScreen(),
        platformsSupported: [
          DevicePlatform.android,
          DevicePlatform.ios,
        ],
      ),
    ]),
  ];
}
