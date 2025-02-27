import 'package:flutter/material.dart';
import 'views/exchange_rate_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Currency Exchange',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,

      ),
      home: const ExchangeRatePage(),
    );
  }
}
