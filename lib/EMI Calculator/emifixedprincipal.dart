import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reducing Balance EMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoanCalculator(),
    );
  }
}

class LoanCalculator extends StatefulWidget {
  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  String _emiResult = "EMI will be displayed here.";
  List<Map<String, String>> _paymentSchedule = [];

  // Function to calculate EMI using the Reducing Balance Method
  void calculateEMI() {
    double principal = double.tryParse(_principalController.text) ?? 0;
    double annualRate = double.tryParse(_rateController.text) ?? 0;
    int tenure = int.tryParse(_tenureController.text) ?? 0;

    // Validate inputs
    if (principal <= 0 || annualRate <= 0 || tenure <= 0) {
      setState(() {
        _emiResult = "Please enter valid values for all fields!";
      });
      return;
    }

    // Monthly interest rate
    double monthlyRate = (annualRate / 12) / 100;

    // Apply the EMI formula
    double emi = (principal * monthlyRate * pow(1 + monthlyRate, tenure)) /
        (pow(1 + monthlyRate, tenure) - 1);

    // Calculate the payment schedule
    double remainingPrincipal = principal;
    List<Map<String, String>> paymentSchedule = [];

    for (int month = 1; month <= tenure; month++) {
      double interestForMonth = remainingPrincipal * monthlyRate;
      double principalPayment = emi - interestForMonth;
      remainingPrincipal -= principalPayment;

      paymentSchedule.add({
        "Month": month.toString(),
        "EMI": emi.toStringAsFixed(2),
        "Principal Payment": principalPayment.toStringAsFixed(2),
        "Interest Payment": interestForMonth.toStringAsFixed(2),
        "Remaining Balance": remainingPrincipal.toStringAsFixed(2),
      });
    }

    setState(() {
      _emiResult = "Your EMI is: ₹${emi.toStringAsFixed(2)}";
      _paymentSchedule = paymentSchedule;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reducing Balance EMI Calculator"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _principalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Principal Loan Amount (₹)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Annual Interest Rate (%)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tenureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Loan Tenure (Months)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateEMI,
              child: Text("Calculate EMI"),
            ),
            SizedBox(height: 20),
            Text(
              _emiResult,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (_paymentSchedule.isNotEmpty) ...[
              Text(
                "Payment Schedule",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Month')),
                    DataColumn(label: Text('EMI')),
                    DataColumn(label: Text('Principal Payment')),
                    DataColumn(label: Text('Interest Payment')),
                    DataColumn(label: Text('Remaining Balance')),
                  ],
                  rows: _paymentSchedule.map((payment) {
                    return DataRow(cells: [
                      DataCell(Text(payment["Month"]!)),
                      DataCell(Text(payment["EMI"]!)),
                      DataCell(Text(payment["Principal Payment"]!)),
                      DataCell(Text(payment["Interest Payment"]!)),
                      DataCell(Text(payment["Remaining Balance"]!)),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
