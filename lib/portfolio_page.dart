import 'package:flutter/material.dart';
import 'trade_page.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  static const Color _bgColor = Color(0xFF0B0F19);
  static const Color _cardColor = Color(0xFF141924);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);

  int _selectedTab = 0; // 0 = Open, 1 = History

  // Replace with real data once you have a backend/state management
  final List<Map<String, dynamic>> _openPositions = [];
  final List<Map<String, dynamic>> _historyPositions = [];

  Widget _buildTab(String label, int index, int count) {
    final bool selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? _cardColor : Colors.transparent,
            border: Border.all(color: _borderColor),
          ),
          child: Text(
            '$label ($count)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey[500],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final bool isOpenTab = _selectedTab == 0;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isOpenTab ? 'No open positions.' : 'No trade history yet.',
            style: TextStyle(color: Colors.grey[500], fontSize: 15),
          ),
          if (isOpenTab) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TradePage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: _tealColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Open a Position',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _selectedTab == 0 ? _openPositions : _historyPositions;

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
                child: Text('\$0.00', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 16),
              Text(
                'Portfolio',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildTab('Open', 0, _openPositions.length),
                  _buildTab('History', 1, _historyPositions.length),
                ],
              ),
              Expanded(
                child: currentList.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    // TODO: build a real row once positions exist
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}