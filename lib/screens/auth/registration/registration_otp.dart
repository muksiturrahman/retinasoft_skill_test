import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retinasoft_skill_test/screens/auth/login/login_otp.dart';
import 'dart:convert';
import '../../../network/service.dart';

class RegistrationOtp extends StatefulWidget {
  final String identifierId;
  const RegistrationOtp({super.key, required this.identifierId});

  @override
  State<RegistrationOtp> createState() => _RegistrationOtpState();
}

class _RegistrationOtpState extends State<RegistrationOtp> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
                obscureText: false,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if(_otpController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please insert your otp first"),
                      ),
                    );
                  }else{
                    _registrationOtpApi();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registrationOtpApi() async {

    final response = await http.post(
      Uri.parse(ApiService.registrationOtpUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'identifier_id': widget.identifierId,
        'otp_code': _otpController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if(responseData['status'] == 200){
        print("Success");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginOtp()));
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
