// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'financial_data.dart';


class ApiService {
  final String userId;
  final String token;

  ApiService({required this.userId, required this.token});

  Future<List<FinancialData>> fetchFinancialData() async {
    final response = await http.post(
      Uri.parse('https://msebeccs.com/API/demand.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'token': token}),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      if (jsonBody['success'] == "true") {
        final List<dynamic> data = jsonBody['data'];
        return data.skip(1).map((item) => FinancialData.fromJson(item)).toList();
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
