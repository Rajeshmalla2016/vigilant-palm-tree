import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmergencyLoanForm(),
    );
  }
}

class EmergencyLoanForm extends StatefulWidget {
  @override
  _EmergencyLoanFormState createState() => _EmergencyLoanFormState();
}

class _EmergencyLoanFormState extends State<EmergencyLoanForm> {
  String pdfUrl = 'https://msebeccs.com/pdf/emergency-loan.pdf';
  String? filePath;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  // Download PDF and get the file path
  Future<void> _downloadPDF() async {
    var file = await DefaultCacheManager().getSingleFile(pdfUrl);
    setState(() {
      filePath = file.path;
    });
  }

  // Print PDF
  Future<void> _printPDF() async {
    if (filePath != null) {
      final file = File(filePath!);
      await Printing.layoutPdf(onLayout: (format) => file.readAsBytesSync());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Loan Form',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.print,color: Colors.white,),
            onPressed: _printPDF,
          ),
        ],
      ),
      body: filePath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
      ),
    );
  }
}
