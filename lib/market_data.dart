import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Coin {
  final String ticker; // BTC
  final String name;   // Bitcoin
  final double price;
  final double changePercent;

  const Coin(this.ticker, this.name, this.price, this.changePercent);

  String get pair => '$ticker/USD';
  bool get isUp => changePercent >= 0;

  String get priceText {
    final decimals = price < 1 ? 4 : 2;
    final parts = price.toStringAsFixed(decimals).split('.');
    final whole = parts[0].replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
    return '\$$whole.${parts[1]}';
  }

  String get changeText =>
      '${isUp ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
}

class MarketData extends ChangeNotifier {
  MarketData._internal() {
    _startSimulatedTicks();
  }
  static final MarketData instance = MarketData._internal();

  final Random _random = Random();
  Timer? _timer;

  static const Map<String, String> _names = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'BNB': 'BNB',
    'SOL': 'Solana',
    'XRP': 'XRP',
    'DOGE': 'Dogecoin',
  };

  // Current prices
  final Map<String, double> _prices = {
    'BTC': 83566.00,
    'ETH': 2690.97,
    'BNB': 763.47,
    'SOL': 118.75,
    'XRP': 1.49,
    'DOGE': 0.09,
  };
  final Map<String, List<double>> _priceHistory = {
    'BTC': [], 'ETH': [], 'BNB': [], 'SOL': [], 'XRP': [], 'DOGE': [],
  };

  // Reference ("24h ago") prices that % change is measured against
  final Map<String, double> _openPrices = {
    'BTC': 84385.0,
    'ETH': 2685.9,
    'BNB': 777.5,
    'SOL': 121.8,
    'XRP': 1.51,
    'DOGE': 0.0925,
  };

  // ---- Public API ----
  List<String> get tickers => _names.keys.toList();

  double priceOf(String coin) => _prices[coin] ?? 0;
  List<double> historyOf(String coin) => _priceHistory[coin] ?? [];


  double changeOf(String coin) {
    final open = _openPrices[coin] ?? 0;
    if (open == 0) return 0;
    return ((priceOf(coin) - open) / open) * 100;
  }

  Coin coin(String ticker) => Coin(
    ticker,
    _names[ticker] ?? ticker,
    priceOf(ticker),
    changeOf(ticker),
  );

  List<Coin> get coins => tickers.map(coin).toList();

  // ---- Simulation ----
  void _startSimulatedTicks() {
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      _prices.updateAll((coin, price) {
        final move = (_random.nextDouble() - 0.5) * 0.01; // -0.5% to +0.5%
        final newPrice = price * (1 + move);

        final history = _priceHistory[coin] ?? [];
        history.add(newPrice);
        if (history.length > 30) history.removeAt(0);

        return newPrice;
      });
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}