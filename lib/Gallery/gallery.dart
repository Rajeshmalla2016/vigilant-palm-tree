
import 'package:flutter/material.dart';
import 'package:msebeccs/Gallery/Retirements%20Felicitation/retirementsfelicitation.dart';
import 'Annual General Meeting/annualgeneralmeeting.dart';
import 'StudentsAward/studentsaward.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            Icon(Icons.photo_album, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Gallery Images',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title with some spacing
            Text(
              'Gallery Highlights',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),

            // First Button: Annual General Meeting
            _buildGalleryButton(
              context,
              'Annual General Meeting',
              'assets/icons/meeting.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Annualgeneralmeeting()),
              ),
            ),

            SizedBox(height: 20),

            // Second Button: Retirements Felicitation
            _buildGalleryButton(
              context,
              'Retirements Felicitation',
              'assets/icons/retirement.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RetirementsFelicitation()),
              ),
            ),

            SizedBox(height: 20),

            // Third Button: Students Award
            _buildGalleryButton(
              context,
              'Students Award',
              'assets/icons/stdaward.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentsAward()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable function for creating buttons with icons and text
  Widget _buildGalleryButton(BuildContext context, String label, String iconPath, VoidCallback onPressed) {
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with rounded background
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.withOpacity(0.1),
                ),
                child: Center(
                  child: Image.asset(
                    iconPath,
                    width: 30,
                    height: 30,
                   // color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(width: 20),
              // Label Text
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              // Right Arrow Icon for visual cue
              Icon(Icons.arrow_forward, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
