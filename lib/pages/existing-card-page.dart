import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_stripe_payment/services/payment-service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ExistingCardPage extends StatefulWidget {
  @override
  _ExistingCardPageState createState() => _ExistingCardPageState();
}

class _ExistingCardPageState extends State<ExistingCardPage> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Sharjeel Moqrab Khan',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/23',
      'cardHolderName': 'Tracer',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];
  payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'please wait...');
    await dialog.show();
    var expArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expArr[0]),
      expYear: int.parse(expArr[1]),
    );
    var response = await StripePaymentService.payViaExistingCard(
      amount: '2500',
      currency: 'USD',
      card: stripeCard,
    );
    await dialog.hide();
    Scaffold.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(response.message),
            duration: Duration(milliseconds: 1200),
          ),
        )
        .closed
        .then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Card page'),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            var card = cards[index];
            return InkWell(
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: card['showBackView'],
              ),
              onTap: () => payViaExistingCard(context, card),
            );
          },
          itemCount: cards.length,
        ),
      ),
    );
  }
}
