import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithdrawPage extends StatefulWidget {
  final double balance;

  const WithdrawPage({super.key, this.balance = 0.0});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  static const Color _bgColor = Color(0xFF0A0D14);
  static const Color _cardColor = Color(0xFF101722);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);
  static const Color _fieldColor = Color(0xFF0A0E16);
  static const Color _errorColor = Color(0xFFEF5350);
  static const Color _amberColor = Color(0xFFE5A93C);
  static const Color _labelColor = Color(0xFF7D8699);

  static const double _minWithdraw = 5.0;

  // Network name -> address pattern
  static final Map<String, RegExp> _networks = {
    'USDT - BEP20 (BSC)': RegExp(r'^0x[a-fA-F0-9]{40}$'),
    'USDT - ERC20 (Ethereum)': RegExp(r'^0x[a-fA-F0-9]{40}$'),
    'USDT - TRC20 (Tron)': RegExp(r'^T[a-zA-Z0-9]{33}$'),
  };

  late String _network = _networks.keys.first;
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _withdraw() async {
    final address = _addressController.text.trim();
    final amount = double.tryParse(_amountController.text);

    String? error;
    if (address.isEmpty) {
      error = 'Please enter an address.';
    } else if (!_networks[_network]!.hasMatch(address)) {
      error = 'Please enter a valid address.';
    } else if (amount == null || amount <= 0) {
      error = 'Please enter a valid amount.';
    } else if (amount < _minWithdraw) {
      error =
      'Minimum withdraw amount is \$${_minWithdraw.toStringAsFixed(0)}.';
    } else if (amount > widget.balance) {
      error = 'Insufficient balance.';
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() {
      _error = null;
      _success = true;
    });

    // TODO: replace with real backend withdraw call / API call
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;

    setState(() => _success = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardColor,
        content: Text(
          'Withdrawal of \$${amount!.toStringAsFixed(2)} requested (simulated).',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    Navigator.pop(context);
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _labelColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hint, String? prefix}) {
    const normal = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: _borderColor),
    );
    const focused = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: _amberColor),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.grey[600], fontSize: 22),
      filled: true,
      fillColor: _fieldColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: normal,
      enabledBorder: normal,
      focusedBorder: focused,

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: _cardColor,
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: _labelColor,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Withdraw',
                            style: TextStyle(
                              color: _fieldColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Available balance: ',
                                  style: TextStyle(
                                    color: _labelColor,
                                    fontSize: 13,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  '\$${widget.balance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: _tealColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(fontSize: 13), // font family
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: _borderColor, height: 1),

                //Form
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label('Network'),
                          Text(
                            'min \$${_minWithdraw.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: _amberColor,
                              fontSize: 14,
                            ), // font family
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: _fieldColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _network,
                            isExpanded: true,
                            dropdownColor: _cardColor,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: _labelColor,
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            items: _networks.keys.map((network) {
                              return DropdownMenuItem<String>(
                                value: network,
                                child: Text(network),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _network = value;
                                  _error = null;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      _label('DESTINATION ADDRESS'),
                      SizedBox(height: 12),
                      TextField(
                        controller: _addressController,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: _fieldDecoration(
                          hint: 'Paste your wallet address',
                        ),
                      ),
                      SizedBox(height: 24),

                      _label('AMOUNT (USD)'),
                      SizedBox(height: 12),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        style: TextStyle(color: Colors.white, fontSize: 22),
                        // font family
                        decoration: _fieldDecoration(
                          hint: '0.00',
                          prefix: '\$',
                        ),
                      ),

                      if (_error != null) ...[
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _errorColor,
                            border: Border.all(color: _errorColor),
                          ),
                          child: Text(
                            _error!,
                            style: TextStyle(color: _errorColor, fontSize: 14),
                          ),
                        ),
                      ],
                      SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 90 * 0.62,
                        child: ElevatedButton(
                          onPressed: _success ? null : _withdraw,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tealColor,
                            disabledBackgroundColor: _borderColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: _success
                              ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            'Request Withdraw',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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








try {
// TODO: replace with your real login call
await Future.delayed(Duration(seconds: 1));
if (email.isEmpty || password.isEmpty) {
setState(() => _error = 'Invalid email or password.');
return; //stops here to confirm the password is correct
}




// TODO: replace with your real sign-up call
await Future.delayed(Duration(seconds: 1));
UserSession.instance.username = _usernameController.text.trim();

if (username.isEmpty || email.isEmpty || password.isEmpty) {
setState(() => _error = 'Please fill in all required fields.');
return;
}