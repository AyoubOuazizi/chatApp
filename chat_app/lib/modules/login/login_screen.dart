import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:chat_app/layout/home_layout.dart';
import 'package:chat_app/modules/SignUp/SignUp_screen.dart';
import 'package:chat_app/shared/api/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:stomp_dart_client/parser.dart';
import 'package:stomp_dart_client/sock_js/sock_js_parser.dart';
import 'package:stomp_dart_client/sock_js/sock_js_utils.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_exception.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';
import 'package:stomp_dart_client/stomp_parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';

import '../../main.dart';
import '../../models/user.dart';
import '../../shared/components/constants.dart';
import '../calls/call_page/calling_page.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late var emailController = TextEditingController(text: user.email);

  late var passwordController = TextEditingController(text: user.password);

  var formKey = GlobalKey<FormState>();

  User user = User(email: "", password: "");

  String url = serverUrl + "login";

  String error = "";

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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Login',
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
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) {},
                          onChanged: (val) {
                            user.email = val;
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'email must not be empty';
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
                            if (value != null && value.isEmpty) {
                              return 'password must not be empty';
                            }
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
                        if(error != "") const SizedBox(
                          height: 10.0,
                        ),
                        if(error != "") Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.blue,
                          child: MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                var res = await login();
                                if (res == true) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                              color: Colors.white,
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
                      "Don't have account?"
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> login() async {
    setState(() {
      error = "";
    });
    var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': user.email,
          'password': user.password
        }));
    if (response.statusCode == 200) {
      connectedUser = User(email: jsonDecode(response.body)["email"],
          password: jsonDecode(response.body)["password"]);
      connectedUser.username = jsonDecode(response.body)["username"];
      // connectedUser.token = jsonDecode(response.body)["token"];

      //sharedPreferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("user.email", connectedUser.email);
      pref.setString("user.password", connectedUser.password);
      pref.setString("user.username", connectedUser.username);
      pref.setString("user.token", connectedUser.token);

      stompClient = StompClient(
        config: StompConfig(
            url: "${serverUrlWS}websocket-chat",
            onStompError: (StompFrame frame) {
              print(
                  'A stomp error occurred in web socket connection :: ${frame
                      .body}');
            },
            onWebSocketError: (dynamic frame) {
              print(
                  'A Web socket error occurred in web socket connection :: ${frame
                      .toString()}');
            },
            onDebugMessage: (dynamic frame) {
              print(
                  'A debug error occurred in web socket connection :: ${frame
                      .toString()}');
            },
            onConnect: onConnectCallback
        ),
      );
      stompClient.activate();

      return true;
    }
    setState(() {
      error = jsonDecode(response.body)["message"];
    });
    return false;
  }

  Future<void> onConnectCallback(StompFrame connectFrame) async {
    print('${stompClient.toString()} connected with the following frames ${connectFrame.body}');

    var clientUnSubscribeFn = stompClient.subscribe(
        destination: "/queue/${connectedUser.username}",
        callback: onMessageReceived
    );

    stompClient.send(destination: '/app/register', body: connectedUser.username);
  }

  void onMessageReceived(frame) async{
    var message = jsonDecode(frame.body);
      if(database == null) {
        await createDatabase();
      }
      List<Map> chat = await database.rawQuery('SELECT * FROM chats WHERE username="${connectedUser.username}" AND dest="${message['sender']}"');
      if(chat.isEmpty){
        database.transaction((txn) async{
          txn.rawInsert(
            'INSERT INTO chats(username, dest) VALUES("${connectedUser.username}", "${message['sender']}")'
          ).then((value) async {
            chat = await database.rawQuery('SELECT * FROM chats WHERE username="${connectedUser.username}" AND dest="${message['sender']}"');
            database.transaction((txn) async{
              txn.rawInsert(
                  'INSERT INTO messages(id_chat, message, time, received) VALUES(${chat[0]['id']}, "${message['message']}", "${DateFormat.Hm().format(DateTime.parse(message['time'] + 'Z').toUtc().toLocal())}", 1)'
              ).then((value) {
                print('$value inserted successfully');
                NotificationApi().addNotification(
                  title: message['sender'],
                  body: message['message']
                );
                Chatscontroller.add(chat);
              }).catchError((error) {
                print('Error When Inserting New Record ${error.toString()}');
              });
              return null;
            });
            print('$value inserted successfully');
          }).catchError((error) {
            print('Error When Inserting New Record ${error.toString()}');
          });
          return null;
        });
      } else {
        database.transaction((txn) async{
          txn.rawInsert(
              'INSERT INTO messages(id_chat, message, time, received) VALUES(${chat[0]['id']}, "${message['message']}", "${DateFormat.Hm().format(DateTime.parse(message['time'] + 'Z').toLocal())}", 1)'
          ).then((value) {
            print('$value inserted successfully');
            NotificationApi().addNotification(
              title: message['sender'],
              body: message['message']
            );
            Chatscontroller.add(chat);
          }).catchError((error) {
            print('Error When Inserting New Record ${error.toString()}');
          });
          return null;
      });
      }
  }
}
