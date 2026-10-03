import 'package:flutter/material.dart';
import 'position_store.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F19),
        title: const Text('History', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListenableBuilder(
        listenable: PortfolioStore.instance,
        builder: (context, _) {
          final items = PortfolioStore.instance.history;
          if (items.isEmpty) {
            return Center(
              child: Text('No closed trades yet',
                  style: TextStyle(color: Colors.grey[600])),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
            const Divider(color: Color(0xFF232938)),
            itemBuilder: (context, i) {
              final p = items[i];
              final pnl = p.realizedPnl;
              final up = pnl >= 0;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${p.symbol}  •  ${p.side}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '\$${p.amountUsd.toStringAsFixed(2)}  |  '
                        '${p.entryPrice.toStringAsFixed(2)} → ${p.exitPrice!.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                trailing: Text('${up ? '+' : ''}\$${pnl.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: up
                            ? const Color(0xFF2DD9A8)
                            : Colors.redAccent,
                        fontWeight: FontWeight.bold)),
              );
            },
          );
        },
      ),
    );
  }
}