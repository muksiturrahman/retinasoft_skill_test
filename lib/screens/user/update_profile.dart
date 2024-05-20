import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:retinasoft_skill_test/network/service.dart';
import 'package:retinasoft_skill_test/screens/user/profile.dart';
import 'package:retinasoft_skill_test/widgets/bottom_navbar.dart';

class UpdateProfile extends StatefulWidget {
  final String apiToken;
  final String name;
  final String email;
  final String phone;
  final String businessTypeId;

  const UpdateProfile({
    super.key,
    required this.apiToken,
    required this.name,
    required this.email,
    required this.phone, required this.businessTypeId,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
  }

  Future<void> _updateProfile() async {
    final response = await http.post(
      Uri.parse(ApiService.getProfileUpdateUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'business_type_id': widget.businessTypeId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if(responseData['status'] == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['description'] ?? 'Profile updated successfully'),
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavBar(apiToken: widget.apiToken)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
