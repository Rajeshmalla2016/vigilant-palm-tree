import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.business, size: 30,color: Colors.white,),
            SizedBox(width: 10),
            Text(
              'Society Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[100]!, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Header
              Text(
                'Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[900],
                ),
              ),
              SizedBox(height: 10),

              // Overview Description
              Text(
                'The society was registered in the year 1986. The area of operation of the society is six districts Nagpur Division, i.e. Nagpur, Wardha, Chandrapur, Gadchiroli, Gondia and Bhandara.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Membership Information
              Text(
                'The membership of the Society at the end of "March 2024" is 3600.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Financial Information Header
              Text(
                'Financial Information (As on 31-03-2024)',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[900],
                ),
              ),
              SizedBox(height: 10),

              // Financial Details Cards
              _buildFinancialDetailsCard(
                'Membership',
                '3600 Nos.',
              ),
              _buildFinancialDetailsCard(
                'Authorised Share Capital',
                '40.00 Crores',
              ),
              _buildFinancialDetailsCard(
                'Paid Up Share Capital',
                '29.39 Crores',
              ),
              _buildFinancialDetailsCard(
                'Deposits',
                '247.52 Crores',
              ),
              _buildFinancialDetailsCard(
                'Reserve Fund',
                '13.21 Crores',
              ),
              _buildFinancialDetailsCard(
                'Thrift Fund',
                '8.92 Crores',
              ),
              _buildFinancialDetailsCard(
                'Loans (O/S) on Members',
                '286.57 Crores',
              ),
              _buildFinancialDetailsCard(
                'Investment',
                '18.54 Crores',
              ),
              _buildFinancialDetailsCard(
                'ICICI Current A/C.',
                '0.72 Crores',
              ),
              _buildFinancialDetailsCard(
                'Fixed Assets',
                '0.87 Crores',
              ),
              _buildFinancialDetailsCard(
                'Gross Income',
                '24.16 Crores',
              ),
              _buildFinancialDetailsCard(
                'Net Profit',
                '5.93 Crores',
              ),
              SizedBox(height: 20),

              // Footer Text
              Center(
                child: Text(
                  'This financial data is for informational purposes.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom function to build financial details row
  Widget _buildFinancialDetailsCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 90,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.deepPurple),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}




