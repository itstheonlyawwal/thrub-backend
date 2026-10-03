import 'package:flutter/material.dart';
import 'trade_page.dart';
import 'signals_page.dart';
import 'position_store.dart';
import 'market_data.dart';
import 'deposit_page.dart';

class HomePage extends StatefulWidget {
  final void Function(int)? onSwitchTab;
  const HomePage({super.key, this.onSwitchTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color _bgColor = Color(0xFF0B0F19);
  static const Color _cardColor = Color(0xFF141924);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: Icon(icon, color: _tealColor, size: 22),
          ),
          SizedBox(height: 8),
          Text(label,
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMarketRow(Coin coin) {
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
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
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
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: "Home" title + bell + settings icons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Home',
                    style: TextStyle(
                        color: _tealColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO: navigate to notifications page
                        },
                        child: Icon(Icons.notifications_none,
                            color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          // TODO: navigate to settings page
                        },
                        child: Icon(Icons.settings_outlined,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR BALANCE',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                                letterSpacing: 1),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$0.00',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),

                          // Live open-positions counter
                          ListenableBuilder(
                            listenable: PortfolioStore.instance,
                            builder: (context, _) {
                              final count =
                                  PortfolioStore.instance.openPositions.length;
                              return Text(
                                'Wallet: \$0.00 · $count open ${count == 1 ? 'position' : 'positions'}',
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 13),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (widget.onSwitchTab != null) {
                                      widget.onSwitchTab!(2); // Trade tab
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TradePage()),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _tealColor,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text('Trade',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DepositPage()),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: _borderColor),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text('Deposit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Quick action row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(Icons.show_chart, 'Markets', () {
                          widget.onSwitchTab?.call(1);
                        }),
                        _buildQuickAction(Icons.work_outline, 'Portfolio', () {
                          widget.onSwitchTab?.call(3);
                        }),
                        _buildQuickAction(Icons.graphic_eq, 'Signals', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignalsPage()),
                          );
                        }),
                        _buildQuickAction(Icons.more_horiz, 'More', () {
                          widget.onSwitchTab?.call(4);
                        }),
                      ],
                    ),

                    SizedBox(height: 28),
                    Text(
                      'MARKETS',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          letterSpacing: 1),
                    ),
                    SizedBox(height: 8),

                    // Live market list (prices + direction from MarketData)
                    ListenableBuilder(
                      listenable: MarketData.instance,
                      builder: (context, _) => Column(
                        children: MarketData.instance.coins
                            .map(_buildMarketRow)
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}