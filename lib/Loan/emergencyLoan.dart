import 'package:flutter/material.dart';

class EmergencyLoan extends StatelessWidget {
  final List<Map<String, String>> emergencyLoanInfo = [
    {
      'title': 'Emergency Loan',
      'description':
      'The Emergency Loan limit to an individual is Rs. 80,000/- with a maximum of 12 Nos. of installments for repayment. The rate of interest is 09.25%.',
      'icon': '🚨',
    },
    {
      'title': 'No Surety Required',
      'description': 'No surety is required for sanctioning of such loan.',
      'icon': '✅',
    },
    {
      'title': 'Outstanding Loan Adjustment',
      'description':
      'The outstanding loan, if any, will be adjusted while sanctioning the new loan.',
      'icon': '🔄',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Emergency Loan Details',
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
          itemCount: emergencyLoanInfo.length,
          itemBuilder: (context, index) {
            var item = emergencyLoanInfo[index];
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

