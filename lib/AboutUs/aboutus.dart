
import 'package:flutter/material.dart';
import 'package:msebeccs/AboutUs/Overview.dart';
import 'package:msebeccs/AboutUs/annualgeneralmeeting.dart';
import 'ourschemes.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'About Us',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Title section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Welcome to Our Society!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            // Overview Button
            _buildCustomCard(
              context,
              'Overview',
              'assets/icons/overview.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Overview()),
              ),
            ),
            // Our Schemes Button
            _buildCustomCard(
              context,
              'Our Schemes',
              'assets/icons/scheme.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OurSchemes()),
              ),
            ),
            // AGM Button
            _buildCustomCard(
              context,
              'Annual General Meeting',
              'assets/icons/meeting1.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnnualGeneralMeeting()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Card Builder
  Widget _buildCustomCard(BuildContext context, String title, String iconPath, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shadowColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.deepPurpleAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.withOpacity(0.1),
                ),
                child: Center(
                  child: Image.asset(
                    iconPath,
                    width: 40,
                    height: 40,

                  ),
                ),
              ),
              SizedBox(width: 20),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}

