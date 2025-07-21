import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DemandApp());
}

class DemandApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demand Received',
      home: DemandScreen(),
    );
  }
}

class DemandScreen extends StatefulWidget {
  @override
  _DemandScreenState createState() => _DemandScreenState();
}

class _DemandScreenState extends State<DemandScreen> {
  late Future<List<DemandData>> futureDemand;

  @override
  void initState() {
    super.initState();
    futureDemand = fetchDemand();
  }

  Future<List<DemandData>> fetchDemand() async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'token');
    final userId = await secureStorage.read(key: 'userId');

    final response = await http.post(
      Uri.parse('https://msebeccs.com/API/demandReceived.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'token': token,
        'userId': userId,
      }),
    );

    // Debugging output
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (jsonBody['success'] == 'true') {
        List dataList = jsonBody['data'];
        return dataList.skip(1).map((e) => DemandData.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load data: ${jsonBody['message']}");
      }
    } else {
      throw Exception('Failed to load data');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demand Received',style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.deepPurple,),
      body: FutureBuilder<List<DemandData>>(
        future: futureDemand,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          final demands = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.indigo.shade100),
              columns: [
                DataColumn(label: Text('Month',style: TextStyle(fontWeight: FontWeight.bold),)),
                DataColumn(label: Text('DRD',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('RRD',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Share',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('TF',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('S.L Pri',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('S.L Int',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('S.L Pen',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('E.L Pri',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('E.L Int',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('E.L Pen',style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Total',style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: demands.map((d) {
                return DataRow(cells: [
                  DataCell(Text(d.month)),
                  DataCell(Text(d.drd)),
                  DataCell(Text(d.rrd)),
                  DataCell(Text(d.sc)),
                  DataCell(Text(d.tf)),
                  DataCell(Text(d.slp)),
                  DataCell(Text(d.sli)),
                  DataCell(Text(d.slpe)),
                  DataCell(Text(d.elp)),
                  DataCell(Text(d.eli)),
                  DataCell(Text(d.elpe)),
                  DataCell(Text(d.tot)),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}


class DemandData {
  final String month;
  final String drd, rrd, sc, tf;
  final String slp, sli, slpe;
  final String elp, eli, elpe;
  final String tot;

  DemandData({
    required this.month,
    required this.drd,
    required this.rrd,
    required this.sc,
    required this.tf,
    required this.slp,
    required this.sli,
    required this.slpe,
    required this.elp,
    required this.eli,
    required this.elpe,
    required this.tot,
  });

  factory DemandData.fromJson(Map<String, dynamic> json) {
    return DemandData(
      month: json['month'],
      drd: json['drd'],
      rrd: json['rrd'],
      sc: json['sc'],
      tf: json['tf'],
      slp: json['slp'],
      sli: json['sli'],
      slpe: json['slpe'],
      elp: json['elp'],
      eli: json['eli'],
      elpe: json['elpe'],
      tot: json['tot'],
    );
  }
}

