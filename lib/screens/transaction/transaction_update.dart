import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:retinasoft_skill_test/screens/transaction/transaction_list.dart';
import 'dart:convert';

import '../../network/service.dart';

class UpdateTransaction extends StatefulWidget {
  final String apiToken;
  final String branchId;
  final String transactionId;
  final String customerId;
  final String amount;
  final String details;
  final String billNo;

  const UpdateTransaction({
    super.key,
    required this.apiToken,
    required this.branchId,
    required this.transactionId,
    required this.amount,
    required this.details,
    required this.billNo, required this.customerId,
  });

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  late TextEditingController _amountController;
  late TextEditingController _detailsController;
  late TextEditingController _billNoController;

  String _formattedDateTime = '';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.amount);
    _detailsController = TextEditingController(text: widget.details);
    _billNoController = TextEditingController(text: widget.billNo);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _detailsController.dispose();
    _billNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                labelText: 'Details',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _billNoController,
              decoration: InputDecoration(
                labelText: 'Bill No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _getCurrentDateTime();
                if (_amountController.text.isNotEmpty ||
                    _detailsController.text.isNotEmpty ||
                _billNoController.text.isNotEmpty && _formattedDateTime.isNotEmpty) {
                  _updateTransactionApi();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter all required fields')),
                  );
                }
              },
              child: const Text('Update Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateTransactionApi() async {
    final url =
        '${ApiService.baseUrl}admin/${widget.branchId}/customer/transaction/${widget.transactionId}/update';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
      body: jsonEncode({
        'amount': _amountController.text,
        'transaction_date': _formattedDateTime,
        'details': _detailsController.text,
        'bill_no': _billNoController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction updated successfully')),
        );
        /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            BottomNavBar(apiToken: widget.apiToken)), (Route<dynamic> route) => false);*/
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionList(
                apiToken: widget.apiToken, branchId: widget.branchId, customerId: widget.customerId,),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update Transaction')),
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
