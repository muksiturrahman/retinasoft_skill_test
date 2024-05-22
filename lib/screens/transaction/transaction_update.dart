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
    Key? key,
    required this.apiToken,
    required this.branchId,
    required this.transactionId,
    required this.amount,
    required this.details,
    required this.billNo,
    required this.customerId,
  }) : super(key: key);

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  late TextEditingController _amountController;
  late TextEditingController _detailsController;
  late TextEditingController _billNoController;

  String _formattedDateTime = '';
  bool _isLoading = false;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _amountController,
              label: 'Amount',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _detailsController,
              label: 'Details',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _billNoController,
              label: 'Bill No',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _getCurrentDateTime();
                if (_amountController.text.isNotEmpty &&
                    _detailsController.text.isNotEmpty &&
                    _billNoController.text.isNotEmpty &&
                    _formattedDateTime.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  _updateTransactionApi();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter all required fields')),
                  );
                }
              },
              child: _isLoading?CircularProgressIndicator(color: Colors.white,): Text('Update Transaction'),
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
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
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
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update Transaction')),
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
