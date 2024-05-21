import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:retinasoft_skill_test/network/presenter.dart';
import 'package:retinasoft_skill_test/screens/customer/create_customer.dart';
import 'package:retinasoft_skill_test/screens/customer/update_customer.dart';

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
        title: const Text('Customer List'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          customerList.isEmpty?
          Center(
            child: CircularProgressIndicator(),
          ):
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(15),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: customerList.length,
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
                              Text("Id : ${customerList.elementAt(index).id}"),
                              Text("Name : ${customerList.elementAt(index).name}"),
                              Text("Phone : ${customerList.elementAt(index).phone}"),
                              Text("Balance : ${customerList.elementAt(index).balance}"),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateCustomer(apiToken: widget.apiToken, branchId: widget.branchId, customerName: customerList.elementAt(index).name, phoneNumber: customerList.elementAt(index).phone, customerId: customerList.elementAt(index).id,)));
                                },
                                child: Text('Update'),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteCustomerApi(widget.branchId, index, customerList.elementAt(index).id,);
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateCustomer(apiToken: widget.apiToken, branchId: widget.branchId,)));
            },
            child: Text('Create Customer'),
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }

  Future<void> _callCustomerListApi() async {
    try {
      List<CustomersModel> customersModel = [];

      var customerInfo = await initCustomerInfo(context, widget.apiToken, widget.branchId);

      if (customerInfo is String) {
        //Error Message
      } else {
        customersModel.add(customerInfo);
        customerList.addAll(customersModel.elementAt(0).customers.customers);

        setState(() {
          customerList;
        });
      }

      print('');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteCustomerApi(String branchId, int index, String customerId) async {

    final url = '${ApiService.baseUrl}admin/${branchId}/customer/${customerId}/delete';

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
          customerList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer deleted successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Delete Customer')),
      );
    }
  }
}
