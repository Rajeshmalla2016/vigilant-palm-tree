

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OurSchemes extends StatelessWidget {
   OurSchemes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Our Schemes',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 90,
        shadowColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          children: [
            _headerCard(),
            ..._schemes.map((scheme) => _buildAnimatedCard(context, scheme)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.lightbulb, color: Colors.white, size: 48),
            SizedBox(height: 10),
            Text(
              "Explore Our Unique Benefit Schemes",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context, Scheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          elevation: 90,
          shadowColor: Colors.deepPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(scheme.icon, color: Colors.deepPurple, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheme.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple.shade900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        scheme.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade800,
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

  final List<Scheme> _schemes = [
    Scheme(Icons.savings, 'Thrift Fund',
        'Through this Thrift Fund we are operating five different schemes.'),
    Scheme(Icons.shield, 'Group Insurance Scheme',
        'Coverage of assured sum of Rs. 25,00,000/- is given to every existing member.'),
    Scheme(Icons.local_hospital, 'Medical Aid To Member',
        'For members with serious diseases, up to Rs.20,000/- is given as medical aid.'),
    Scheme(Icons.healing, 'Sanjeevani Scheme',
        'Non-interest medical relief advance up to Rs.3,00,000/- for emergencies.'),
    Scheme(Icons.family_restroom, 'Medical Relief for Family',
        'Up to Rs.3,00,000/- provided to cover medical emergencies for family.'),
    Scheme(Icons.check_circle, 'Arogya Vibhav Yojana',
        'Health checkup scheme for regular and retired members at Renbo Medinova.'),
    Scheme(Icons.emoji_nature, 'Mrigchhaya Scheme',
        'Retired members can receive Rs.10,000/- or 0.5% extra as medical aid.'),
    Scheme(Icons.star, 'Awards to Meritorious Children',
        'Cash prizes and certificates for children excelling in exams.'),
  ];
}

class Scheme {
  final IconData icon;
  final String title;
  final String description;

  Scheme(this.icon, this.title, this.description);
}



