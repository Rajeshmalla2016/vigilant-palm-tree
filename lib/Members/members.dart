import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Members List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Members(),
    );
  }
}

class Members extends StatelessWidget {
  final List<Map<String, String>> membersInfo = [
    {
      'title': '👥 Members',
      'description':
      'Any person designated as an Engineer & having permanent employment in any one of the companies under MSEB Holding Company i.e. MAHAVITARAN, MAHATRANSCO & MAHAGENCO.\n\nAlso working within the jurisdiction of Nagpur Region (Nagpur, Wardha, Bhandara, Chandrapur, Gadchiroli & Gondia districts) is eligible for membership of the society.\n\nThe person should be in employment for at least 6 months.'
    },
    {
      'title': '🎖️ Nominal Member',
      'description':
      'Any member as above but retired from his services.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            Icon(Icons.people_alt, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Members List',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
          itemCount: membersInfo.length,
          itemBuilder: (context, index) {
            var item = membersInfo[index];
            return _buildAnimatedCard(
              title: item['title']!,
              description: item['description']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[700],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.6,
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



