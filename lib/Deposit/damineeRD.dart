import 'package:flutter/material.dart';

class DamineeRD extends StatelessWidget {
  final List<Map<String, String>> content = [
    {
      'title': 'Daminee R.D.',
      'description':
      'The members have the option for monthly contribution and the period for maturity is 1 year, 2 Years, or 3 Years. The monthly contribution is Rs. 100/- or in multiples of Rs. 100/-. The rate of interest on Daminee R.D. is 7.25% P.A.',
      'icon': '💎',
    },
    {
      'title': 'Scheme Launch Date',
      'description':
      'From 01.12.2023, the Daminee RD scheme was relaunched for 1, 2, or 3 Years. Minimum monthly premium is Rs.100 or in multiples. Members can change the monthly premium anytime.',
      'icon': '📅',
    },
    {
      'title': 'Premature Withdrawal',
      'description':
      'No interest will be paid if withdrawn prematurely within 3 months.',
      'icon': '⚠️',
    },
    {
      'title': 'Flexibility',
      'description':
      'You can start your RD anytime and open multiple RDs for different durations.',
      'icon': '🔄',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.savings, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Daminee R.D. Schemes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
        builder: (context, double opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: opacity,
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
