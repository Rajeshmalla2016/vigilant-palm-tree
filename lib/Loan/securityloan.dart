import 'package:flutter/material.dart';

class SecurityLoan extends StatelessWidget {
  final List<Map<String, String>> securityLoanInfo = [
    {
      'title': 'Security Loan',
      'description':
      'Loan limit to an individual member is Rs. 35,00,000/- with the option for repayment on a monthly reducing basis.',
      'icon': '💰',
    },
    {
      'title': 'Insurance Amount',
      'description':
      'Insurance amount of Rs. 5000.00 per 1 lakh deposited after 25 lakh of loan. (e.g., if you get a loan for 35 lakh, the insurance amount will be Rs. 50,000).',
      'icon': '🛡️',
    },
    {
      'title': 'Equity Monthly Installment',
      'description': 'The rate of interest is 09.25%.',
      'icon': '📊',
    },
    {
      'title': 'Maximum Installments',
      'description':
      'The maximum number of installments for the repayment of the Security Loan is 180 Nos.',
      'icon': '⏱️',
    },
    {
      'title': 'Loan up to Rs.18,00,000',
      'description':
      'Loan applied up to Rs. 18,00,000/- requires Two Surety/Guarantors from existing members to stand as sureties for the loan.',
      'icon': '🤝',
    },
    {
      'title': 'Loan Above Rs.18,00,000',
      'description':
      'Loan applied for above Rs.18,00,000/- up to Rs. 35,00,000/- requires Three Surety/Guarantors from existing members to stand as sureties for the loan.',
      'icon': '👥',
    },
    {
      'title': 'Surety Limit per Member',
      'description':
      'Each member can stand surety for a maximum of three borrowers.',
      'icon': '🔒',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Security Loan Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.deepPurpleAccent,
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
          itemCount: securityLoanInfo.length,
          itemBuilder: (context, index) {
            var item = securityLoanInfo[index];
            return _buildAnimatedCard(
              iconEmoji: item['icon'] ?? '💼',
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 600),
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
          elevation: 8,
          shadowColor: Colors.deepPurpleAccent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  iconEmoji,
                  style: TextStyle(fontSize: 32),
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
