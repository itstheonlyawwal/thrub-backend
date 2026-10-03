import 'package:flutter/material.dart';
import 'market_data.dart';

class Position {
  final String id;
  final String symbol; // e.g. BTC/USD
  final String side; // BUY or SELL
  final double entryPrice;
  final double amountUsd;
  final DateTime openedAt;

  double? exitPrice;
  DateTime? closedAt;

  Position({
    required this.symbol,
    required this.side,
    required this.entryPrice,
    required this.amountUsd,
    required this.openedAt,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString();

  bool get isOpen => closedAt == null;

  String get ticker => symbol.split('/').first;

  /// Profit/loss in USD at a given price
  double pnlAt(double price) {
    final units = amountUsd / entryPrice;
    final diff = side == 'BUY' ? price - entryPrice : entryPrice - price;
    return units * diff;
  }

  double get livePnl => pnlAt(MarketData.instance.priceOf(ticker));

  double get realizedPnl => pnlAt(exitPrice ?? entryPrice);
}

class PortfolioStore extends ChangeNotifier {
  PortfolioStore._();
  static final PortfolioStore instance = PortfolioStore._();

  final List<Position> _positions = [];

  List<Position> get openPositions =>
      _positions.where((p) => p.isOpen).toList().reversed.toList();

  List<Position> get history => _positions.where((p) => !p.isOpen).toList().reversed.toList();

  List<Position> get closedPositions => history;

  double get totalLivePnl =>
      openPositions.fold(0.0, (sum, p) => sum + p.livePnl);

  double get totalRealizedPnl =>
      history.fold(0.0, (sum, p) => sum + p.realizedPnl);

  void openPosition(Position p) {
    _positions.add(p);
    notifyListeners();
  }

  void closePosition(Position p, [double? price]) {
    p.exitPrice = price ?? MarketData.instance.priceOf(p.ticker);
    p.closedAt = DateTime.now();
    notifyListeners();
  }
}