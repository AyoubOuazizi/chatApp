import 'dart:convert';

import 'package:chat_app/modules/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../../models/user.dart';
import '../../shared/components/constants.dart';

class SignUpScreen extends StatefulWidget {

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late var usernameController = TextEditingController(text: user.username);

  late var emailController = TextEditingController(text: user.email);

  late var passwordController = TextEditingController(text: user.password);

  var confirmPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  User user = User(email: "", password: "");

  String url = serverUrl+"register";

  String error="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backLogin.png"),
                fit: BoxFit.cover,
              )
          ),

          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    bottom: 10.0,
                                  ),
                                  child: Image(
                                    image: AssetImage('assets/images/logo.png'),
                                    height: 150.0,
                                    width: 150.0,
                                  ),
                                ),
                                Text(
                                  'SignUp',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            TextFormField(
                              controller: usernameController,
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (value) {},
                              onChanged: (val) {
                                user.username = val;
                              },
                              validator: (value) {
                                if(value!=null && value.isEmpty) {
                                  return 'username must not be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Username",
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (value) {},
                              onChanged: (val) {
                                user.email = val;
                              },
                              validator: (value) {
                                if(value!=null && value.isEmpty) {
                                  return 'email must not be empty';
                                }
                                else if (value!=null && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'enter a valid email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                prefixIcon: Icon(
                                  Icons.email,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              onFieldSubmitted: (value) {},
                              onChanged: (val) {
                                user.password = val;
                              },
                              validator: (value) {
                                if(value!=null && value.isEmpty)
                                  return 'password must not be empty';
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                ),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if(value!=null && value.isEmpty || value != user.password) {
                                  return 'please confirm password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                ),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            if(error!="") const SizedBox(
                              height: 10.0,
                            ),
                            if(error!="") Text(
                              error,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              color: Colors.blue,
                              child: MaterialButton(
                                onPressed: () async {
                                  if(formKey.currentState!.validate()) {
                                    var res = await register();
                                    if(res){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Create an account',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Already have an account"
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                      ),
                    ),
                  ],
                ),
              ],

            ),
          )

      ),
    );
  }

  Future<bool> register() async {
    var response = await http.post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: json.encode({
      'username': user.username,
      'email': user.email,
      'password': user.password
    }));
    if (response.statusCode == 200) {
      return true;
    }
    setState((){
      error = jsonDecode(response.body)["message"];
    });
    print(jsonDecode(response.body)["message"]);
    return false;
  }
}