class ExchangeRate {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final Map<String, double>? allRates;

  ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    this.allRates,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json, String from, String to) {

    double singleRate = (json['conversion_rates'][to] as num).toDouble();

    final Map<String, dynamic> conversionMap = json['conversion_rates'] ?? {};

    final Map<String, double> allRates = conversionMap.map((key, value) {
      return MapEntry(key, (value as num).toDouble());
    });

    return ExchangeRate(
      fromCurrency: from,
      toCurrency: to,
      rate: singleRate,
      allRates: allRates,
    );
  }
}
