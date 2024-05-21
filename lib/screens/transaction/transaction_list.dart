import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:retinasoft_skill_test/models/transaction_list_model.dart';
import 'package:retinasoft_skill_test/network/presenter.dart';
import 'package:retinasoft_skill_test/screens/customer/create_customer.dart';
import 'package:retinasoft_skill_test/screens/customer/update_customer.dart';
import 'package:retinasoft_skill_test/screens/transaction/create_transaction.dart';
import 'package:retinasoft_skill_test/screens/transaction/transaction_update.dart';

import '../../models/customers_model.dart';
import '../../network/service.dart';
import 'package:http/http.dart' as http;

class TransactionList extends StatefulWidget {
  final String apiToken;
  final String branchId;
  final String customerId;
  const TransactionList({super.key, required this.apiToken, required this.branchId, required this.customerId});

  @override
  State<TransactionList> createState() => _TransactionListState();
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
        title: const Text('Transaction List'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          transactionList.isEmpty?
          Center(
            child: CircularProgressIndicator(),
          ):
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(15),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: transactionList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text("Id : ${transactionList.elementAt(index).id}"),
                              Text("Transaction No : ${transactionList.elementAt(index).transactionNo}"),
                              Text("Amount : ${transactionList.elementAt(index).amount}"),
                              Text("Transaction Date : ${transactionList.elementAt(index).transactionDate}"),
                              Text("Details : ${transactionList.elementAt(index).details}"),
                              Text("Bill No : ${transactionList.elementAt(index).billNo}"),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateTransaction(apiToken: widget.apiToken, branchId: widget.branchId, customerId: widget.customerId, transactionId: transactionList.elementAt(index).id, amount: transactionList.elementAt(index).amount, details: transactionList.elementAt(index).details, billNo: transactionList.elementAt(index).billNo,)));
                                },
                                child: Text('Update'),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteTransactionApi(widget.branchId, index, transactionList.elementAt(index).id,);
                                },
                                icon: Icon(Icons.delete_forever),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTransaction(apiToken: widget.apiToken, branchId: widget.branchId, customerId: widget.customerId,)));
            },
            child: Text('Create Transaction'),
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }

  Future<void> _transactionListApi() async {
    try {
      List<TransactionListModel> transactionListModel = [];

      var transactionListInfo = await initTransactionListInfo(context, widget.apiToken, widget.branchId, widget.customerId);

      if (transactionListInfo is String) {
        //Error Message
      } else {
        transactionListModel.add(transactionListInfo);
        transactionList.addAll(transactionListModel.elementAt(0).transactions.transactions);

        setState(() {
          transactionList;
        });
      }

      print('');
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
      if(responseData['status'] == 200){
        setState(() {
          transactionList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction deleted successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Delete Transaction')),
      );
    }
  }
}
