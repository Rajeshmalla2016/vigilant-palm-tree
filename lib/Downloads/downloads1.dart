import 'package:flutter/material.dart';
import 'package:msebeccs/Downloads/Download%20PDF%20Form/studentApplicationForm.dart';
import 'Download PDF Form/annualGeneralMeetingForm.dart';
import 'Download PDF Form/emergencyLoanForm.dart';
import 'Download PDF Form/MemberRegistrationForm.dart';

void main() {
  runApp(const Downloads1());
}

class Downloads1 extends StatefulWidget {
  const Downloads1({super.key});

  @override
  State<Downloads1> createState() => _Downloads1State();
}

class _Downloads1State extends State<Downloads1> {
  final List<Map<String, dynamic>> downloadItems = [
    {
      'title': 'Member Registration Form',
      'page': MemberRegistrationForm(),
    },
    {
      'title': 'Emergency Loan Form',
      'page': EmergencyLoanForm(),
    },
    {
      'title': 'Student Application Form',
      'page': StudentApplicationForm(),
    },
    {
      'title': 'AGM PDF',
      'page': AGMForm(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Row(
          children: const [
            Icon(Icons.download_rounded, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Downloads',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: downloadItems.length,
          itemBuilder: (context, index) {
            final item = downloadItems[index];
            return _buildStylishCard(item['title'], item['page']);
          },
        ),
      ),
    );
  }

  Widget _buildStylishCard(String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
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
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 70,
          shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade300, Colors.deepPurple.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.white, size: 35),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





