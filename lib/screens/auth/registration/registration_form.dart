import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:retinasoft_skill_test/screens/auth/login/login_screen.dart';
import 'package:retinasoft_skill_test/screens/auth/registration/registration_otp.dart';

import '../../../models/business_type_model.dart';
import '../../../network/presenter.dart';
import '../../../network/service.dart';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  bool _isLoading = false;
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          customTextField(_nameController, "Name"),
                          SizedBox(
                            height: 10,
                          ),
                          customTextField(_emailController, "Email"),
                          SizedBox(
                            height: 10,
                          ),
                          customTextField(_phoneController, "Phone Number"),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<BusinessType>(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            hint: const Text(
                              'Select Business Name',
                              style: TextStyle(color: Colors.white),
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
                          SizedBox(height: 10.0),
                          DropdownButtonFormField<BusinessType>(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            hint: const Text(
                              'Select Business Type Id',
                              style: TextStyle(color: Colors.white),
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
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: InkWell(
                                    onTap: () {
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
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        _callRegistrationApi();
                                      }
                                    },
                                    child: _isLoading? Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white,),
                                    ):Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
                                },
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
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

  Future<void> _callRegistrationApi() async {

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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationOtpScreen(identifierId: responseData['identifier_id'].toString(),)));
        setState(() {
          _isLoading = false;
        });
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


Widget customTextField(TextEditingController controller, String hintText){
  return TextField(
    controller: controller,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )),
  );
}

