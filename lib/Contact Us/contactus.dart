
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class ContactUs extends StatefulWidget
{
  const ContactUs({super.key});

  @override
  _ContactUsState createState()=> _ContactUsState();

}
class _ContactUsState extends State<ContactUs> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      String? jsonString = await _secureStorage.read(key: 'fullLoginResponse');

      if (jsonString != null) {
        Map<String, dynamic> userData = json.decode(jsonString);
        Map<String, dynamic> userInfo = userData['data'];

        print('Login Response JSON: $jsonString');
        print('Name: ${userData['name']}');
        print('Email: ${userData['email']}');
        print('Mobile: ${userData['mobile']}');

        setState(() {
          _nameController.text = userInfo['name'] ?? '';
          _emailController.text = userInfo['email'] ?? '';
          _mobileNoController.text = userInfo['mobile'] ?? '';
        });
      }else
        {
          print('No login_response foung in secure storage');
          setState(() {
            _nameController.clear();
            _emailController.clear();
            _mobileNoController.clear();
          });
        }
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          labelText: label,
          prefixIcon: Card(child: Icon(icon)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildRtgsInfoCard() {
    return Card(
      elevation: 70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('RTGS Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            Divider(thickness: 1, height: 20),
            _infoTile(Icons.business, 'M.S.E.B. ENGINEER CO-OP. CREDIT SOCIETY LTD. NAGPUR'),
            _infoTile(Icons.confirmation_number, 'Vendor No.',
                subtitle: 'MSEDCL: 4000000002 | MSETCL: 76 | MSPGCL: NG08'),
            _infoTile(Icons.location_on, 'Address',
                subtitle:
                '208, Shreeman Complex, Wardha Road\nDhantoli, Nagpur, 440012\nDistrict: Nagpur'),
            _infoTile(Icons.phone, 'Contact', subtitle: '0712-2438814, 2448814'),
            _infoTile(Icons.email, 'Mail', subtitle: 'msebeccsngp@yahoo.com'),
            _infoTile(Icons.account_box, 'PAN No.', subtitle: 'AAAAM0418K'),
            Divider(thickness: 1, height: 20),
            _infoTile(Icons.account_balance, 'Bank Details', subtitle: '''
Account No.: MSEBNG
Bank Name: ICICI Bank
Branch: New Delhi
IFSC Code: ICIC0000106
MICR Code: 440229003
'''),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle) : null,
    );
  }



  final firstClear = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _sendEmail() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final mobileNo = _mobileNoController.text;
    final subject = _subjectController.text;
    final message = _messageController.text;

    final smtpServer = SmtpServer('bh-ht-1.webhostbox.net',
      username: 'noreply@msebeccs.com',
      password: 'noreply@2019mission',
      port: 465,
      ssl: true,
    );

    final emailMessage = Message()
      ..from = Address('noreply@msebeccs.com', '$name <$email>')
      ..recipients.add('msebeccsngp@yahoo.com ')
      //..ccRecipients.add('value')
     // ..bccRecipients.add('value')
      ..subject = subject
      ..text = 'Name : $name\n'
               'Email :$email\n'
               'Mobile No : $mobileNo\n'
               'Message : $message';

    try {
      final sendReport = await send(emailMessage, smtpServer);
      //print('Message Sent: ' + sendReport.toString());
      print('Message Sent: $sendReport');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message Sent Successfully !')),);
    }
    on MailerException catch (e) {
      print('Message Not Sent.');
      for (var p in e.problems) {
        print('Problem : ${p.code}:${p.msg}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),);
    }
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    }

    RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null; // Return null if the email is valid
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Contact Us',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white
            ),
          ),
          backgroundColor: Colors.deepPurple,
        ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Get in Touch',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  validator: (value) =>
                  value!.length < 4 ? 'Name must be at least 4 characters' : null,
                ),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),

                // Mobile No Field
                _buildTextField(
                  controller: _mobileNoController,
                  label: 'Mobile No',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Enter valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),

                // Subject Field
                _buildTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  icon: Icons.subject,
                ),

                // Message Field
                _buildTextField(
                  controller: _messageController,
                  label: 'Message',
                  icon: Icons.message,
                  maxLines: 5,
                ),

                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.send, color: Colors.white),
                  label: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Show loading spinner
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        try {
                          await _sendEmail(); // Your existing email sending logic

                          Navigator.of(context).pop(); // Dismiss the loading spinner

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Message Sent Successfully!')),
                          );
                          _formKey.currentState!.reset();
                          _nameController.clear();
                          _emailController.clear();
                          _mobileNoController.clear();
                          _subjectController.clear();
                          _messageController.clear();
                        } catch (e) {
                          Navigator.of(context).pop(); // Dismiss the loading spinner

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to send message')),
                          );
                        }
                      }
                    }
                    ),
                SizedBox(height: 30),

                // RTGS Info
                _buildRtgsInfoCard(),
              ],
            ),
          ),
        ),
      ),

    );
  }
  void dispose()
  {
    _nameController.dispose();
    _emailController.dispose();
    _mobileNoController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}