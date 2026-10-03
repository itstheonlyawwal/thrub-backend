import 'package:flutter/material.dart';
import 'position_store.dart';
import 'market_data.dart';
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

  Widget _sideBadge(String side) {
    final isBuy = side == 'BUY';
    final color = isBuy ? _tealColor : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(side,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildOpenRow(Position position) {
    final double pnl = position.livePnl; // live, updates with market ticks
    final bool isProfit = pnl >= 0;
    final Color pnlColor = isProfit ? _tealColor : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(position.symbol,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    SizedBox(width: 8),
                    _sideBadge(position.side),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Entry \$${position.entryPrice.toStringAsFixed(2)} · \$${position.amountUsd.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isProfit ? '+' : ''}\$${pnl.toStringAsFixed(2)}',
                style: TextStyle(
                    color: pnlColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => PortfolioStore.instance.closePosition(position),
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Close',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(Position position) {
    final double pnl = position.realizedPnl;
    final bool isProfit = pnl >= 0;

    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${position.symbol} · ${position.side}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                SizedBox(height: 4),
                Text(
                  'Entry \$${position.entryPrice.toStringAsFixed(2)} → Close \$${position.exitPrice!.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            '${isProfit ? '+' : ''}\$${pnl.toStringAsFixed(2)}',
            style: TextStyle(
              color: isProfit ? _tealColor : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
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
                  MaterialPageRoute(builder: (context) => const TradePage()),
                );
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: _tealColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Open a Position',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      // listens to BOTH: store changes (open/close) and live price ticks (P/L)
      listenable:
      Listenable.merge([PortfolioStore.instance, MarketData.instance]),
      builder: (context, _) {
        final openPositions = PortfolioStore.instance.openPositions;
        final closedPositions = PortfolioStore.instance.closedPositions;
        final currentList = _selectedTab == 0 ? openPositions : closedPositions;

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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('\$0.00',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Portfolio',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTab('Open', 0, openPositions.length),
                      _buildTab('History', 1, closedPositions.length),
                    ],
                  ),
                  Expanded(
                    child: currentList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final position = currentList[index];
                        return _selectedTab == 0
                            ? _buildOpenRow(position)
                            : _buildHistoryRow(position);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}