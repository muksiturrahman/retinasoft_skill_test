import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retinasoft_skill_test/network/presenter.dart';
import 'package:retinasoft_skill_test/screens/branch/create_branch.dart';
import 'package:retinasoft_skill_test/screens/branch/update_branch.dart';
import 'package:retinasoft_skill_test/screens/customer/customer_list.dart';

import '../../models/branches_model.dart';
import '../../network/service.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String apiToken;
  const HomePage({super.key, required this.apiToken});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Branch> branches = [];


  @override
  void initState() {
    _callBranchesApi();
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   await _callBranchesApi();
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branch List'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          branches.isEmpty?
              Center(
                child: CircularProgressIndicator(),
              ):
          Expanded(
            child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: branches.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerList(apiToken: widget.apiToken, branchId: branches.elementAt(index).id,)));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(branches.elementAt(index).name),
                            Text(branches.elementAt(index).id),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateBranch(apiToken: widget.apiToken, branchId: branches.elementAt(index).id, branchName: branches.elementAt(index).name)));
                              },
                                child: Text('Update'),
                            ),
                            IconButton(
                                onPressed: () {
                                  _deleteBranchApi(branches.elementAt(index).id, index);
                                },
                                icon: Icon(Icons.delete_forever),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateBranch(apiToken: widget.apiToken)));
              },
              child: Text('Create Branch'),
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }

  Future<void> _callBranchesApi() async {
    try {
      List<BranchesModel> branchesModel = [];

      var branchesInfo = await initBranchesInfo(context, widget.apiToken);

      if (branchesInfo is String) {
        //Error Message
      } else {
        branchesModel.add(branchesInfo);
        branches.addAll(branchesModel.elementAt(0).branches.branches);

        setState(() {
          branches;
        });
      }

      print('');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteBranchApi(String branchId, int index) async {

    final url = '${ApiService.baseUrl}admin/branch/${branchId}/delete';

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
          branches.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Branch deleted successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update branch')),
      );
    }
  }

}
