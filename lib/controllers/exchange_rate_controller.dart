import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rate.dart';

class ExchangeRateController {
  Future<ExchangeRate?> fetchExchangeRate(String baseCurrency, String targetCurrency) async {
    String url = "https://v6.exchangerate-api.com/v6/9c79e7818216a5c36896f4d5/latest/$baseCurrency";
    print("Requesting: $url");
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['result'] == "success") {
          return ExchangeRate.fromJson(jsonResponse, baseCurrency, targetCurrency);
        } else {
          print("API error: ${jsonResponse['error-type']}");
          return null;
        }
      } else {
        print("HTTP error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
