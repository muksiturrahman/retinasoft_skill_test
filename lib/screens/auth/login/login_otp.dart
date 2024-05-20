import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retinasoft_skill_test/network/service.dart';
import 'package:retinasoft_skill_test/screens/auth/login/login_screen.dart';

class LoginOtp extends StatefulWidget {
  const LoginOtp({super.key});

  @override
  State<LoginOtp> createState() => _LoginOtpState();
}

class _LoginOtpState extends State<LoginOtp> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login",style: TextStyle(fontSize: 40),),
              SizedBox(height: 100,),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if(_emailController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please insert your email first"),
                      ),
                    );
                  }else{
                    _loginOtp();
                  }
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginOtp() async {

    final response = await http.post(
      Uri.parse(ApiService.loginOtpUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'identifier': _emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if(responseData['description'] == "Success"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen(email: _emailController.text)));
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
          title: Text('Bad Data/Network'),
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
