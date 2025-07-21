// otp_verification_page.dart//

/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:msebeccs/My%20Account/myAccout.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class OtpVerificationPage extends StatefulWidget {
  final String userId;
  final String mobile;

  OtpVerificationPage({required this.userId, required this.mobile});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> with CodeAutoFill {
  final TextEditingController otpController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool isVerifyingOtp = false;
  bool isResendEnabled = false;
  int resendCountdown = 120;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    listenForCode();
    startResendTimer();
  }

  void startResendTimer() {
    _resendTimer?.cancel();
    resendCountdown = 120;
    setState(() => isResendEnabled = false);
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (resendCountdown > 0) {
          resendCountdown--;
        } else {
          isResendEnabled = true;
          _resendTimer?.cancel();
        }
      });
    });
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      otpController.text = code!;
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    _resendTimer?.cancel();
    cancel(); // cancel SMS autofill listener
    super.dispose();
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    final token = await _storage.read(key: 'auth_token');

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    setState(() => isVerifyingOtp = true);

    try {
      final response = await http.post(
        Uri.parse('https://msebeccs.com/API/otpVerify.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': widget.userId,
          'mobile': widget.mobile,
          'otp': otp,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
        final userData = responseData['data'];
        await _storage.write(key: 'userName', value: userData['name']);
        await _storage.write(key: 'userId', value: userData['id']);
        await _storage.write(key: 'token', value: token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Verified!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyAccount(userId: userData['id'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    } finally {
      setState(() => isVerifyingOtp = false);
    }
  }

  Future<void> resendOtp() async {
    final response = await http.post(
      Uri.parse('https://msebeccs.com/API/otpSend.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': '8dbd9a450b5aaeba7225a58b86b35420',
        'userId': widget.userId,
        'mobile': widget.mobile,
      }),
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP resent successfully")));
      startResendTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to resend OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            PinFieldAutoFill(
              controller: otpController,
              codeLength: 6,
              decoration: UnderlineDecoration(
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                colorBuilder: FixedColorBuilder(Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVerifyingOtp ? null : verifyOtp,
              child: isVerifyingOtp
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Verify OTP'),
            ),
            SizedBox(height: 10),
            isResendEnabled
                ? TextButton(
              onPressed: resendOtp,
              child: Text("Resend OTP"),
            )
                : Text("Resend OTP in $resendCountdown sec"),
          ],
        ),
      ),
    );
  }
}

 */
//working otp verification manually//

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:msebeccs/My%20Account/myAccout.dart';

class OtpVerificationPage extends StatefulWidget {
  final String userId;
  final String mobile;

  OtpVerificationPage({required this.userId, required this.mobile});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool isVerifyingOtp = false;
  bool isResendEnabled = false;
  int resendCountdown = 120;
  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    resendCountdown = 120;
    isResendEnabled = false;
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCountdown > 0) {
        setState(() => resendCountdown--);
      } else {
        setState(() => isResendEnabled = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _resendTimer.cancel();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    final token = '8dbd9a450b5aaeba7225a58b86b35420'; // hardcoded token

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    setState(() => isVerifyingOtp = true);

    try {
      final response = await http.post(
        Uri.parse('https://msebeccs.com/API/otpVerify.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token, // ✅ token in body
          'userId': widget.userId, // ✅ match key name as per your backend
          'otp': otp,
        }),
      );

      final responseData = jsonDecode(response.body);
      print("OTP Verify Response: $responseData");

      if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
        final userData = responseData['data'];

        await _storage.write(key: 'userName', value: userData['name']);
        await _storage.write(key: 'userId', value: userData['id']);
        await _storage.write(key: 'token', value: token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'OTP Verified!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyAccount(userId: userData['id'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    } finally {
      setState(() => isVerifyingOtp = false);
    }
  }

  Future<void> resendOtp() async {
    final response = await http.post(
      Uri.parse('https://msebeccs.com/API/otpSend.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': '8dbd9a450b5aaeba7225a58b86b35420',
        'userId': widget.userId,
        'mobile': widget.mobile,
      }),
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP resent successfully")));
      startResendTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to resend OTP")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVerifyingOtp ? null : verifyOtp,
              child: isVerifyingOtp
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Verify OTP'),
            ),
            SizedBox(height: 10),
            isResendEnabled
                ? TextButton(
              onPressed: resendOtp,
              child: Text("Resend OTP"),
            )
                : Text("Resend OTP in $resendCountdown sec"),
          ],
        ),
      ),
    );
  }
}

/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';
import 'package:msebeccs/My%20Account/myAccout.dart';

class OtpVerificationPage extends StatefulWidget {
  final String userId;
  final String mobile;

  OtpVerificationPage({required this.userId, required this.mobile});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> with CodeAutoFill {
  final TextEditingController otpController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool isVerifyingOtp = false;
  bool isResendEnabled = false;
  int resendCountdown = 120;
  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    listenForCode(); // Start SMS autofill listening
    startResendTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    _resendTimer.cancel();
    cancel(); // Stop SMS autofill listening
    super.dispose();
  }

  @override
  void codeUpdated() {
    // Optional: Automatically verify OTP
    if (code != null && code!.length == 6) {
      verifyOtp(); // Don't update controller text here
    }
  }

  void startResendTimer() {
    resendCountdown = 120;
    isResendEnabled = false;
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCountdown > 0) {
        setState(() => resendCountdown--);
      } else {
        setState(() => isResendEnabled = true);
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    final otp = code?.trim() ?? otpController.text.trim();
    final token = '8dbd9a450b5aaeba7225a58b86b35420';

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    setState(() => isVerifyingOtp = true);

    try {
      final response = await http.post(
        Uri.parse('https://msebeccs.com/API/otpVerify.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'userId': widget.userId,
          'otp': otp,
        }),
      );

      final responseData = jsonDecode(response.body);
      print("OTP Verify Response: $responseData");

      if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
        final userData = responseData['data'];

        await _storage.write(key: 'userName', value: userData['name']);
        await _storage.write(key: 'userId', value: userData['id']);
        await _storage.write(key: 'token', value: token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'OTP Verified!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyAccount(userId: userData['id'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    } finally {
      setState(() => isVerifyingOtp = false);
    }
  }

  Future<void> resendOtp() async {
    final response = await http.post(
      Uri.parse('https://msebeccs.com/API/otpSend.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': '8dbd9a450b5aaeba7225a58b86b35420',
        'userId': widget.userId,
        'mobile': widget.mobile,
      }),
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP resent successfully")));
      startResendTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to resend OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('OTP sent to ${widget.mobile}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),

            PinFieldAutoFill(
              //controller: otpController,
              codeLength: 6,
              onCodeChanged: (code) {
                if (code != null && code.length == 6) {
                  verifyOtp(code);
                }
              },
              onCodeSubmitted: (code) {
                if (code.length == 6) {
                  verifyOtp(code);
                }
              },

              decoration: UnderlineDecoration(
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                colorBuilder: FixedColorBuilder(Colors.black),
              ),
            ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isVerifyingOtp ? null : verifyOtp,
              child: isVerifyingOtp
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Verify OTP'),
            ),
            SizedBox(height: 10),
            isResendEnabled
                ? TextButton(
              onPressed: resendOtp,
              child: Text("Resend OTP"),
            )
                : Text("Resend OTP in $resendCountdown sec"),
          ],
        ),
      ),
    );
  }
}

 */


