import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retinasoft_skill_test/screens/customer/customer_list.dart';
import 'dart:convert';

import '../../network/service.dart';
import '../../widgets/bottom_navbar.dart';

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
        title: Text('Update Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_customerNameController.text.isNotEmpty || _phoneNumberController.text.isNotEmpty) {
                  _updateCustomerApi();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a customer name')),
                  );
                }
              },
              child: Text('Update Customer'),
            ),
          ],
        ),
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
      if(responseData['status'] == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer updated successfully')),
        );
        /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            BottomNavBar(apiToken: widget.apiToken)), (Route<dynamic> route) => false);*/
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerList(apiToken: widget.apiToken, branchId: widget.branchId),),);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update Customer')),
      );
    }
  }

}
