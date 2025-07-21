/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:msebeccs/My%20Account/myAccout.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
void main()
{
  runApp(MaterialApp(
    home: UserIdValidationPage(),
  ));
}
class UserIdValidationPage extends StatefulWidget {
  @override
  _UserIdValidationPageState createState() => _UserIdValidationPageState();
}
class _UserIdValidationPageState extends State<UserIdValidationPage> with CodeAutoFill {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool otpSent = false;
  bool isResendEnabled = false;
  int resendCountdown = 120;
  Timer? _resendTimer;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
  @override
  void initState() {
    super.initState();
    _storage.write(key: 'auth_token', value: '8dbd9a450b5aaeba7225a58b86b35420');
    _storage.read(key: 'auth_token').then((token) {
      print("Saved token: $token");
    });
    listenForCode(); // start listening for auto OTP
  }

  @override
  void dispose() {
    userIdController.dispose();
    mobileController.dispose();
    otpController.dispose();
    _resendTimer?.cancel();
    cancel(); // stop listening
    super.dispose();
  }
  @override
  void codeUpdated() {
    if (code != null && code != otpController.text) {
      setState(() {
        otpController.text = code!;
        // Optionally move cursor to end
        otpController.selection = TextSelection.fromPosition(
          TextPosition(offset: otpController.text.length),
        );
      });
    }
  }

  void startResendTimer() {
    _resendTimer?.cancel(); // Stop any existing timer
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
   // final token = await _storage.read(key: 'auth_token');
    final url = Uri.parse('https://msebeccs.com/API/otpSend.php');
    setState(() {
      isSendingOtp = true;
    });
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',

        },
        body: jsonEncode({
          'token': '8dbd9a450b5aaeba7225a58b86b35420',
          'userId': userId,
          'mobile': mobile,
        }),
      );
      final responseData = jsonDecode(response.body);
      print('Response: $responseData');
      if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
        setState(() {
          otpSent = true;
          isResendEnabled = false;
          resendCountdown = 120;
        });
        startResendTimer();
        print("otpSent set to true");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'OTP sent')),
        );
      } else {
        final message = responseData['message']?.toString().toLowerCase() ?? '';
        if (message.contains('invalid mobile')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid mobile number')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Failed to send OTP')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      setState(() {
        isSendingOtp = false;
      });
    }
  }
  Future<void> verifyOtp() async {
    final userId = userIdController.text.trim();
    final mobile = mobileController.text.trim();
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }
    final token = await _storage.read(key: 'auth_token');
    print('Token: $token');
    final url = Uri.parse('https://msebeccs.com/API/otpVerify.php');
    setState(() => isVerifyingOtp = true);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'mobile': mobile,
          'otp': otp,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'].toString().toLowerCase() == 'true') {
          final userData = responseData['data'];
          await _storage.write(key: 'userName', value: userData['name']);
          await _storage.write(key: 'userId', value: userData['id']);  // optional save userId from response
          await _storage.write(key: 'token', value: token);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'OTP Verified!')),
          );
          await _storage.write(key: 'userId', value: userId);
          await _storage.write(key: 'token', value: token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyAccount(userId:  userData['id'])),
          );
        } else {
          final message = responseData['message']?.toString().toLowerCase() ?? '';
          if (message.contains('invalid mobile')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid mobile number')),
            );
          } else if (message.contains('otp not sent') || message.contains('otp missing')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP not received. Please resend OTP.')),
            );
          } else if (message.contains('invalid otp')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid OTP. Please try again.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Verification failed')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User ID Validation')),
      body: SingleChildScrollView(
        child: Padding(
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
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text('Validate'),
              ),
              if (otpSent) ...[
                SizedBox(height: 30),
                PinFieldAutoFill(
                  controller: otpController,
                  codeLength: 6,
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder: FixedColorBuilder(Colors.grey),
                  ),
                  onCodeChanged: (code) {

                  },
                ),


                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isVerifyingOtp ? null : verifyOtp,
                  child: isVerifyingOtp
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text('Verify OTP'),
                ),
                SizedBox(height: 10),
                isResendEnabled
                    ? TextButton(
                  onPressed: sendOtp,
                  child: Text("Resend OTP"),
                )
                    : Text(
                  "Resend OTP in $resendCountdown sec",
                  style: TextStyle(color: Colors.grey),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

 */

import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:msebeccs/My%20Account/myAccout.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: UserValidationPage(),
  ));
}

