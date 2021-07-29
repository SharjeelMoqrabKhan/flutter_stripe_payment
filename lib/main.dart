import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/pages/existing-card-page.dart';
import 'package:flutter_stripe_payment/pages/home-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepOrange.shade600),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/esxisting-card': (context) => ExistingCardPage(),
      },
    );
  }
}
