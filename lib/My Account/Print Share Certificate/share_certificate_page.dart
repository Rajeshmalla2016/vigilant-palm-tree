import 'dart:io';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:screenshot/screenshot.dart';


class ShareCertificatePage extends StatefulWidget {
  final String userId;
  const ShareCertificatePage({super.key, required this.userId});

  @override
  State<ShareCertificatePage> createState() => _ShareCertificatePageState();
}

class _ShareCertificatePageState extends State<ShareCertificatePage> {
  final ScreenshotController screenshotController = ScreenshotController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  WebViewController? _webController;
  String? localPdfPath;
  bool isPdf = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _detectContentTypeAndLoad();
  }

  Future<void> _detectContentTypeAndLoad() async {
    final url = 'https://msebeccs.com/app-share-certificate-print.php?id=${widget.userId}&type=pdf';

    try {
      final headResponse = await http.head(Uri.parse(url));

      final contentType = headResponse.headers['content-type'];
      print('Content-Type: $contentType');

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
    final fileName = 'share_certificate_${widget.userId}.pdf';
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

    setState(() {
      localPdfPath = filePath;
    });
  }
  Future<void> _loadWebView(String url) async {
    final controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            // Inject CSS/JS to scale content
            await controller.runJavaScript('''
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.getElementsByTagName('head')[0].appendChild(meta);
            
            document.body.style.zoom = 0.5;  // Adjust zoom level here
          ''');
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    setState(() => _webController = controller);
  }
  void _printContent() async {
    print('isPdf: $isPdf');
    try {
      if (isPdf && localPdfPath != null) {
        final file = File(localPdfPath!);
        await Printing.layoutPdf(
          onLayout: (_) => file.readAsBytesSync(),
        );
      } else {
        print('Capturing WebView screenshot...');

        // Capture as image
        final Uint8List? imageBytes = await screenshotController.capture();
        if (imageBytes == null) {
          throw Exception('Failed to capture WebView screenshot');
        }

        // Convert image to PDF
        final pdf = pw.Document();
        final image = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(image));
            },
          ),
        );

        // Print the PDF
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
        );
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
        title: const Text('Print Share Certificate',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (isReady)
            IconButton(
              icon: const Icon(Icons.print,color: Colors.white,),
              onPressed: _printContent,
            )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isPdf
          ? PDFView(
        filePath: localPdfPath!,
        enableSwipe: true,
        autoSpacing: true,
        swipeHorizontal: false,
        onError: (e) => print('PDF error: $e'),
        onPageError: (page, e) => print('Page $page error: $e'),
      )
      // : WebViewWidget(controller: _webController!),
          : Screenshot(
        controller: screenshotController,
        child: WebViewWidget(controller: _webController!),
      ),

    );
  }
}








