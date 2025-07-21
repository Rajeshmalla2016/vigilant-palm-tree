
import 'package:flutter/material.dart';
import 'package:msebeccs/Body%20Members/Director%20Body/directorbody.dart';
import 'package:msebeccs/Body%20Members/Loan%20Committee/loancommittee.dart';

class BodyMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.group, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Body Members',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            // Director Body Button
            _buildButton(
              context,
              'Director Body',
              'assets/icons/directorbody.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DirectorBody()),
              ),
            ),
            SizedBox(height: 30),
            // Loan Committee Button
            _buildButton(
              context,
              'Loan Committee',
              'assets/icons/commite.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoanCommittee()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom reusable button
  Widget _buildButton(BuildContext context, String label, String iconPath, VoidCallback onPressed) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
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

                  ),
                ),
              ),
              SizedBox(width: 20),
              // Title Text
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
              Icon(Icons.arrow_forward, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