class UserValidationPage extends StatefulWidget {
  @override
  _UserValidationPageState createState() => _UserValidationPageState();
}

class _UserValidationPageState extends State<UserValidationPage> with CodeAutoFill {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool otpSent = false;
  bool isResendEnabled = false;
  int resendCountdown = 120;
  Timer? _resendTimer;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void initState() {
    super.initState();
    _storage.write(key: 'auth_token', value: '8dbd9a450b5aaeba7225a58b86b35420');
    _storage.read(key: 'auth_token').then((token) {
      print("Saved token: $token");
    });
    listenForCode(); // start listening for auto OTP
  }

  @override
  void dispose() {
    userIdController.dispose();
    mobileController.dispose();
    otpController.dispose();
    _resendTimer?.cancel();
    cancel(); // stop listening
    super.dispose();
  }

  @override
  void codeUpdated() {
    // Only update OTP text if full 6-digit code received and different from current text
    if (code != null && code!.length == 6 && code != otpController.text) {
      setState(() {
        otpController.text = code!;
        otpController.selection = TextSelection.fromPosition(
          TextPosition(offset: otpController.text.length),
        );
      });
    }
  }

  void startResendTimer() {
    _resendTimer?.cancel(); // Stop any existing timer
    resendCountdown = 120;
    setState(() {
      isResendEnabled = false;
    });
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
    setState(() {
      isSendingOtp = true;
    });
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': '8dbd9a450b5aaeba7225a58b86b35420',
          'userId': userId,
          'mobile': mobile,
        }),
      );
      final responseData = jsonDecode(response.body);
      print('Response: $responseData');
      if (response.statusCode == 200 && responseData['success'].toString().toLowerCase() == 'true') {
        setState(() {
          otpSent = true;
        });
        startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'OTP sent')),
        );
      } else {
        final message = responseData['message']?.toString().toLowerCase() ?? '';
        if (message.contains('invalid mobile')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid mobile number')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Failed to send OTP')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      setState(() {
        isSendingOtp = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    final userId = userIdController.text.trim();
    final mobile = mobileController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    final token = await _storage.read(key: 'auth_token');
    print('Token: $token');

    final url = Uri.parse('https://msebeccs.com/API/otpVerify.php');
    setState(() => isVerifyingOtp = true);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'mobile': mobile,
          'otp': otp,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'].toString().toLowerCase() == 'true') {
          final userData = responseData['data'];
          await _storage.write(key: 'userName', value: userData['name']);
          await _storage.write(key: 'userId', value: userData['id']);
          await _storage.write(key: 'token', value: token);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'OTP Verified!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyAccount(userId: userData['id'])),
          );
        } else {
          final message = responseData['message']?.toString().toLowerCase() ?? '';
          if (message.contains('invalid mobile')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid mobile number')),
            );
          } else if (message.contains('otp not sent') || message.contains('otp missing')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP not received. Please resend OTP.')),
            );
          } else if (message.contains('invalid otp')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid OTP. Please try again.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Verification failed')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User ID Validation')),
      body: SingleChildScrollView(
        child: Padding(
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
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text('Validate'),
              ),
              if (otpSent) ...[
                SizedBox(height: 30),
                PinFieldAutoFill(
                  controller: otpController,
                  codeLength: 6,
                  //autofillHints: [AutofillHints.oneTimeCode],
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder: FixedColorBuilder(Colors.grey),
                  ),
                  onCodeChanged: (code) {
                    // Do NOT overwrite otpController.text here to avoid conflicts
                    // Just let user type or autofill via codeUpdated()
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isVerifyingOtp ? null : verifyOtp,
                  child: isVerifyingOtp
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text('Verify OTP'),
                ),
                SizedBox(height: 10),
                isResendEnabled
                    ? TextButton(
                  onPressed: sendOtp,
                  child: Text("Resend OTP"),
                )
                    : Text(
                  "Resend OTP in $resendCountdown sec",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

