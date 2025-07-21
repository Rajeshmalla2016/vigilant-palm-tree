import 'package:flutter/material.dart';
import 'damineeRD.dart';
import 'fixeddeposit.dart';
import 'shorttermfdonjal.dart';

class Deposit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_balance, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Deposit',
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
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                'Deposit Options',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Daminee RD Button
            _buildDepositButton(
              context,
              'Daminee R.D',
              'assets/icons/rd.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DamineeRD()),
              ),
            ),
            SizedBox(height: 20),

            // Fixed Deposit Button
            _buildDepositButton(
              context,
              'Fixed Deposit',
              'assets/icons/fixeddeposit.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FixedDeposit()),
              ),
            ),
            SizedBox(height: 20),

            // Short Term FD Button
            _buildDepositButton(
              context,
              'Short Term F.D (ONJAL)',
              'assets/icons/shortterm.png',
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShortTermFD()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable function to build buttons
  Widget _buildDepositButton(
      BuildContext context, String label, String iconPath, VoidCallback onPressed) {
    return Card(
      elevation: 7,
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
                spreadRadius: 1,
                blurRadius: 8,
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
              // Text
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
