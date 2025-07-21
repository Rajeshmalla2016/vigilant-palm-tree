import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:connectivity_plus/connectivity_plus.dart';  // Import connectivity_plus

// Model classes
class Welcome {
  List<Datum> data;

  Welcome({
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Datum> dataList = list.map((i) => Datum.fromJson(i)).toList();
    return Welcome(data: dataList);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((datum) => datum.toJson()).toList(),
    };
  }
}

class Datum {
  String imageUrl;

  Datum({
    required this.imageUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
    };
  }
}

// API Service class to fetch data
class ApiService {
  static const String apiUrl = 'https://msebeccs.com/API/gallery-students-award.php'; // Replace with your actual API URL

  Future<Welcome> fetchData(BuildContext context) async {
    // Check network connectivity before making the API request
    bool isConnected = await _checkNetworkConnectivity();

    if (!isConnected) {
      // Show a message if there's no network connection
      _showNoNetworkConnectionMessage(context);
      throw Exception("No network connection");
    }

    // If there is a network connection, proceed with the API request
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return Welcome.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Check network connectivity using connectivity_plus
  Future<bool> _checkNetworkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Show a message if there's no network connection
  void _showNoNetworkConnectionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No network connection'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

// Main UI class
class StudentsAward extends StatefulWidget {
  @override
  _StudentsAward createState() => _StudentsAward();
}

class _StudentsAward extends State<StudentsAward> {
  late Future<Welcome> futureData;

  @override
  void initState() {
    super.initState();
    futureData = ApiService().fetchData(context); // Fetch data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Students Award's",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Welcome>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          } else {
            // Successfully fetched the data
            Welcome welcome = snapshot.data!;
            return ListView.builder(
              itemCount: welcome.data.length,
              itemBuilder: (context, index) {
                Datum datum = welcome.data[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImageViewer(imageUrl: datum.imageUrl),
                          ),
                        );
                      },
                      child: Image.network(
                        datum.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ),
                );
                },
            );
          }
        },
      ),
    );
  }
}
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 5.0,
              child: Image.network(imageUrl),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

