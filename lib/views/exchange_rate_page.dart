import 'package:flutter/material.dart';
import '../controllers/exchange_rate_controller.dart';
import '../models/exchange_rate.dart';

class ExchangeRatePage extends StatefulWidget {
  const ExchangeRatePage({super.key});

  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {

  String _baseCurrency = 'USD';
  String _targetCurrency = 'EUR';

  ExchangeRate? _exchangeRate;
  bool _isLoading = false;
  final ExchangeRateController _controller = ExchangeRateController();

  final List<String> _topCurrencies = [
    "EUR","GBP","JPY","AUD","CAD","CHF","CNY","HKD","NZD","SEK"
  ];

  final Map<String, String> currencyFlags = {
    "EUR": "🇪🇺",
    "GBP": "🇬🇧",
    "JPY": "🇯🇵",
    "AUD": "🇦🇺",
    "CAD": "🇨🇦",
    "CHF": "🇨🇭",
    "CNY": "🇨🇳",
    "HKD": "🇭🇰",
    "NZD": "🇳🇿",
    "SEK": "🇸🇪",
  };

  @override
  void initState() {
    super.initState();
    _fetchRate();
  }

  Future<void> _fetchRate() async {
    setState(() {
      _isLoading = true;
    });
    ExchangeRate? rate = await _controller.fetchExchangeRate(_baseCurrency, _targetCurrency);
    setState(() {
      _exchangeRate = rate;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Currency Exchange"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRate,
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0D47A1),
        ),
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : _exchangeRate == null
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Andmete laadimine ebaõnnestus",
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        )
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              Card(
                margin: const EdgeInsets.all(30.0),
                elevation: 9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 2.8,
                  padding: const EdgeInsets.all(34.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "🇺🇸  ",
                        style: TextStyle(fontSize: 19),
                      ),
                      Text(
                        "1 $_baseCurrency = ${_exchangeRate!.rate} $_targetCurrency",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "  🇪🇺",
                        style: TextStyle(fontSize: 19),
                      ),
                    ],
                  ),
                ),
              ),

              _buildTop10Card(context),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _fetchRate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.refresh, size: 26),
                    label: const Text("Refresh"),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop10Card(BuildContext context) {
    if (_exchangeRate?.allRates == null) {
      return const SizedBox();
    }

    final ratesMap = _exchangeRate!.allRates!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      elevation: 9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 2.8,
        padding: const EdgeInsets.all(34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Top 10 Currency",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ..._topCurrencies.map((code) {
              final double val = ratesMap[code] ?? 0.0;
              final flag = currencyFlags[code] ?? "❓";
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      "$flag  ",
                      style: const TextStyle(fontSize: 22),
                    ),
                    Expanded(
                      child: Text(
                        "$code = ${val.toStringAsFixed(4)}",
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
