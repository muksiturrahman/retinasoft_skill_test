import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:retinasoft_skill_test/screens/auth/registration/registration_otp.dart';

import '../../../models/business_type_model.dart';
import '../../../network/presenter.dart';
import '../../../network/service.dart';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  BusinessType? _selectedBusinessName;
  BusinessType? _selectedBusinessTypeId;

  List<BusinessType> businessTypes = [];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _callBusinessTypeApi();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),

                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.0),

                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),

                DropdownButtonFormField<BusinessType>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text(
                    'Select Business Name',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: _selectedBusinessName,
                  onChanged: (BusinessType? newValue) {
                    setState(() {
                      _selectedBusinessName = newValue!;
                    });
                  },
                  items: businessTypes
                      .map((BusinessType businessName) {
                    return DropdownMenuItem<BusinessType>(
                      value: businessName,
                      child: Text(
                        businessName.name,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),

                DropdownButtonFormField<BusinessType>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text(
                    'Select Business Type Id',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: _selectedBusinessTypeId,
                  onChanged: (BusinessType? newValue) {
                    setState(() {
                      _selectedBusinessTypeId = newValue!;
                    });
                  },
                  items: businessTypes
                      .map((BusinessType businessTypeId) {
                    return DropdownMenuItem<BusinessType>(
                      value: businessTypeId,
                      child: Text(
                        businessTypeId.id,
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 16.0),

                SizedBox(height: 32.0),

                // Register Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {

                      if(
                      _selectedBusinessTypeId.toString().isEmpty ||
                          _selectedBusinessName.toString().isEmpty ||
                      _nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _phoneController.text.isEmpty
                      ){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Field is Empty"),
                          ),
                        );
                      }else{
                        _registrationApi();
                      }
                    },
                    child: Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _callBusinessTypeApi() async {
    try {
      List<BusinessTypeModel> businessTypeModel = [];


      var businessTypeInfo = await initBusinessTypeInfo(context);

      if (businessTypeInfo is String) {
        //Error Message
      } else {
        businessTypeModel.add(businessTypeInfo);
        businessTypes.addAll(businessTypeModel.elementAt(0).businessTypes);

        setState(() {
          businessTypes;
        });
      }

      print('');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _registrationApi() async {

    final response = await http.post(
      Uri.parse(ApiService.registrationUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': _phoneController.text,
        'email': _emailController.text,
        'name': _nameController.text,
        'business_name': _selectedBusinessName!.name,
        'business_type_id': _selectedBusinessTypeId!.id,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if(responseData['status'] == 200){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegistrationOtp(identifierId: responseData['identifier_id'].toString(),)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['description']),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

}
