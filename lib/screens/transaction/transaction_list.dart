import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retinasoft_skill_test/screens/transaction/create_transaction.dart';
import '../../models/transaction_list_model.dart';
import '../../network/presenter.dart';
import '../../network/service.dart';
import 'package:retinasoft_skill_test/screens/transaction/transaction_update.dart';

class TransactionList extends StatefulWidget {
  final String apiToken;
  final String branchId;
  final String customerId;

  const TransactionList({
    Key? key,
    required this.apiToken,
    required this.branchId,
    required this.customerId,
  }) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<Transaction> transactionList = [];

  @override
  void initState() {
    _transactionListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'transaction List',
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
      body: Column(
        children: [
          if (transactionList.isEmpty)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: transactionList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: ${transactionList[index].id}",style: TextStyle(fontSize: 14),),
                          Text("Transaction No: ${transactionList[index].transactionNo}",style: TextStyle(fontSize: 14),),
                          Text("Amount: ${transactionList[index].amount}",style: TextStyle(fontSize: 14),),
                          Text("Transaction Date: ${transactionList[index].transactionDate}",style: TextStyle(fontSize: 14),),
                          Text("Details: ${transactionList[index].details}",style: TextStyle(fontSize: 14),),
                          Text("Bill No: ${transactionList[index].billNo}",style: TextStyle(fontSize: 14),),
                        ],
                      ),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateTransaction(
                                    apiToken: widget.apiToken,
                                    branchId: widget.branchId,
                                    customerId: widget.customerId,
                                    transactionId: transactionList[index].id,
                                    amount: transactionList[index].amount,
                                    details: transactionList[index].details,
                                    billNo: transactionList[index].billNo,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteTransactionApi(widget.branchId, index, transactionList[index].id);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // primary: Colors.blueAccent,
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTransaction(
                    apiToken: widget.apiToken,
                    branchId: widget.branchId,
                    customerId: widget.customerId,
                  ),
                ),
              );
            },
            child: const Text('Create Transaction',style: TextStyle(color: Colors.white),),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _transactionListApi() async {
    try {
      List<TransactionListModel> transactionListModel = [];

      var transactionListInfo = await initTransactionListInfo(context, widget.apiToken, widget.branchId, widget.customerId);

      if (transactionListInfo is String) {
        // Error Message
      } else {
        transactionListModel.add(transactionListInfo);
        transactionList.addAll(transactionListModel[0].transactions.transactions);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteTransactionApi(String branchId, int index, String transactionId) async {
    final url = '${ApiService.baseUrl}admin/$branchId/customer/transaction/$transactionId/delete';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        setState(() {
          transactionList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to Delete Transaction')),
      );
    }
  }
}
