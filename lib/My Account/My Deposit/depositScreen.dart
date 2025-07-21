import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  List<dynamic> deposits = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchDeposits();
  }

  Future<void> fetchDeposits() async {
    final url = Uri.parse("https://msebeccs.com/API/deposit.php");

    // Fetch token and userId from secure storage
    final token = await secureStorage.read(key: 'token');
    final userId = await secureStorage.read(key: 'userId');

    if (token == null || userId == null) {
      setState(() {
        error = "Missing credentials. Please login again.";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "userId": userId,
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == "true") {
        setState(() {
          deposits = jsonResponse['data'].skip(1).toList(); // Skip the headers
          isLoading = false;
        });
      } else {
        setState(() {
          error = jsonResponse['message'] ?? 'Unknown error';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit Table',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.indigo.shade100),
          columns: const [
            DataColumn(label: Text('Bond No.',style: TextStyle(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Amount',style: TextStyle(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('No. of Month',style: TextStyle(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Start Dt.',style: TextStyle(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Matu. Dt.',style: TextStyle(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text('Deposit Type',style: TextStyle(fontWeight: FontWeight.bold),)),
          ],
          rows: deposits.map((deposit) {
            return DataRow(cells: [
              DataCell(Text(deposit['bond_no'] ?? '')),
              DataCell(Text(deposit['amount'] ?? '')),
              DataCell(Text(deposit['period'] ?? '')),
              DataCell(Text(deposit['start_dt'] ?? '')),
              DataCell(Text(deposit['matu_dt'] ?? '')),
              DataCell(Text(deposit['type'] ?? '')),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
