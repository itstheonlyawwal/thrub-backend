import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(ThrubTrading());
}

class ThrubTrading extends StatelessWidget {
  const ThrubTrading({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thrub Trading',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}


