import 'package:flutter/material.dart';

class FixedDeposit extends StatelessWidget {
  final List<Map<String, String>> content = [
    {
      'title': 'Fixed Deposit',
      'description':
      'The existing rate of interest on the Fixed Deposit for regular members is 7.75% p.a. and 8.00% p.a. with the added facility to our nominal members (Retired members) for Monthly Interest Payment on their Fixed Deposits.',
      'icon': '💰',
    },
    {
      'title': 'Reinvestment & Repayment',
      'description':
      'A member has the facility of partial reinvestment of the Fixed Deposit and Partial Repayment on Maturity or Prematurity.',
      'icon': '🔁',
    },
    {
      'title': 'Transfer Facility',
      'description':
      'Members can transfer their Fixed Deposit amount on Maturity or Prematurity to Short Term Fixed Deposit, Ordinary Loan, or Emergency Loan.',
      'icon': '🔄',
    },
    {
      'title': 'Old F.D.R. Sealing',
      'description':
      'Old F.D.R. Sealing for 50 Lakhs per Member and above for 50 lakhs refund for maturity.',
      'icon': '📑',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Fixed Deposit Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            var item = content[index];
            return _buildAnimatedCard(
              iconEmoji: item['icon'] ?? '📄',
              title: item['title']!,
              description: item['description']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String iconEmoji,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          shadowColor: Colors.deepPurpleAccent,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  iconEmoji,
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
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
