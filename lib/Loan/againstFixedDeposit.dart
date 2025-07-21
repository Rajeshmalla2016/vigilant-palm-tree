import 'package:flutter/material.dart';

class LoanAgainstFixedDeposit extends StatelessWidget {
  final List<Map<String, String>> loanAgainstFDInfo = [
    {
      'title': 'Loan Against Fixed Deposit',
      'description':
      'The Loan Against Fixed Deposit is also granted to the members up to 80% of the Fixed Deposit (Principal) Amount.',
      'icon': '🏦',
    },
    {
      'title': 'Rate of Interest',
      'description':
      'The rate of interest on such loan is at the rate of interest of the ordinary loan, subject to such rate shall not be less than the rate of interest on respective FDR.',
      'icon': '💰',
    },
    {
      'title': 'Refund Facility',
      'description':
      'The member has the facility to refund such loan in onetime payment (lump sum) to the society.',
      'icon': '🔄',
    },
    {
      'title': 'No Recovery via Monthly Dues',
      'description':
      'Further, no recovery of loan on FDR account is raised through the society monthly demand dues.',
      'icon': '❌📆',
    },
    {
      'title': 'Loan Adjustment on FD Maturity',
      'description':
      'On maturity of such FD’s against which the loan was sanctioned, the loan outstanding along with the interest recoverable, is adjusted against such FDR maturity amount, and the balance is refunded to the members.',
      'icon': '📈',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Loan Against Fixed Deposit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 8,
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
          itemCount: loanAgainstFDInfo.length,
          itemBuilder: (context, index) {
            var item = loanAgainstFDInfo[index];
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, (1 - opacity) * 20),
              child: child,
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          shadowColor: Colors.deepPurpleAccent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  iconEmoji,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
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
