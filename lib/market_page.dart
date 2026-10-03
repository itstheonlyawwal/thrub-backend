import 'package:flutter/material.dart';
import 'trade_page.dart';
import 'market_data.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  static const Color _bgColor = Color(0xFF0B0F19);
  static const Color _cardColor = Color(0xFF141924);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);

  Widget _buildMarketRow(BuildContext context, Coin coin) {
    final Color changeColor = coin.isUp ? _tealColor : Colors.redAccent;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TradePage(initialSymbol: coin.pair),
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
                coin.ticker[0],
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.pair,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Text(
                    coin.name,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coin.priceText,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  coin.changeText,
                  style: TextStyle(color: changeColor, fontSize: 13),
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
    return ListenableBuilder(
      listenable: MarketData.instance,
      builder: (context, _) {
        final coins = MarketData.instance.coins;

        return Scaffold(
          backgroundColor: _bgColor,
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                SizedBox(height: 16),
                Text(
                  'Markets',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Live prices. Trades placed here are simulated.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                SizedBox(height: 16),
                ...coins.map((c) => _buildMarketRow(context, c)),
              ],
            ),
          ),
        );
      },
    );
  }
}