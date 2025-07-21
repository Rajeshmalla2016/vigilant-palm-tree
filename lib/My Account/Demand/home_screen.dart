import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';
import 'financial_data.dart';

class HomeScreenD extends StatefulWidget {
  const HomeScreenD({super.key});

  @override
  State<HomeScreenD> createState() => _HomeScreenDState();
}

class _HomeScreenDState extends State<HomeScreenD> {
  late Future<List<FinancialData>> futureData= Future.value([]);

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserCredentialsAndFetchData();
  }

  Future<void> _loadUserCredentialsAndFetchData() async {
    try{
    final String? userId = await _storage.read(key: 'userId');
    final String? token = await _storage.read(key: 'token');

    debugPrint('👤 userId from storage: $userId');
    debugPrint('🔑 token from storage: $token');

    if (userId != null && token != null && userId.isNotEmpty && token.isNotEmpty) {
      setState(() {
        futureData = ApiService(userId: userId, token: token).fetchFinancialData();
      });
    } else {
      // This helps you debug
      debugPrint("Missing credentials: userId = $userId, token = $token");

      // Show user-friendly message instead of crashing
      setState(() {
        futureData = Future.error("You are not logged in properly. Please log in again.");
      });
    }
  }
    catch (e, stackTrace) {
      debugPrint("🔥 Exception during _loadUserCredentialsAndFetchData: $e");
      debugPrint("📌 StackTrace: $stackTrace");
      setState(() {
        futureData = Future.error("An unexpected error occurred.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demand Table",style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple,),
      body: FutureBuilder<List<FinancialData>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data found."));
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateProperty.all(Colors.indigo.shade100),
                      columns: const [
                        DataColumn(label: Text('Month',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('DRD',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('RRD',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Share',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('TF',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('S.L Pri',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('S.L Int',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('S.L Pen',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('E.L Pri',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('E.L Int',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('E.L Pen',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Total',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Share Balance',style: TextStyle(fontWeight: FontWeight.bold),)),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(cells: [
                          DataCell(Text(data.month)),
                          DataCell(Text(data.drd)),
                          DataCell(Text(data.rrd)),
                          DataCell(Text(data.sc)),
                          DataCell(Text(data.tf)),
                          DataCell(Text(data.slp)),             // LTL Loan
                          DataCell(Text(data.sli)),             // LTL Interest
                          DataCell(Text(data.slpe)),            // LTL Penalty
                          DataCell(Text(data.elp)),             // STL Loan
                          DataCell(Text(data.eli)),             // STL Interest
                          DataCell(Text(data.elpe)),            // STL Penalty
                          DataCell(Text(data.tot)),             // Total
                          DataCell(Text(data.scbal)),           // Share Balance
                        ]);
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                      shadowColor: Colors.deepPurpleAccent.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 25,
                                    width: 25,
                                    child: Image.asset('assets/icons/about_us.png')),
                                const SizedBox(width: 10),
                                const Text(
                                  "Note for Users",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text.rich(
                              TextSpan(
                                style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                                children: [
                                  TextSpan(text: '• DRD → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Daminee Recurring deposits\n'),
                                  TextSpan(text: '• RRD → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Regular Recurring deposits\n'),
                                  TextSpan(text: '• TF → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Thrift Fund\n'),
                                  TextSpan(text: '• S.L Pri → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Security Loan Principal\n'),
                                  TextSpan(text: '• S.L Int → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Security Loan Interest\n'),
                                  TextSpan(text: '• S.L Pen → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Security Loan Penalty\n'),
                                  TextSpan(text: '• E.L Pri → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Emergency Loan Principal\n'),
                                  TextSpan(text: '• E.L Int → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Emergency Loan Interest\n'),
                                  TextSpan(text: '• E.L Pen → ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'Emergency Loan Penalty\n'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
            }
        },
      ),
    );
  }
}




