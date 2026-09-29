import 'package:flutter/material.dart';
import 'trade_page.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  static const Color _bgColor = Color(0xFF0B0F19);
  static const Color _cardColor = Color(0xFF141924);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);

  static const List<Map<String, dynamic>> _markets = [
    {'symbol': 'BTC/USD', 'name': 'Bitcoin', 'letter': 'B', 'price': '\$83,566.00', 'change': '-0.97%', 'up': false},
    {'symbol': 'ETH/USD', 'name': 'Ethereum', 'letter': 'E', 'price': '\$2,690.97', 'change': '+0.19%', 'up': true},
    {'symbol': 'BNB/USD', 'name': 'BNB', 'letter': 'B', 'price': '\$763.47', 'change': '-1.81%', 'up': false},
    {'symbol': 'SOL/USD', 'name': 'Solana', 'letter': 'S', 'price': '\$118.75', 'change': '-2.53%', 'up': false},
    {'symbol': 'XRP/USD', 'name': 'XRP', 'letter': 'X', 'price': '\$1.49', 'change': '-1.24%', 'up': false},
    {'symbol': 'DOGE/USD', 'name': 'Dogecoin', 'letter': 'D', 'price': '\$0.09', 'change': '-2.70%', 'up': false},
  ];

  Widget _buildMarketRow(BuildContext context, Map<String, dynamic> market) {
    final bool isUp = market['up'] as bool;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TradePage(initialSymbol: market['symbol'] as String),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _borderColor)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _cardColor,
              child: Text(
                market['letter'],
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    market['symbol'],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    market['name'],
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  market['price'],
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  market['change'],
                  style: TextStyle(
                    color: isUp ? _tealColor : Colors.redAccent,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text(
                'Markets',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Live prices. Trades placed here are simulated.',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _markets.length,
                  itemBuilder: (context, index) => _buildMarketRow(context, _markets[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}