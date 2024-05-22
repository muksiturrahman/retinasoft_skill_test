import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:retinasoft_skill_test/network/service.dart';
import 'package:retinasoft_skill_test/screens/transaction/transaction_list.dart';

class CreateTransaction extends StatefulWidget {
  final String apiToken;
  final String branchId;
  final String customerId;

  const CreateTransaction({
    Key? key,
    required this.apiToken,
    required this.branchId,
    required this.customerId,
  }) : super(key: key);

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _billNoController = TextEditingController();

  String _formattedDateTime = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Transaction'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _amountController,
              label: 'Amount',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: _typeController,
              label: 'Type',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: _detailsController,
              label: 'Details',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: _billNoController,
              label: 'Bill No',
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _getCurrentDateTime();
                if (_formattedDateTime.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  _createTransactionApi();
                }
              },
              child: const Text('Create Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
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
    final url =
        '${ApiService.baseUrl}admin/${widget.branchId}/customer/transaction/create';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
      body: jsonEncode(
        <String, String>{
          'customer_id': widget.customerId,
          'amount': _amountController.text,
          'type': _typeController.text,
          'transaction_date': _formattedDateTime,
          'details': _detailsController.text,
          'bill_no': _billNoController.text,
        },
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction created successfully')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionList(
              apiToken: widget.apiToken,
              branchId: widget.branchId,
              customerId: widget.customerId,
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create Transaction: ${responseData['description']}',
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create transaction')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getCurrentDateTime() {
    final now = DateTime.now();
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    setState(() {
      _formattedDateTime = formattedDateTime;
    });
  }
}
