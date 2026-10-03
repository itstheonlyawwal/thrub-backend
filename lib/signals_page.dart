import 'package:flutter/material.dart';

class SignalsPage extends StatelessWidget {
  const SignalsPage({super.key});

  static const Color _bgColor = Color(0xFF0B0F19);
  static const Color _cardColor = Color(0xFF141924);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);

  // Placeholder data — replace with real closed signals from your backend later
  static const List<Map<String, String>> _closedSignals = [];

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 11, letterSpacing: 1),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(color: _tealColor, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    TextStyle style = TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('PAIR', style: style)),
          Expanded(flex: 2, child: Text('DIRECTION', style: style)),
          Expanded(flex: 2, child: Text('ENTRY', style: style)),
          Expanded(flex: 2, child: Text('CLOSED', style: style)),
          Expanded(flex: 2, child: Text('RESULT', style: style)),
          Expanded(flex: 2, child: Text('DATE', style: style)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo row
              Row(
                children: [
                  Icon(Icons.graphic_eq, color: _tealColor, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'throb.',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 28),

              Text(
                'Every closed call, no exceptions',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Wins and losses both, in the order they happened. This is the entire '
                    'history — nothing curated out.',
                style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.4),
              ),
              SizedBox(height: 24),

              // Stats card
              Container(
                decoration: BoxDecoration(
                  color: _cardColor,
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildStat('WIN RATE', '0%'),
                    _buildStat('TOTAL CLOSED', '0'),
                    _buildStat('AVG RETURN', '+0R'),
                    _buildStat('BEST CALL', '+0R'),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Table
              _buildTableHeader(),
              Divider(color: _borderColor, height: 1),

              if (_closedSignals.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No closed signals yet — check back soon.',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ),
                )
              else
                Column(
                  children: _closedSignals.map((signal) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(signal['pair'] ?? '', style: TextStyle(color: Colors.white))),
                              Expanded(flex: 2, child: Text(signal['direction'] ?? '', style: TextStyle(color: Colors.white))),
                              Expanded(flex: 2, child: Text(signal['entry'] ?? '', style: TextStyle(color: Colors.white))),
                              Expanded(flex: 2, child: Text(signal['closed'] ?? '', style: TextStyle(color: Colors.white))),
                              Expanded(flex: 2, child: Text(signal['result'] ?? '', style: TextStyle(color: (signal['result'] ?? '').startsWith('+') ? _tealColor : Colors.redAccent,),),),
                              Expanded(flex: 2, child: Text(signal['date'] ?? '', style: TextStyle(color: Colors.grey[500]))),
                            ],
                          ),
                        ),
                        Divider(color: _borderColor, height: 1),
                      ],
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}