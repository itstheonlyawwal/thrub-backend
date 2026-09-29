import 'package:flutter/material.dart';

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

  // Placeholder prices per coin — replace with a real live-price feed later
  static const Map<String, Map<String, dynamic>> _coinData = {
    'BTC': {'price': 83366.00, 'change': -1.77},
    'ETH': {'price': 2690.97, 'change': 0.19},
    'BNB': {'price': 763.47, 'change': -1.81},
    'SOL': {'price': 118.75, 'change': -2.53},
    'XRP': {'price': 1.49, 'change': -1.24},
    'DOGE': {'price': 0.09, 'change': -2.70},
  };

  late String _selectedCoin;
  final _amountController = TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    // Extract "BTC" out of "BTC/USD"
    // print('Received initialSymbol: ${widget.initialSymbol}');
    // _selectedCoin = widget.initialSymbol.split('/').first;
    // if (!_coinData.containsKey(_selectedCoin)) _selectedCoin = 'BTC';
  // }
    _selectedCoin = widget.initialSymbol.split('/').first;
    if (!_coinData.containsKey(_selectedCoin)) _selectedCoin = 'BTC';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _placeOrder(String side) {
    final amount = _amountController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$side order placed: \$$amount of $_selectedCoin (simulated)'),
        backgroundColor: side == 'BUY' ? _tealColor : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coin = _coinData[_selectedCoin]!;
    final double price = coin['price'];
    final double change = coin['change'];
    final bool isUp = change >= 0;

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('\$0.00', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Text(
                '$_selectedCoin/USD',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${isUp ? '+' : ''}${change.toStringAsFixed(2)}% (24h)',
                      style: TextStyle(
                        color: isUp ? _tealColor : Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Chart placeholder
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: _cardColor,
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Gathering live price data...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Coin tabs
              Row(
                children: _coinData.keys.map((symbol) {
                  final bool selected = symbol == _selectedCoin;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCoin = symbol),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? _cardColor : Colors.transparent,
                          border: Border.all(color: _borderColor),
                        ),
                        child: Text(
                          symbol,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selected ? _tealColor : Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              Text(
                'POSITION SIZE (USD)',
                style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: _cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: _borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: _borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _placeOrder('SELL'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'SELL',
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _placeOrder('BUY'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _tealColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'BUY',
                              style: TextStyle(color: _tealColor, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: const TextStyle(color: _tealColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}