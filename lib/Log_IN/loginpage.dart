import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../My Account/myAccout.dart';
import 'final_varification_otp/UserIdValidationPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _printStoredLoginResponse();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),

    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  ///with api////

  Future<void> _login() async {
    final userId = _userIdController.text.trim();
    final password = _passwordController.text.trim();
    const token = '8dbd9a450b5aaeba7225a58b86b35420';

    if (userId.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter both fields');
      return;
    }

    // Start loading spinner
    setState(() {
      _isLoading = true;
    });

    // Step 1: Check network connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'No network connection.',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    // Step 2: Check actual internet access
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: 'No internet access. Please check your connection.',
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }
    } on SocketException catch (_) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: '📡 No internet access.\nPlease check your connection.',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    // Continue with login request
    try {
      final response = await http.post(
        Uri.parse('https://msebeccs.com/API/loginCheck.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'userId': userId,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'].toString().toLowerCase().contains('true')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', data['data']['id']);
        await prefs.setString('userName', data['data']['name']);
        await prefs.setString('token', token);

        await secureStorage.write(key: 'isLoggedIn', value: 'true');
        await secureStorage.write(key: 'userId', value: data['data']['id']);
        await secureStorage.write(key: 'userName', value: data['data']['name']);
        await secureStorage.write(key: 'token', value: token);
        await secureStorage.write(key: 'fullLoginResponse', value: jsonEncode(data));

        String? jsonString = await secureStorage.read(key: 'fullLoginResponse');
        if (jsonString != null) {
          final parsed = jsonDecode(jsonString);
          debugPrint('✅ Stored login name: ${parsed['data']['name']}');
          debugPrint('✅ Stored email: ${parsed['data']['email']}');
          debugPrint('✅ Stored mobile: ${parsed['data']['mobile']}');
        }
        await secureStorage.write(key: 'name', value: data['data']['name']);
        await secureStorage.write(key: 'email', value: data['data']['email']);
        await secureStorage.write(key: 'mobile', value: data['data']['mobile']);

        Fluttertoast.showToast(msg: '🎉 Login successful!');
        
        await prefs.setString('loginMessage', '🎉 Login successful!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MyAccount(userId: data['data']['id']),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: data['message'] ?? 'Login failed.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

/*
  //without internet API///
  Future<void> _login() async {
    final userId = _userIdController.text.trim();
    final password = _passwordController.text.trim();

    const staticUserId = 'admin123';
    const staticPassword = 'password123';

    if (userId.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter both fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulate loading

    if (userId == staticUserId && password == staticPassword) {
      const dummyUserData = {
        'id': '001',
        'name': 'Demo User',
        'email': 'demo@example.com',
        'mobile': '1234567890',
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', dummyUserData['id']!);
      await prefs.setString('userName', dummyUserData['name']!);

      await secureStorage.write(key: 'isLoggedIn', value: 'true');
      await secureStorage.write(key: 'userId', value: dummyUserData['id']);
      await secureStorage.write(key: 'userName', value: dummyUserData['name']);
      await secureStorage.write(key: 'token', value: 'static-token');
      await secureStorage.write(key: 'email', value: dummyUserData['email']);
      await secureStorage.write(key: 'mobile', value: dummyUserData['mobile']);
      await secureStorage.write(
          key: 'fullLoginResponse', value: jsonEncode({'data': dummyUserData}));

      Fluttertoast.showToast(msg: '🎉 Login successful!');
      await prefs.setString('loginMessage', '🎉 Login successful!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyAccount(userId: dummyUserData['id']!),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: '❌ Invalid credentials');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  */


  void _printStoredLoginResponse() async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? jsonString = await secureStorage.read(key: 'fullLoginResponse');

    if (jsonString != null) {
      Map<String, dynamic> response = jsonDecode(jsonString);
      debugPrint('🔐 Full login response from secure storage:');
      debugPrint(jsonEncode(response)); // You can also use prettyJson if needed
    } else {
      debugPrint('❌ No stored login response found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _animationController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/icons/login.png'),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _userIdController,
                              label: 'User ID',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                                labelText: 'Password',
                                labelStyle: const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Colors.white54),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 6,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>UserIdValidationPage()));
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white70,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back button (floating at top-left)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: child,
    );
  }
}





