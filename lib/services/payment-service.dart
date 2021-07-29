class StripeTransictionResponse {
  StripeTransictionResponse({this.message, this.success});
  final String message;
  final bool success;
}

class StripePaymentService{
  static const apiBase='https://api.stripe.com//v1';
  static const secret = " ";

  static StripeTransictionResponse payViaExistingCard({String amount, String currency, card}){
    return StripeTransictionResponse(
      message: 'Transaction Sucessful',
      success: true
    );
  }

    static StripeTransictionResponse payViaNewCard({String amount, String currency}){
      return StripeTransictionResponse(
      message: 'Transaction Sucessful',
      success: true
    );
  }

}