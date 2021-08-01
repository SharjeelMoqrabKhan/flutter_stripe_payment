import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/services/payment-service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  onItemPressed(BuildContext context, int index) async {
    switch (index) {
      case 0:
        var response = await StripePaymentService.payViaNewCard(
          amount: '15000',
          currency: 'USD',
        );
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            duration:
                Duration(milliseconds: response.success == true ? 1200 : 3000),
          ),
        );
        break;
      case 1:
        Navigator.pushNamed(context, '/esxisting-card');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    StripePaymentService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            Icon icon;
            Text text;
            switch (index) {
              case 0:
                icon = Icon(Icons.credit_card);
                text = Text('Pay Via New Card');
                break;
              case 1:
                icon = Icon(Icons.add_circle);
                text = Text('Pay Via Existing Card');
                break;
            }
            return InkWell(
              child: ListTile(
                title: text,
                leading: icon,
                onTap: () => onItemPressed(context, index),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              indent: 24.0,
              endIndent: 24.0,
              color: theme.primaryColor,
            );
          },
          itemCount: 2,
        ));
  }
}
