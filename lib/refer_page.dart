import 'package:flutter/material.dart';
import 'user_session.dart';

class ReferPage extends StatelessWidget {
  const ReferPage({super.key});

  static const Color _bgColor = Color(0xFF0B0F19);
  static const Color _cardColor = Color(0xFF141924);
  static const Color _tealColor = Color(0xFF2DD9A8);
  static const Color _borderColor = Color(0xFF232938);

  String get _referralLink {
    final username = UserSession.instance.username ?? 'guest';
    return 'https://throbtrading.com/register?ref=$username';
  }

  Widget _buildStat(String label, Widget valueWidget) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, letterSpacing: 1)),
          SizedBox(height: 10),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildEarnCard(String percent, String label, String title, String description) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _borderColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(percent, style: TextStyle(color: _tealColor, fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10, letterSpacing: 0.5)),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 6),
                Text(description, style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsRow(String label, String value, {bool isTotal = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? _tealColor : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invite',
                    style: TextStyle(color: _tealColor, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('\$0.00', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Invitation link card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardColor,
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INVITATION LINK', style: TextStyle(color: Colors.grey[500], fontSize: 11, letterSpacing: 1)),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _referralLink,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            // TODO: use Clipboard.setData(ClipboardData(text: _referralLink))
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Link copied (simulated)')),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: _borderColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('COPY', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: hook up share_plus package to share _referralLink
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Share sheet coming soon')),
                          );
                        },
                        icon: Icon(Icons.share, color: Colors.black, size: 18),
                        label: Text('Share invitation', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _tealColor,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Invited / Trading / Earned stats
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildStat('INVITED', const Text('0', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                    _buildStat('TRADING', const Text('0', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                    _buildStat('EARNED', const Text('\$', style: TextStyle(color: _tealColor, fontSize: 20, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              SizedBox(height: 24),

              Text('HOW YOU EARN', style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: _cardColor,
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildEarnCard(
                      '5%',
                      'FIRST TRADE',
                      'Their first trade',
                      'Once per person you invite, you earn 5% of the size of their very first trade — a \$200 first trade pays you \$10.',
                    ),
                    _buildEarnCard(
                      '5%',
                      'OF FUTURE\nPROFITS',
                      'Their profit',
                      "You earn 5% of your invitee's net profit, each time a closed trade lifts their total to a new high. Winning back earlier losses doesn't pay — only new profit does.",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Direct invitees only — no levels. Rewards are paid on top: what your friend earns or loses is never touched.",
                        style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              Text('YOUR EARNINGS', style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: _cardColor,
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildEarningsRow('First-trade rewards', '\$0.00'),
                    _buildEarningsRow('Profit share', '\$0.00'),
                    _buildEarningsRow('Total', '\$0.00', isTotal: true),
                  ],
                ),
              ),
              SizedBox(height: 24),

              Text('YOUR INVITEES', style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1)),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _cardColor,
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "No one has joined with your code yet.\nShare it above — they'll show up here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 24),

              Text('REWARD HISTORY', style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1)),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _cardColor,
                  border: Border.all(color: _borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Rewards appear here as your invitees trade.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}