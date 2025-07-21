import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:msebeccs/main.dart';
import '../Log_IN/loginpage.dart';
import 'Demand Received/DemandReceivedScreen.dart';
import 'Demand/home_screen.dart';
import 'Edit Account/edit_account.dart';
import 'My Deposit/depositScreen.dart';
import 'MyLoan/loan_screen.dart';
import 'Print Loan Certificate/print_loan_certificate.dart';
import 'Print Share Certificate/share_certificate_page.dart';
import 'Surity/main.dart';
import 'kyc_update/kyc_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  final userId = await storage.read(key: 'userId') ?? '';

  runApp(MyAccount(userId: userId));
}

class MyAccount extends StatefulWidget {
  final String userId;
  const MyAccount({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final storage = FlutterSecureStorage();
    final name = await storage.read(key: 'userName');
    setState(() {
      userName = name ?? '';
    });
  }

  Future<void> handleKYCCheck() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final uid = await storage.read(key: 'userId') ?? widget.userId;

    if (token == null || uid.isEmpty) {
      Fluttertoast.showToast(msg: 'Missing auth token or userId.');
      return;
    }

    try {
      final resp = await http.post(
        Uri.parse('https://msebeccs.com/API/kycCheck.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': uid, 'token': token}),
      );

      dynamic parsed = jsonDecode(resp.body);
      if (parsed is String) {
        parsed = jsonDecode(parsed);
      }

      if (parsed is Map && parsed.containsKey('message') && parsed.containsKey('success'))  {
       // final body = parsed[0];
        final message = parsed['message'];
        final success = parsed['success'];

        if (message == 'KYC Done.' && success == 'false') {
          Fluttertoast.showToast(msg: '✅ KYC already completed.');
        } else if (message == 'KYC Not Done.' && success == 'true') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => KycUpdate(userId: widget.userId)));
        } else {
          Fluttertoast.showToast(msg: '⚠️ Unexpected response: $message');
        }
      } else {
        Fluttertoast.showToast(msg: '❌ Invalid response format.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error checking KYC status.');
    }
  }

  Widget buildGridTile(String asset, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.purpleAccent.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.4),
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50, width: 50, child: Image.asset(asset)),
            SizedBox(height: 12),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.purpleAccent.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MyHomePage(title: '')));
                    },
                  ),
                  title: Text('My Account',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  centerTitle: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('User ID: ${widget.userId}',
                      style: TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                ),



                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    children: [
                      buildGridTile('assets/icons/demandPersonal.png', 'Demand', () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreenD()))),
                      buildGridTile('assets/icons/surity.png', 'Surety', () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SuretyPage()))),
                      buildGridTile('assets/icons/myLoan.png', 'My Loan', () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoanScreen()))),
                      buildGridTile('assets/icons/myDeposit.png', 'My Deposit', () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DepositScreen()))),
                      buildGridTile('assets/icons/demandRecive.png', 'Demand\nReceived', () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DemandScreen()))),
                      buildGridTile('assets/icons/kycupdate.png', 'KYC\nUpdate', () async {
                        await handleKYCCheck();
                      }),
                      buildGridTile('assets/icons/eddit.png', 'Edit\nAccount', () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => EditAccountPage()))),

                      /*
                      buildGridTile('assets/icons/logout.png', 'Logout', () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                      }),

                      */
                      buildGridTile('assets/icons/logout.png', 'Logout', () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();

                        final storage = FlutterSecureStorage();
                        await storage.delete(key: 'fullLoginResponse'); // Clear secure storage

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      }),
                      buildGridTile('assets/icons/certificate.png', 'Print\nShare Certificate', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ShareCertificatePage(userId: widget.userId)));
                      }),
                      buildGridTile('assets/icons/loanCer.png', 'Print\nLoan Certificate', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PrintLoanCertificate(userId: widget.userId)));
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







