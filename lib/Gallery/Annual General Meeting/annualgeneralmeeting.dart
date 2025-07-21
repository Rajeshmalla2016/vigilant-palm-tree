
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'agmmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Fetcher',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Annualgeneralmeeting(),
    );
  }
}

class Annualgeneralmeeting extends StatefulWidget {
  @override
  _Annualgeneralmeeting createState() => _Annualgeneralmeeting();
}

class _Annualgeneralmeeting extends State<Annualgeneralmeeting> {
  List<Datum> data = [];

  Future<void> fetchData() async {
    bool isConnected = await _checkNetworkConnectivity();

    if (!isConnected) {
      _showNoNetworkConnectionMessage();
      return;
    }

    try {
      final response = await http.get(Uri.parse('https://msebeccs.com/API/gallery.php'));
      if (response.statusCode == 200) {
        Welcome welcome = welcomeFromJson(response.body);
        setState(() {
          data = welcome.data;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> _checkNetworkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return false;

    try {
      final result = await http.get(Uri.parse('https://www.google.com')).timeout(Duration(seconds: 3));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void _showNoNetworkConnectionMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '📡 No internet access.\nPlease check your connection.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Annual General Meeting ',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Datum datum = data[index];
          return Card(
            elevation: 7,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(imageUrl: datum.imageUrl),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      datum.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: PinchZoom(
          maxScale: 5.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

