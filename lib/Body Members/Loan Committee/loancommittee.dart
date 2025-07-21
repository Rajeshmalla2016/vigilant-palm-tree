import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

// Person class model to represent each individual's data
class Person {
  String name;
  String designation;
  String imageUrl;

  Person({
    required this.name,
    required this.designation,
    required this.imageUrl,
  });

  // Factory constructor to create a Person object from a JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      designation: json['designation'],
      imageUrl: json['imageUrl'],
    );
  }

  // Method to convert a Person object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'imageUrl': imageUrl,
    };
  }
}

// Welcome class model to contain the list of Person objects
class Welcome {
  List<Person> data;

  Welcome({
    required this.data,
  });

  // Factory constructor to create a Welcome object from a JSON map
  factory Welcome.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Person> personList = list.map((i) => Person.fromJson(i)).toList();
    return Welcome(data: personList);
  }

  // Method to convert a Welcome object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((person) => person.toJson()).toList(),
    };
  }
}

// Simulated API Service to fetch JSON data
class ApiService {
  // Simulated JSON data
  String jsonString = '''{
    "data": [
      {"name":"ER. P. P. KOLTE", "designation":"CHAIRMAN", "imageUrl":"https://msebeccs.com/images/P.P.KOLTE.jpg"},
      {"name":"ER. J. G. THAKRE", "designation":"SECRETARY", "imageUrl":"https://msebeccs.com/images/J.G.THAKRE.jpg"},
      {"name":"ER. J. V. DETHE", "designation":"TREASURER", "imageUrl":"https://msebeccs.com/images/J.V.DETHE.jpg"}
    ]
  }''';

  // Simulated API call to fetch the data
  Future<Welcome> fetchData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    Map<String, dynamic> jsonMap = jsonDecode(jsonString); // Parse the JSON string
    return Welcome.fromJson(jsonMap); // Return the Welcome object with data
  }
}

// Main Flutter app UI
/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card View Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}*/

class LoanCommittee extends StatefulWidget {
  @override
  _LoanCommittee createState() => _LoanCommittee();
}

class _LoanCommittee extends State<LoanCommittee> {
  late Future<Welcome> futureData;

  @override
  void initState() {
    super.initState();
    futureData = ApiService().fetchData(); // Fetch data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loan Committee",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Welcome>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show a loading spinner
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Show an error message
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data available")); // Show message if no data
          } else {
            // Successfully fetched data
            Welcome welcome = snapshot.data!;
            return ListView.builder(
              itemCount: welcome.data.length,
              itemBuilder: (context, index) {
                Person person = welcome.data[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InstaImageViewer(
                          child: Image.network(
                            person.imageUrl, // Display image using the URL
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 200, // Fixed height for image
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          person.name,
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold,
                            color: Colors.deepPurple
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          person.designation,
                          style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      ],
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
