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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Customer'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _typeController,
                decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _createCustomer,
                child: Text('Create Customer'),
              ),
            ],
          ),
        ),
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CustomerList(apiToken: widget.apiToken, branchId: widget.branchId)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create customer: ${responseData['description']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create customer')),
      );
    }
  }

}
