import 'package:flutter/material.dart';
import 'home_page.dart';
import 'market_page.dart';
import 'trade_page.dart';
import 'portfolio_page.dart';
import 'more_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  late final List<Widget> _pages = [
    HomePage(onSwitchTab: switchTab),
    MarketPage(),
    TradePage(),
    PortfolioPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0F19),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0B0F19),
        selectedItemColor: Color(0xFF2DD9A8),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Markets'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Trade'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}