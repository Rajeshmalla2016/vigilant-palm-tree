import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Term F.D. (ONJAL) Details',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ShortTermFD(),
    );
  }
}

class ShortTermFD extends StatelessWidget {
  final List<Map<String, String>> content = [
    {
      'title': 'Short Term F.D. (ONJAL)',
      'description':
      'The minimum amount for opening the account in this scheme is Rs. 5000/-. The rate of interest is 5.75% P. A. with sixty day compounding. The minimum period of maturity is sixty days.',
      'icon': '🏦',
    },
    {
      'title': 'Partial Withdrawal',
      'description':
      'Partial withdrawal is also allowed. Every member is eligible to deposit any amount in multiple of Rs. 1000/- for number of times and can withdraw the amount as required, provided that the balance in the account will not be less than Rs. 5000/-.',
      'icon': '💸',
    },
    {
      'title': 'Account Closure Condition',
      'description':
      'If the balance at any time of withdrawal goes below Rs. 5000/- the complete amount will be refunded and the account will be closed.',
      'icon': '⚠️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_balance, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Short Term F.D. (ONJAL)',
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
          padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
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

