import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  late Future<List<LoanData>> futureLoans;

  @override
  void initState() {
    super.initState();
    futureLoans = fetchLoanData();
  }
/*
  Future<List<LoanData>> fetchLoanData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'userId');

    final response = await http.post(
      Uri.parse('https://msebeccs.com/API/loan.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'token': token,
        'userId': userId,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == 'true') {
        final List<dynamic> rawData = data['data'];
        return rawData.skip(1).map((e) => LoanData.fromJson(e)).toList();
      } else {
        if (data['message'] == 'There is no details present of the Member'){
          return [];
        }
        throw Exception('Failed to load: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
  *///old//
  Future<List<LoanData>> fetchLoanData() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'userId');

    final response = await http.post(
      Uri.parse('https://msebeccs.com/API/loan.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'token': token,
        'userId': userId,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Message from server: ${data['message']}');

      if (data['success'] == 'true') {
        final List<dynamic> rawData = data['data'];
        return rawData.skip(1).map((e) => LoanData.fromJson(e)).toList();
      } else {
        final message = data['message'].toString().toLowerCase();
        // Flexible match for "There is no details present..."
        if (message.contains('no details') || message.contains('no data') || message.contains('present of the number')) {
          return [];
        } else {
          throw Exception('Failed to load: ${data['message']}');
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loan Details',style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.deepPurple,),

      body: FutureBuilder<List<LoanData>>(
        future: futureLoans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 7,
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('ℹ️ There is no details present of this Member',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      )),
    ));
    }



          final loans = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.indigo.shade100),
              columns: const [
                DataColumn(label: Text('Bond No')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Installment')),
                DataColumn(label: Text('Purpose')),
                DataColumn(label: Text('Loan Type')),
                DataColumn(label: Text('Surety 1')),
                DataColumn(label: Text('Surety 2')),
                DataColumn(label: Text('Surety 3')),
              ],
              rows: loans.map((loan) {
                return DataRow(cells: [
                  DataCell(Text(loan.bondNo)),
                  DataCell(Text(loan.amount)),
                  DataCell(Text(loan.date)),
                  DataCell(Text(loan.installment)),
                  DataCell(Text(loan.purpose)),
                  DataCell(Text(loan.loanType)),
                  DataCell(Text(loan.surety1)),
                  DataCell(Text(loan.surety2)),
                  DataCell(Text(loan.surety3)),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class LoanData {
  final String bondNo;
  final String amount;
  final String date;
  final String installment;
  final String purpose;
  final String loanType;
  final String surety1;
  final String surety2;
  final String surety3;

  LoanData({
    required this.bondNo,
    required this.amount,
    required this.date,
    required this.installment,
    required this.purpose,
    required this.loanType,
    required this.surety1,
    required this.surety2,
    required this.surety3,
  });

  factory LoanData.fromJson(Map<String, dynamic> json) {
    return LoanData(
      bondNo: json['bond_no'] ?? '',
      amount: json['amount'] ?? '',
      date: json['date'] ?? '',
      installment: json['inst_no'] ?? '',
      purpose: json['purpose'] ?? '',
      loanType: json['laon_type'] ?? '',
      surety1: json['surety1'] ?? '',
      surety2: json['surety2'] ?? '',
      surety3: json['surety3'] ?? '',
    );
  }
}

