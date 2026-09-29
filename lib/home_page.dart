import 'package:flutter/material.dart';
import 'trade_page.dart';
import 'signals_page.dart';

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

  // Placeholder market data — replace with real API data later
  final List<Map<String, dynamic>> _markets = [
    {'symbol': 'BTC/USD', 'name': 'Bitcoin', 'letter': 'B', 'price': '\$83,566.00', 'change': '-0.97%', 'up': false},
    {'symbol': 'ETH/USD', 'name': 'Ethereum', 'letter': 'E', 'price': '\$2,690.97', 'change': '+0.19%', 'up': true},
    {'symbol': 'BNB/USD', 'name': 'BNB', 'letter': 'B', 'price': '\$763.47', 'change': '-1.81%', 'up': false},
    {'symbol': 'SOL/USD', 'name': 'Solana', 'letter': 'S', 'price': '\$118.75', 'change': '-2.53%', 'up': false},
    {'symbol': 'XRP/USD', 'name': 'XRP', 'letter': 'X', 'price': '\$1.49', 'change': '-1.24%', 'up': false},
    {'symbol': 'DOGE/USD', 'name': 'Dogecoin', 'letter': 'D', 'price': '\$0.09', 'change': '-2.70%', 'up': false},
  ];

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
        // TODO: navigate based on label ("Markets", "Portfolio", "Signals", "More")

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
          Text(label, style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMarketRow(Map<String, dynamic> market) {
    final bool isUp = market['up'] as bool;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TradePage(initialSymbol: market['symbol'] as String),
        ),
        );     // TODO: navigate to trade page for market['symbol']
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
                  style: TextStyle(color: isUp ? _tealColor : Colors.redAccent, fontSize: 13,
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
                    style: TextStyle(color: _tealColor, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO: navigate to notifications page
                        },
                        child: Icon(Icons.notifications_none, color: Colors.white),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          // TODO: navigate to settings page
                        },
                        child: Icon(Icons.settings_outlined, color: Colors.white),
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
                            style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$0.00',
                            style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Wallet: \$0.00 · 0 open positions',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () { Navigator.pushReplacement(          // TODO: navigate to trade page
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TradePage()),
                                  );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _tealColor,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text('Trade', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // TODO: navigate to deposit page
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: _borderColor),
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text('Deposit', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          widget.onSwitchTab?.call(1); // Markets is tab index 1 in MainShell
                        }),
                        _buildQuickAction(Icons.work_outline, 'Portfolio', () {
                          widget.onSwitchTab?.call(3); // Portfolio is tab index 3
                        }),
                        _buildQuickAction(Icons.graphic_eq, 'Signals', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignalsPage()),
                          );
                        }),
                        _buildQuickAction(Icons.more_horiz, 'More', () {
                          widget.onSwitchTab?.call(4); // More is tab index 4
                        }),
                      ],
                    ),

                    SizedBox(height: 28),
                    Text(
                      'MARKETS',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1),
                    ),
                    SizedBox(height: 8),

                    // Market list
                    Column(
                      children: _markets.map(_buildMarketRow).toList(),
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