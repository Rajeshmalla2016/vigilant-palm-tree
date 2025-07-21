import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:msebeccs/main.dart';
//import 'package:flutter_table/flutter_table.dart';

void main() {
  runApp(EMICalculatorApp());
}

class EMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EMIHomePage(),
    );
  }
}

class EMIHomePage extends StatefulWidget {
  @override
  _EMIHomePageState createState() => _EMIHomePageState();
}

class _EMIHomePageState extends State<EMIHomePage> {
  TextEditingController principalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController monthsController = TextEditingController();

  double resultEMI = 0;
  double totalInterest = 0;
  double totalAmount = 0;
  List<List<String>> tableData = [];

  void calculateNormalEMI() {
    double principal = double.parse(principalController.text);
    double rate = double.parse(rateController.text) / 12 / 100;
    int months = int.parse(monthsController.text);

    // Normal EMI Calculation
    double emi = (principal * rate * pow(1 + rate, months)) / (pow(1 + rate, months) - 1);
    double totalPayment = emi * months;
    double interest = totalPayment - principal;

    setState(() {
      resultEMI = emi;
      totalInterest = interest;
      totalAmount = totalPayment;
      tableData = _generateTableData(principal, rate, emi, months, totalPayment, interest);
    });
  }

  List<List<String>> _generateTableData(
      double principal, double rate, double emi, int months, double totalPayment, double interest) {
    List<List<String>> table = [];
    table.add(["Month", "EMI", "Principal", "Interest", "Balance"]);

    double outstandingPrincipal = principal;
    for (int i = 1; i <= months; i++) {
      double interestForMonth = outstandingPrincipal * rate;
      double principalPaid = emi - interestForMonth;
      double balance = outstandingPrincipal - principalPaid;

      table.add([
        "$i",
        "₹${emi.toStringAsFixed(2)}",
        "₹${principalPaid.toStringAsFixed(2)}",
        "₹${interestForMonth.toStringAsFixed(2)}",
        "₹${balance.toStringAsFixed(2)}"
      ]);

      outstandingPrincipal -= principalPaid;
    }

    return table;
  }

  void calculateReducingEMI() {
    double principal = double.parse(principalController.text);
    double rate = double.parse(rateController.text) / 12 / 100;
    int months = int.parse(monthsController.text);

    double totalPayment = 0;
    double totalInterest = 0;
    List<List<String>> table = [];
    table.add(["Month", "EMI", "Principal", "Interest", "Balance"]);

    double outstandingPrincipal = principal;
    for (int i = 1; i <= months; i++) {
      double interestForMonth = outstandingPrincipal * rate;
      double principalPaid = principal / months;
      double emi = interestForMonth + principalPaid;
      double balance = outstandingPrincipal - principalPaid;

      table.add([
        "$i",
        "₹${emi.toStringAsFixed(2)}",
        "₹${principalPaid.toStringAsFixed(2)}",
        "₹${interestForMonth.toStringAsFixed(2)}",
        "₹${balance.toStringAsFixed(2)}"
      ]);

      totalPayment += emi;
      totalInterest += interestForMonth;
      outstandingPrincipal -= principalPaid;
    }

    setState(() {
      resultEMI = totalPayment / months;
      totalAmount = totalPayment;
      this.totalInterest = totalInterest;
      tableData = table;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: '')));///////////////
          },
        ),
        title: Text("EMI Calculator",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.calculator,color: Colors.white,),
            onPressed: (){},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: principalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Loan Amount (₹)"),
              ),
              TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Annual Interest Rate (%)"),
              ),
              TextField(
                controller: monthsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Loan Tenure (Months)"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateNormalEMI,
                child: Text("Calculate Normal EMI"),
              ),
              ElevatedButton(
                onPressed: calculateReducingEMI,
                child: Text("Calculate Reducing EMI"),
              ),
              SizedBox(height: 20),
              Table(
                border: TableBorder.all(),
                children: tableData.map((row) {
                  return TableRow(
                    children: row.map((cell) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(cell, textAlign: TextAlign.center),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text("Monthly EMI: ₹${resultEMI.toStringAsFixed(2)}"),
              Text("Total Interest: ₹${totalInterest.toStringAsFixed(2)}"),
              Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    );
  }
}
