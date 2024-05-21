import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:retinasoft_skill_test/network/service.dart';
import 'package:retinasoft_skill_test/screens/customer/customer_list.dart';
import 'package:retinasoft_skill_test/screens/transaction/transaction_list.dart';

class CreateTransaction extends StatefulWidget {
  final String apiToken;
  final String branchId;
  final String customerId;
  const CreateTransaction({super.key, required this.apiToken, required this.branchId, required this.customerId});

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _billNoController = TextEditingController();

  String _formattedDateTime = '';

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
                controller: _amountController,
                decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder()
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
                controller: _detailsController,
                decoration: InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _billNoController,
                decoration: InputDecoration(
                  labelText: 'Bill No',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (){
                  _getCurrentDateTime();
                  if(_formattedDateTime.isNotEmpty){
                    _createTransactionApi();
                  }
                },
                child: Text('Create Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _amountController.dispose();
    _typeController.dispose();
    super.dispose();
  }


  Future<void> _createTransactionApi() async {
    final url = '${ApiService.baseUrl}admin/${widget.branchId}/customer/transaction/create';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
      body: jsonEncode(<String, String>{
        'customer_id': widget.customerId,
        'amount': _amountController.text,
        'type': _typeController.text,
        'transaction_date': _formattedDateTime,
        'details': _detailsController.text,
        'bill_no': _billNoController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction created successfully')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TransactionList(apiToken: widget.apiToken, branchId: widget.branchId, customerId: widget.customerId,)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create Transaction: ${responseData['description']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create customer')),
      );
    }
  }

  void _getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    setState(() {
      _formattedDateTime = formattedDateTime;
    });
  }
}
