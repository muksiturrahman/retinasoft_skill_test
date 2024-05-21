import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retinasoft_skill_test/widgets/bottom_navbar.dart';
import 'dart:convert';

import '../../network/service.dart';

class CreateBranch extends StatefulWidget {
  final String apiToken;

  const CreateBranch({super.key, required this.apiToken});

  @override
  State<CreateBranch> createState() => _CreateBranchState();
}

class _CreateBranchState extends State<CreateBranch> {
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Branch'),
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
                  _createBranchApi(_branchNameController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a branch name')),
                  );
                }
              },
              child: Text('Create Branch'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _branchNameController.dispose();
    super.dispose();
  }

  Future<void> _createBranchApi(String branchName) async {
    final response = await http.post(
      Uri.parse(ApiService.createBranchUrl),
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
          SnackBar(content: Text('Branch created successfully')),
        );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            BottomNavBar(apiToken: widget.apiToken)), (Route<dynamic> route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create branch')),
      );
    }
  }

}
