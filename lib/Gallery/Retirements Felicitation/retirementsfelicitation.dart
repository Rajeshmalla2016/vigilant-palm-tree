import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../Deposit/shorttermfdonjal.dart';
import '../Annual General Meeting/annualgeneralmeeting.dart';  // Import connectivity_plus

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
  static const String apiUrl = 'https://msebeccs.com/API/gallery-retirements-felicitation.php'; // Replace with your actual API URL

  Future<Welcome> fetchData(BuildContext context) async {
    // Check network connectivity
    bool isConnected = await _checkNetworkConnectivity();

    if (!isConnected) {
      // If no network connection, show a message
      _showNoNetworkConnectionMessage(context);
      throw Exception("No network connection");
    }

    // Proceed with the API call if there is a network connection
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

  // Show message when there is no network connection
  void _showNoNetworkConnectionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No network connection'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}


// Main UI class
class RetirementsFelicitation extends StatefulWidget {
  @override
  _RetirementsFelicitation createState() => _RetirementsFelicitation();
}

class _RetirementsFelicitation extends State<RetirementsFelicitation> {
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
          "Retirement Facilitation",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
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

                // Inside itemBuilder
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 7,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImage(imageUrl: datum.imageUrl),
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
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

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
              maxScale: 4.0,
              child: Image.network(imageUrl),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
