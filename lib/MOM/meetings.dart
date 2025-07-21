import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minutes of Meeting',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: Meeting(),
    );
  }
}

class Meeting extends StatelessWidget {
  final List<String> minutes = [
    "1) The Minutes of last month meeting were read out and confirmed.",
    "2) The Receipt & Payment along with income & expenditure for the M/o DECEMBER-2024 was approved.",
    "3) The New Membership of 10 applicants was approved.",
    "4) The withdrawal of membership of 05 members was accepted.",
    "5) Loan sanctioned by the loan committee during the month was approved.",
    "6) It was resolved to grant medical Aid of Rs.20,000/- to Er. Tushar K Thombre (M.No.6541) of CSTPS.",
    "7) It was resolved to Renew the CC Limit of Rs.10.00 Crs of Nagpur District Central Cooperative Bank (NDCCB) for year 2025-2026.",
    "8) It was resolved to call quotations for development of Mobile App of Society.",
    "9) It was resolved to place work order for EDP Audit & Data Migration audit to CA M/s A.A Kohale & Company, Nagpur."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Minutes of Meeting",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section title
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "Brief of January 2025 Meeting",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.deepPurpleAccent,
              indent: 50,
              endIndent: 50,
            ),
            const SizedBox(height: 10),

            // Expanded list view
            Expanded(
              child: ListView.builder(
                itemCount: minutes.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 600 + index * 100),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          minutes[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
