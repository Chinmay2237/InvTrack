import 'package:intl/intl.dart';

enum AppCurrency {
  usd('\$', 'USD', 'en_US'),
  eur('€', 'EUR', 'de_DE'),
  gbp('£', 'GBP', 'en_GB'),
  inr('₹', 'INR', 'en_IN'),
  jpy('¥', 'JPY', 'ja_JP');

  final String symbol;
  final String code;
  final String locale;

  const AppCurrency(this.symbol, this.code, this.locale);
}

class CurrencyFormatter {
  static String format(double amount, {AppCurrency currency = AppCurrency.usd}) {
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: currency == AppCurrency.jpy ? 0 : 2,
    );
    return formatter.format(amount);
  }
}
