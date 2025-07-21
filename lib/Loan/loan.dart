import 'package:flutter/material.dart';
import 'securityloan.dart';
import 'emergencyLoan.dart';
import 'againstFixedDeposit.dart';

class Loan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_balance, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Loan Options',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Title
            Text(
              'Available Loan Types',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),

            // First Loan Button: Security Loan
            _buildLoanButton(
              context,
              'Security Loan',
              'assets/icons/Securityloan.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecurityLoan()),
              ),
            ),

            SizedBox(height: 20),

            // Second Loan Button: Emergency Loan
            _buildLoanButton(
              context,
              'Emergency Loan',
              'assets/icons/emergencyloan.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergencyLoan()),
              ),
            ),

            SizedBox(height: 20),

            // Third Loan Button: Loan Against Fixed Deposit
            _buildLoanButton(
              context,
              'Loan Against Fixed Deposit',
              'assets/icons/fixeddeposit.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoanAgainstFixedDeposit()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable function for creating styled loan buttons with icons
  Widget _buildLoanButton(BuildContext context, String label, String iconPath, VoidCallback onPressed) {
    return Card(
      elevation: 8,
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
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
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
              // Right Arrow Icon
              Icon(Icons.arrow_forward, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
