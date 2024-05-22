import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retinasoft_skill_test/screens/customer/customer_list.dart';
import 'dart:convert';

import '../../network/service.dart';

class UpdateCustomer extends StatefulWidget {
  final String apiToken;
  final String branchId;
  final String customerId;
  final String customerName;
  final String phoneNumber;

  const UpdateCustomer({
    super.key,
    required this.apiToken,
    required this.branchId,
    required this.customerName,
    required this.phoneNumber,
    required this.customerId,
  });

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  late TextEditingController _customerNameController;
  late TextEditingController _phoneNumberController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(text: widget.customerName);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Customer',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _customerNameController,
              label: 'Customer Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneNumberController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_customerNameController.text.isNotEmpty || _phoneNumberController.text.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  _updateCustomerApi();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a customer name')),
                  );
                }
              },
              child: _isLoading? CircularProgressIndicator(color: Colors.white,): Text(
                'Update Customer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.blueAccent.withOpacity(0.05),
      ),
    );
  }

  Future<void> _updateCustomerApi() async {
    final url = '${ApiService.baseUrl}admin/${widget.branchId}/customer/${widget.customerId}/update';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
      body: jsonEncode({
        'name': _customerNameController.text,
        'phone': _phoneNumberController.text,
        'type': '0',
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer updated successfully')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CustomerList(apiToken: widget.apiToken, branchId: widget.branchId)));
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update customer')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}
