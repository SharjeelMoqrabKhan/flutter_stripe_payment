import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeTransictionResponse {
  StripeTransictionResponse({this.message, this.success});
  final String message;
  final bool success;
}

class StripePaymentService {
  static const apiBase = 'https://api.stripe.com/v1';
  static const secret =
      'sk_test_51JIfSmLKf6Xy1135fdY9CszlMobTdJA82dMR7vBr6qlk6M6HfMt2eQ06MbyCynbaCX5jK0i11SMOitghGGYNgfMB00CrhLMTNz';
  static const paymentApiUrl =
      '${StripePaymentService.apiBase}/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripePaymentService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
      StripeOptions(
          publishableKey:
              "pk_test_51JIfSmLKf6Xy1135QKmuQ6qeLGdBBk792tev6sO4GDXDyhUcuzyfiXv4nPa6XimwVXCQApwlTJLoI5zO2FPzGUPZ00EhsA5xpe",
          merchantId: "Test",
          androidPayMode: 'test'),
    );
  }

  static Future <StripeTransictionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );
      var paymentIntend =
          await StripePaymentService.createPaymentIntend(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntend['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return StripeTransictionResponse(
          message: 'Transaction Sucessful',
          success: true,
        );
      } else {
        return StripeTransictionResponse(
          message: 'Transaction Failed ',
          success: false,
        );
      }
    } on PlatformException catch (e) {
      return StripePaymentService.getPlatformException(e);
    }
  }

  static getPlatformException(e) {
    String message = 'something went wrong';
    if (e.code == 'cancelled') {
      message = "Transaction failed";
    }
    return StripeTransictionResponse(
      message: message,
      success: false,
    );
  }

  static Future<StripeTransictionResponse> payViaNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      var paymentIntend =
          await StripePaymentService.createPaymentIntend(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntend['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return StripeTransictionResponse(
          message: 'Transaction Sucessful',
          success: true,
        );
      } else {
        return StripeTransictionResponse(
          message: 'Transaction Failed ',
          success: false,
        );
      }
    } on PlatformException catch (e) {
      return StripePaymentService.getPlatformException(e);
    }
  }



  static Future<Map<String, dynamic>> createPaymentIntend(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripePaymentService.paymentApiUrl,
          body: body, headers: StripePaymentService.headers);
      return jsonDecode(response.body);
    } catch (e) {}
    return null;
  }
}
