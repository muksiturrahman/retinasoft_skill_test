import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../network/service.dart';
import '../../widgets/bottom_navbar.dart';

class UpdateBranch extends StatefulWidget {
  final String apiToken;
  final String branchId;
  final String branchName;

  const UpdateBranch({
    super.key,
    required this.apiToken,
    required this.branchId,
    required this.branchName,
  });

  @override
  State<UpdateBranch> createState() => _UpdateBranchState();
}

class _UpdateBranchState extends State<UpdateBranch> {
  late TextEditingController _branchNameController;

  @override
  void initState() {
    super.initState();
    _branchNameController = TextEditingController(text: widget.branchName);
  }


  @override
  void dispose() {
    _branchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Branch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _branchNameController,
              decoration: InputDecoration(
                labelText: 'Branch Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_branchNameController.text.isNotEmpty) {
                  _updateBranchApi(_branchNameController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a branch name')),
                  );
                }
              },
              child: Text('Update Branch'),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _updateBranchApi(String branchName) async {
    final url = '${ApiService.baseUrl}admin/branch/${widget.branchId}/update';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
      body: jsonEncode({'name': branchName}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData['status'] == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Branch updated successfully')),
        );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            BottomNavBar(apiToken: widget.apiToken)), (Route<dynamic> route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update branch')),
      );
    }
  }

}
