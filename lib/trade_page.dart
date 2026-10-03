import 'package:flutter/material.dart';
import 'position_store.dart';
import 'market_data.dart';
import 'package:fl_chart/fl_chart.dart';

class TradePage extends StatefulWidget {
  final String initialSymbol;

  const TradePage({super.key, this.initialSymbol = 'BTC/USD'});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  static const Color _bgColor = Color(0xFF0B0F19);
  static const Color _cardColor = Color(0xFF141924);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);

  late String _selectedCoin;
  final _amountController = TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    _selectedCoin = widget.initialSymbol.split('/').first;
    if (!MarketData.instance.tickers.contains(_selectedCoin)) {
      _selectedCoin = 'BTC';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _placeOrder(String side) {
    final amountText = _amountController.text;
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid position size.')),
      );
      return;
    }

    final price = MarketData.instance.priceOf(_selectedCoin);

    PortfolioStore.instance.openPosition(
      Position(
        symbol: '$_selectedCoin/USD',
        side: side,
        entryPrice: price,
        amountUsd: amount,
        openedAt: DateTime.now(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$side order placed: \$$amountText of $_selectedCoin (simulated)',
        ),
        backgroundColor: side == 'BUY' ? _tealColor : Colors.redAccent,
      ),
    );
  }

  Widget _orderButton(String side, Color color, String priceText) {
    return GestureDetector(
      onTap: () => _placeOrder(side),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(side,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 2),
            Text(priceText, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final history = MarketData.instance.historyOf(_selectedCoin);

    if (history.length < 2) {
      return Center(
        child: Text(
          'Gathering live price data...',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final spots = <FlSpot>[
      for (int i = 0; i < history.length; i++) FlSpot(i.toDouble(), history[i]),
    ];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _tealColor,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: _tealColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MarketData.instance,
      builder: (context, _) {
        final coin = MarketData.instance.coin(_selectedCoin);
        final Color changeColor = coin.isUp ? _tealColor : Colors.redAccent;

        return Scaffold(
          backgroundColor: _bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('\$0.00',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  Text(coin.pair,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  // Live price + change
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(coin.priceText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text('${coin.changeText} (24h)',
                            style:
                            TextStyle(color: changeColor, fontSize: 14)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Chart placeholder
                  Container(
                    width: double.infinity,
                    height: 180,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildChart(),
                  ),
                  SizedBox(height: 16),

                  // Coin tabs
                  Row(
                    children: MarketData.instance.tickers.map((symbol) {
                      final bool selected = symbol == _selectedCoin;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCoin = symbol),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                              selected ? _cardColor : Colors.transparent,
                              border: Border.all(color: _borderColor),
                            ),
                            child: Text(symbol,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: selected
                                        ? _tealColor
                                        : Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),

                  Text('POSITION SIZE (USD)',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          letterSpacing: 1)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: _cardColor,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: _borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: _borderColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                          child: _orderButton(
                              'SELL', Colors.redAccent, coin.priceText)),
                      SizedBox(width: 12),
                      Expanded(
                          child:
                          _orderButton('BUY', _tealColor, coin.priceText)),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}