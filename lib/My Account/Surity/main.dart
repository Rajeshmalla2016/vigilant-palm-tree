
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'welcome_model.dart';

void main() {
  runApp(SuretyApp());
}

class SuretyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surety API',
      home: SuretyPage(),
    );
  }
}

class SuretyPage extends StatefulWidget {
  @override
  _SuretyPageState createState() => _SuretyPageState();
}

class _SuretyPageState extends State<SuretyPage> {
  // Create a Future to fetch the data asynchronously
  Future<Welcome> fetchSuretyData() async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'token');
    final userId = await secureStorage.read(key: 'userId');

    final url = Uri.parse('https://msebeccs.com/API/surety.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "userId": userId,
      "token": token,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final welcome = welcomeFromJson(response.body);
      return welcome;
    } catch (e) {
      throw Exception('No Surety Details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Surety Details',style: TextStyle(color: Colors.white),),backgroundColor: Colors.deepPurple,),

      body: FutureBuilder<Welcome>(
        future: fetchSuretyData(), // Fetch data asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading spinner
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
            final welcomeData = snapshot.data!;
            //final data = welcomeData.data[0]; // Assuming there's only one entry for this user
            final data = welcomeData.data.first;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                /*
                children: [
                  // Surety Given Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Given Surety To', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ..._buildSuretyList(data.suretyGiven1, data.suretyGiven2, data.suretyGiven3),
                        ],
                      ),
                    ),
                  ),

                  // Surety Taken Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Surety Taken From', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ..._buildSuretyList(data.suretyTaken1, data.suretyTaken2, data.suretyTaken3),
                        ],
                      ),
                    ),
                  ),

                  // Dividend Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DIVIDEND 2024', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Amount: Rs. ${data.devidendAmt}', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ], *///1//
                /*
                children: [

                  // Surety Given Card (Only show if at least one is not empty)
                  if ([data.suretyGiven1, data.suretyGiven2, data.suretyGiven3].any((s) => s.isNotEmpty))
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Given Surety To', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            ..._buildSuretyList(data.suretyGiven1, data.suretyGiven2, data.suretyGiven3),
                          ],
                        ),
                      ),
                    ),

                  // Surety Taken Card (Only show if at least one is not empty)
                  if ([data.suretyTaken1, data.suretyTaken2, data.suretyTaken3].any((s) => s.isNotEmpty))
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Surety Taken From', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            ..._buildSuretyList(data.suretyTaken1, data.suretyTaken2, data.suretyTaken3),
                          ],
                        ),
                      ),
                    ),

                  // Dividend Card (Only show if amount is not empty)
                  if (data.devidendAmt.isNotEmpty)
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.devidendHead.isNotEmpty ? data.devidendHead : 'DIVIDEND', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text('Amount: Rs. ${data.devidendAmt}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                ],

                 *///2//
                children: [
                  // Surety Given Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Given Surety To', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ..._buildSuretyListOrEmpty(data.suretyGiven1, data.suretyGiven2, data.suretyGiven3),
                        ],
                      ),
                    ),
                  ),

                  // Surety Taken Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Surety Taken From', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ..._buildSuretyListOrEmpty(data.suretyTaken1, data.suretyTaken2, data.suretyTaken3),
                        ],
                      ),
                    ),
                  ),

                  /*
                  // Dividend Card
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.devidendHead.isNotEmpty ? data.devidendHead : 'DIVIDEND 2024', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Amount: Rs. ${data.devidendAmt.isNotEmpty ? data.devidendAmt : "Empty"}', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),

                   */
                  // Conditional Dividend Section
                  data.devidendAmt.isNotEmpty
                      ? Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.devidendHead.isNotEmpty ? data.devidendHead : 'DIVIDEND 2024',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Amount: Rs. ${data.devidendAmt}', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No Dividend Information',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available')); // Show when no data is found
          }
        },
      ),
    );
  }

  /*
  // Helper method to build surety list
  List<Widget> _buildSuretyList(String given1, String given2, String given3)
  {
    List<String> suretyList = [given1, given2, given3];
    List<Widget> widgets = [];

    for (int i = 0; i < suretyList.length; i++) {
      if (suretyList[i].isNotEmpty) {
        widgets.add(
          Text('${i + 1}. ${suretyList[i]}', style: TextStyle(fontSize: 16)),
        );
      }
    }
    return widgets;
  }

   */
  List<Widget> _buildSuretyListOrEmpty(String s1, String s2, String s3) {
    List<String> suretyList = [s1, s2, s3].where((s) => s.isNotEmpty).toList();

    if (suretyList.isEmpty) {
      return [Text("No Information", style: TextStyle(fontSize: 16, color: Colors.grey))];
    }

    return List.generate(suretyList.length, (i) {
      return Text('${i + 1}. ${suretyList[i]}', style: TextStyle(fontSize: 16));
    });
  }



}



