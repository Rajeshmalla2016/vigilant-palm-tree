
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pdf/widgets.dart' as pw;


class PrintLoanCertificate extends StatefulWidget {
  final String userId;
  const PrintLoanCertificate({super.key, required this.userId});
  @override
  State<PrintLoanCertificate> createState() => _PrintLoanCertificateState();
}
class _PrintLoanCertificateState extends State<PrintLoanCertificate> {
  Map<String, String> loanUrls = {};

  String? selectedUrl;
  final ScreenshotController screenshotController = ScreenshotController();
  String selectedTitle = 'FY 2025-26';
  WebViewController? _webController;
  String? localPdfPath;
  bool isPdf = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('✅ User ID in PrintLoanCertificate: ${widget.userId}');

    // Dynamically calculate financial years
    final now = DateTime.now();
    final currentFYStartYear = now.month >= 4 ? now.year : now.year - 1;
    final nextFYStartYear = currentFYStartYear + 1;

    final currentFYLabel =
        'Loan Deduction Certificate For Financial Year ${currentFYStartYear}-${(currentFYStartYear + 1).toString().substring(2)}';
    final nextFYLabel =
        'Loan Deduction Certificate For Financial Year ${nextFYStartYear}-${(nextFYStartYear + 1).toString().substring(2)}';
/*
    loanUrls = {
      currentFYLabel:
      'https://msebeccs.com/print-certificate.php?id=${widget.userId}&sdt=01-04-$currentFYStartYear&edt=31-03-${currentFYStartYear + 1}',
      nextFYLabel:
      'https://msebeccs.com/print-certificate.php?id=${widget.userId}&sdt=01-04-$nextFYStartYear&edt=31-03-${nextFYStartYear + 1}',
    };

 */
    loanUrls = {
      currentFYLabel:
      'https://msebeccs.com/app-certificate-print.php?id=${widget.userId}&sdt=01-04-$currentFYStartYear&edt=31-03-${currentFYStartYear + 1}',
      nextFYLabel:
      'https://msebeccs.com/app-certificate-print.php?id=${widget.userId}&sdt=01-04-$nextFYStartYear&edt=31-03-${nextFYStartYear + 1}',
     'Membership Certificate':
      'https://msebeccs.com/app-certificate-print.php?id=${widget.userId}',
    };


    selectedUrl = loanUrls.entries.first.value;
    selectedTitle = loanUrls.entries.first.key;

    _detectContentTypeAndLoad();
  }

  Future<void> _detectContentTypeAndLoad() async {
    final url = selectedUrl!;
    setState(() => isLoading = true);

    try {
      final headResponse = await http.head(Uri.parse(url));
      final contentType = headResponse.headers['content-type'];

      if (contentType != null && contentType.contains('application/pdf')) {
        isPdf = true;
        await _downloadPdf(url);
      } else {
        await _loadWebView(url);
      }
    } catch (e) {
      print('Error detecting content type: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load content: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> _downloadPdf(String url) async {
    final fileName = 'loan_certificate_${widget.userId}.pdf';
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (!await file.exists()) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
      } else {
        throw Exception('Failed to download PDF');
      }
    }

    setState(() => isLoading = false);
  }


  Future<void> _loadWebView(String url) async {
    final controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            // Inject viewport meta and scaling styles
            await controller.runJavaScript('''
  var meta = document.createElement('meta');
  meta.name = 'viewport';
  meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
  document.getElementsByTagName('head')[0].appendChild(meta);

  document.body.style.zoom = 0.4;  // exact zoom from ShareCertificatePage
''');

            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    setState(() => _webController = controller);
  }

  void _printContent() async {
    try {
      if (isPdf && localPdfPath != null) {
        final file = File(localPdfPath!);
        await Printing.layoutPdf(onLayout: (_) => file.readAsBytesSync());
      } else if (!isPdf) {
        // Capture screenshot of WebView
        final image = await screenshotController.capture();
        if (image != null) {
          await Printing.layoutPdf(onLayout: (format) async {
            final doc = pw.Document();
            final decodedImage = pw.MemoryImage(image);
            doc.addPage(
              pw.Page(
                build: (context) => pw.Center(child: pw.Image(decodedImage)),
              ),
            );
            return doc.save();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to capture screenshot.')),
          );
        }
      }
    } catch (e) {
      print('Print error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print failed: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final isReady = !isLoading && ((isPdf && localPdfPath != null) || _webController != null);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Certificate',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (isReady)
            IconButton(icon: const Icon(Icons.print), onPressed: _printContent,color: Colors.white,),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedUrl,
              items: loanUrls.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(
                      entry.key,
                    style: const TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedUrl = value;
                    selectedTitle = loanUrls.entries.firstWhere((entry) => entry.value == value).key;
                    isPdf = false;
                    localPdfPath = null;
                    _webController = null;
                  });
                  _detectContentTypeAndLoad();
                }
              },
            ),
          ),
      ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isPdf
                ? PDFView(filePath: localPdfPath!)
                : Screenshot(
              controller: screenshotController,
              child: WebViewWidget(controller: _webController!),
            ),
          ),
        ],
      ),
    );
  }
}
