import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:retinasoft_skill_test/network/service.dart';
import 'package:retinasoft_skill_test/screens/customer/customer_list.dart';

class CreateCustomer extends StatefulWidget {
  final String apiToken;
  final String branchId;

  const CreateCustomer({super.key, required this.apiToken, required this.branchId});

  @override
  State<CreateCustomer> createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Customer',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Name', Icons.person),
              const SizedBox(height: 16.0),
              _buildTextField(_phoneController, 'Phone', Icons.phone),
              const SizedBox(height: 16.0),
              _buildTextField(_emailController, 'Email', Icons.email),
              const SizedBox(height: 16.0),
              _buildTextField(_typeController, 'Type', Icons.category),
              const SizedBox(height: 16.0),
              _buildTextField(_addressController, 'Address', Icons.location_on),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _createCustomer,
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blueAccent,
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading? CircularProgressIndicator(color: Colors.white,) : Text(
                  'Create Customer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _typeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createCustomer() async {
    setState(() {
      _isLoading = true;
    });
    final url = '${ApiService.baseUrl}admin/${widget.branchId}/customer/create';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'type': _typeController.text,
        'address': _addressController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer created successfully')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerList(apiToken: widget.apiToken, branchId: widget.branchId),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create customer: ${responseData['description']}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create customer')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}
