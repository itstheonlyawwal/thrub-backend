import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepositPage extends StatefulWidget {
  final double balance;
  const DepositPage({super.key, this.balance = 0.0});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  static const _bg = Color(0xFF0A0D14);
  static const _card = Color(0xFF0F1620);
  static const _field = Color(0xFF080B11);
  static const _border = Color(0xFF1E2733);
  static const _teal = Color(0xFF2ED9A8);
  static const _amber = Color(0xFFE5A53A);
  static const _muted = Color(0xFF7C8796);

  static const _tokens = ['USDT'];
  static const _networks = ['BEP20 (BSC)', 'TRC20 (TRON)', 'BTC (Bitcoin)'];
  static const double _minDeposit = 3;

  final _amountCtrl = TextEditingController();
  String _token = _tokens.first;
  String _network = _networks.first;
  String? _error;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _generate() {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount < _minDeposit) {
      setState(() => _error = 'Minimum deposit is \$${_minDeposit.toStringAsFixed(0)}.');
      return;
    }
    setState(() => _error = null);
    // TODO: call your backend to generate the deposit address
    debugPrint('Generate address: $_token / $_network / $amount');
  }

  TextStyle get _label => TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    letterSpacing: 1.2,
    color: _muted,
  );

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _field,
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: _card,
          icon: Icon(Icons.keyboard_arrow_down, color: _muted, size: 20),
          style: TextStyle(color: Colors.white, fontSize: 18),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Container(
            decoration: BoxDecoration(
              color: _card,
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(Icons.chevron_left, color: _muted, size: 28),
                        ),
                      ),
                      SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deposit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(fontFamily: 'monospace', fontSize: 15),
                                children: [
                                  TextSpan(text: 'Balance: ', style: TextStyle(color: _muted)),
                                  TextSpan(
                                    text: '\$${widget.balance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(Icons.close, color: _muted, size: 26),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: _border),

                // Body
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_error != null) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A1215),
                            border: Border.all(color: Color(0xFF7A2A2F)),
                          ),
                          child: Text(_error!,
                              style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 13)),
                        ),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TOKEN', style: _label),
                                SizedBox(height: 12),
                                _dropdown(
                                  value: _token,
                                  items: _tokens,
                                  onChanged: (v) => setState(() => _token = v),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('NETWORK', style: _label),
                                    Text(
                                      'Min \$${_minDeposit.toStringAsFixed(0)}',
                                      style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: _amber,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                _dropdown(
                                  value: _network,
                                  items: _networks,
                                  onChanged: (v) => setState(() => _network = v),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text('AMOUNT (USD)', style: _label),
                      SizedBox(height: 12),
                      TextField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        style: TextStyle(
                            fontFamily: 'monospace', fontSize: 24, color: Colors.white),
                        cursorColor: _teal,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _field,
                          hintText: '0.00',
                          hintStyle: TextStyle(
                              fontFamily: 'monospace', fontSize: 24, color: Color(0xFF3A4452)),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 16, right: 12),
                            child: Text('\$',
                                style: TextStyle(fontSize: 24, color: _muted)),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          contentPadding: EdgeInsets.symmetric(vertical: 22),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: _border)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: _border)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: _teal)),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 90 * 0.6,
                        child: ElevatedButton(
                          onPressed: _generate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _teal,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(),
                          ),
                          child: Text(
                            'Generate Address',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}