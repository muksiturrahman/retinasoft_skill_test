import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:retinasoft_skill_test/network/presenter.dart';
import 'package:retinasoft_skill_test/screens/customer/create_customer.dart';
import 'package:retinasoft_skill_test/screens/customer/update_customer.dart';
import 'package:retinasoft_skill_test/screens/transaction/transaction_list.dart';
import '../../models/customers_model.dart';
import '../../network/service.dart';
import 'package:http/http.dart' as http;

class CustomerList extends StatefulWidget {
  final String apiToken;
  final String branchId;

  const CustomerList({super.key, required this.apiToken, required this.branchId});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<Customer> customerList = [];

  @override
  void initState() {
    _callCustomerListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer List',
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
            customerList.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: customerList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Id: ${customerList.elementAt(index).id}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Name: ${customerList.elementAt(index).name}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Phone: ${customerList.elementAt(index).phone}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Balance: ${customerList.elementAt(index).balance}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TransactionList(
                                            apiToken: widget.apiToken,
                                            branchId: widget.branchId,
                                            customerId: customerList.elementAt(index).id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Transactions',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateCustomer(
                                            apiToken: widget.apiToken,
                                            branchId: widget.branchId,
                                            customerName: customerList.elementAt(index).name,
                                            phoneNumber: customerList.elementAt(index).phone,
                                            customerId: customerList.elementAt(index).id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteCustomerApi(
                                    widget.branchId,
                                    index,
                                    customerList.elementAt(index).id,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
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
                    builder: (context) => CreateCustomer(
                      apiToken: widget.apiToken,
                      branchId: widget.branchId,
                    ),
                  ),
                );
              },
              child: const Text(
                'Create Customer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _callCustomerListApi() async {
    try {
      List<CustomersModel> customersModel = [];
      var customerInfo = await initCustomerInfo(context, widget.apiToken, widget.branchId);
      if (customerInfo is String) {
        // Error Message
      } else {
        customersModel.add(customerInfo);
        customerList.addAll(customersModel.elementAt(0).customers.customers);
        setState(() {
          customerList;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteCustomerApi(String branchId, int index, String customerId) async {
    final url = '${ApiService.baseUrl}admin/$branchId/customer/$customerId/delete';
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
          customerList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer deleted successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete customer')),
      );
    }
  }
}
