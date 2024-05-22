import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:retinasoft_skill_test/network/presenter.dart';
import 'package:retinasoft_skill_test/screens/branch/create_branch.dart';
import 'package:retinasoft_skill_test/screens/branch/update_branch.dart';
import 'package:retinasoft_skill_test/screens/customer/customer_list.dart';

import '../../models/branches_model.dart';
import '../../network/service.dart';

class BranchList extends StatefulWidget {
  final String apiToken;

  const BranchList({super.key, required this.apiToken});

  @override
  State<BranchList> createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
  List<Branch> branches = [];

  @override
  void initState() {
    super.initState();
    _callBranchesApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Branch List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            branches.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerList(
                            apiToken: widget.apiToken,
                            branchId: branches.elementAt(index).id,
                          ),
                        ),
                      );
                    },
                    child: Card(
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
                                  branches.elementAt(index).name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  branches.elementAt(index).id,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateBranch(
                                          apiToken: widget.apiToken,
                                          branchId: branches.elementAt(index).id,
                                          branchName: branches.elementAt(index).name,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteBranchApi(branches.elementAt(index).id, index);
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
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateBranch(apiToken: widget.apiToken),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create Branch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _callBranchesApi() async {
    try {
      List<BranchesModel> branchesModel = [];
      var branchesInfo = await initBranchesInfo(context, widget.apiToken);
      if (branchesInfo is String) {
        // Error Message
      } else {
        branchesModel.add(branchesInfo);
        branches.addAll(branchesModel.elementAt(0).branches.branches);
        setState(() {
          branches;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteBranchApi(String branchId, int index) async {
    final url = '${ApiService.baseUrl}admin/branch/$branchId/delete';
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
          branches.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Branch deleted successfully')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete branch')),
      );
    }
  }
}
