

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: AnnualGeneralMeeting(),
));

class AnnualGeneralMeeting extends StatefulWidget {
  @override
  _AnnualGeneralMeetingState createState() => _AnnualGeneralMeetingState();
}

class _AnnualGeneralMeetingState extends State<AnnualGeneralMeeting> {
  bool isLoading = false;
  String _pdfPath = '';
  final String pdfUrl =
      'https://msebeccs.com/pdf/AGM-2023-24.pdf'; // Replace with actual PDF URL

  Future<void> downloadPDF() async {
    setState(() {
      isLoading = true;
    });
    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/agm-booklet.pdf';

      Dio dio = Dio();
      await dio.download(pdfUrl, filePath);

      setState(() {
        _pdfPath = filePath;
      });

      if (_pdfPath.isNotEmpty) {
        await printPDF(_pdfPath);
        showSuccessDialog();
      }
    } catch (e) {
      print("Error downloading PDF: $e");
      showErrorDialog();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> printPDF(String filePath) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final document = await File(filePath).readAsBytes();
        return document;
      },
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: Text('Booklet downloaded and ready for printing!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Icon(Icons.error, color: Colors.red, size: 50),
        content: Text('Failed to download the booklet. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 21,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Annual General Meeting',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.event, size: 100, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  '38th Annual General Meeting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '2023 - 2024\n\nVenue: Rajwada Palace\nDate: 21st July 2024\nTime: 12:00 PM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 40),
                isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton.icon(
                  onPressed: downloadPDF,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 21,
                  ),
                  icon: Icon(Icons.download),
                  label: Text(
                    "Download & Print Booklet",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


