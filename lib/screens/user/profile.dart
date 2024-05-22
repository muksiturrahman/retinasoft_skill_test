import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:retinasoft_skill_test/network/service.dart';
import 'package:retinasoft_skill_test/screens/auth/login/login_screen.dart';
import 'package:retinasoft_skill_test/screens/user/update_profile.dart';

class Profile extends StatefulWidget {
  final String apiToken;

  const Profile({
    super.key,
    required this.apiToken,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _profileData;
  bool _isLoading = false;

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
      // appBar: AppBar(
      //   backgroundColor: Colors.grey.shade300,
      //   title: const Text('Profile',style: TextStyle(color: Colors.white),),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/rafi.jpg'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        user['name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        user['email'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      buildProfileInfoRow('Phone', user['phone']),
                      buildProfileInfoRow('Business Name', user['business_name']),
                      buildProfileInfoRow('Business Type', user['business_type']),
                      buildProfileInfoRow('Branch', user['branch']),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfile(
                                apiToken: widget.apiToken,
                                name: user['name'],
                                email: user['email'],
                                phone: user['phone'],
                                businessTypeId: user['business_type_id'].toString(),
                              ),
                            ),
                          );
                        },
                        child: Text('Update Profile'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _callLogOutApi,
                        child: _isLoading? CircularProgressIndicator():Text('Log Out'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: deleteAccount,
                        child: Text('Delete Account'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
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
      if (responseData['status'] == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['description'] ?? 'Account deleted successfully'),
          ),
        );
      } else {
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
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse(ApiService.logOutUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.apiToken}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['description'] ?? 'Logout success'),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        print(responseData);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to logout'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}
