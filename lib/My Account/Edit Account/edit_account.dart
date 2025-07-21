import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EditAccountPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {

  bool _showDivAddressField = false;
  final mobileController = TextEditingController(text: '9689759982');
  final addressController = TextEditingController(text: 'NORTH BAZAR ROAD');
  final pincodeController = TextEditingController(text: '440010');
  final requestController = TextEditingController();

  // Dropdown selected values
  String? selectedArea = 'GOKULPETH';
  String? selectedRoad;
  String? selectedCity = 'NAGPUR';
  String? selectedDistrict = 'NAGPUR';

  // Dropdown options
  final List<String> areaOptions = ['GOKULPETH', 'DHARAMPETH', 'SITABULDI'];
  final List<String> roadOptions = ['Main Road', 'Sub Road', 'Ring Road'];
  final List<String> cityOptions = ['NAGPUR', 'PUNE', 'MUMBAI'];
  final List<String> districtOptions = ['NAGPUR', 'WARDHA', 'CHANDRAPUR'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStaticRow('Employee No:', '3626'),
            _buildStaticRow('Email address:', 'pankajkolte80@gmail.com'),
            _buildTextField('Mobile*', mobileController),
            _buildTextField('Local Address', addressController),

            _buildDropdown('Area', areaOptions, selectedArea, (val) {
              setState(() => selectedArea = val);
            }),
            _buildDropdown('Road', roadOptions, selectedRoad, (val) {
              setState(() => selectedRoad = val);
            }),
            _buildDropdown('City', cityOptions, selectedCity, (val) {
              setState(() => selectedCity = val);
            }),
            _buildDropdown('District', districtOptions, selectedDistrict, (val) {
              setState(() => selectedDistrict = val);
            }),

            _buildTextField('Pincode', pincodeController, keyboardType: TextInputType.number),




          SizedBox(height: 12),

        Row(
          children: [
            Checkbox(
              value: _showDivAddressField,
              onChanged: (value) {
                setState(() {
                  _showDivAddressField = value ?? false;
                });
              },
            ),
            const Text(
              'Request for change div address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        if (_showDivAddressField) ...[
    SizedBox(height: 8),
    TextField(
    controller: requestController,
    decoration: InputDecoration(
    labelText: 'Salary Drawing Office / Div:',
    border: OutlineInputBorder(),
    ),
    ),
    ],


    SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            hint: Text('Select $label'),
            items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    // You can add API submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form submitted!')),
    );
  }
}
