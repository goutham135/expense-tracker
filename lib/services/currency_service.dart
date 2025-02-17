import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ExchangeRateService extends ChangeNotifier{
  final String apiKey = "41ab41ce1829168e90d3f63e"; // Replace with your API key
  final String baseCurrency = "INR";
  String status = 'Initiated';

  Future<Map<String, double>> fetchExchangeRates() async {
    status = 'Loading';
    notifyListeners();
    final url = Uri.parse("https://v6.exchangerate-api.com/v6/41ab41ce1829168e90d3f63e/latest/INR");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        status = 'Success';
        notifyListeners();
        return {
          "USD": data["conversion_rates"]["USD"],
          "EUR": data["conversion_rates"]["EUR"],
          "GBP": data["conversion_rates"]["GBP"],
        };
      } else {
        status = 'Error';
        notifyListeners();
        return {
          "USD": 0.0,
          "EUR": 0.0,
          "GBP": 0.0,
        };
      }
    } catch (e) {
      throw Exception("Error fetching exchange rates: $e");
    }
  }
}
