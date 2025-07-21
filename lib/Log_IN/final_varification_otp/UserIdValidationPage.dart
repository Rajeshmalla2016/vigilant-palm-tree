// user_id_validation_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'OtpVerificationPage.dart';

class UserIdValidationPage extends StatefulWidget {
  @override
  _UserIdValidationPageState createState() => _UserIdValidationPageState();
}

class _UserIdValidationPageState extends State<UserIdValidationPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  bool isSendingOtp = false;

  Future<void> sendOtp() async {
    final userId = userIdController.text.trim();
    final mobile = mobileController.text.trim();

    if (userId.isEmpty || mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (mobile.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    final url = Uri.parse('https://msebeccs.com/API/otpSend.php');
    setState(() => isSendingOtp = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': '8dbd9a450b5aaeba7225a58b86b35420',
          'userId': userId,
          'mobile': mobile,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          responseData['success'].toString().toLowerCase() == 'true') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'OTP sent')),
        );

        // Navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
              userId: userId,
              mobile: mobile,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Failed to send OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isSendingOtp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User ID Validation")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSendingOtp ? null : sendOtp,
              child: isSendingOtp
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Validate'),
            ),
          ],
        ),
      ),
    );
  }
}
