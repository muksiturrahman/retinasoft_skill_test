import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:retinasoft_skill_test/network/service.dart';
import 'package:retinasoft_skill_test/screens/auth/login/login_screen.dart';
import 'package:retinasoft_skill_test/screens/user/update_profile.dart';

class Profile extends StatefulWidget {
  final String apiToken;

  const Profile({
    super.key, required this.apiToken,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = fetchProfile();
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await http.get(
      Uri.parse(ApiService.getProfileUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No profile data found'));
          } else {
            final responseData = snapshot.data!;
            final user = responseData['response_user'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${user['name']}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Email: ${user['email']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Phone: ${user['phone']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Business Name: ${user['business_name']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Business Type: ${user['business_type']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Branch: ${user['branch']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 50,),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProfile(apiToken: widget.apiToken,
                                      name: user['name'],
                                      email: user['email'],
                                      phone: user['phone'],
                                      businessTypeId: user['business_type_id']
                                          .toString(),)));
                          },
                          child: Text('Update profile'),
                        ),
                        SizedBox(height: 50,),
                        ElevatedButton(
                          onPressed: () {
                            _callLogOutApi();
                          },
                          child: Text('Log Out'),
                        ),
                        SizedBox(height: 50,),
                        ElevatedButton(
                          onPressed: () {
                            deleteAccount();
                          },
                          child: Text('Delete Account'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  Future<void> deleteAccount() async {
    final response = await http.get(
      Uri.parse(ApiService.deleteAccountUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if(responseData['status'] == 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginScreen()), (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['description'] ?? 'Account deleted successfully'),
          ),
        );
      }else{
        print(responseData);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account'),
        ),
      );
    }
}

  Future<void> _callLogOutApi() async {
    final response = await http.post(
      Uri.parse(ApiService.logOutUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if(responseData['status'] == 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginScreen()), (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['description'] ?? 'Logout success'),
          ),
        );
      }else{
        print(responseData);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to logout'),
        ),
      );
    }
}
}
