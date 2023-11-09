import 'package:chat_app/models/user.dart';
import 'package:chat_app/modules/login/login_screen.dart';
import 'package:chat_app/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(
            top: 60.0,
            right: 20.0,
            bottom: 20.0,
            left: 20.0,
          ),
          child: Container(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      connectedUser.username,
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mail address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                ),
                                child: Text(
                                  connectedUser.email,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        bottom: 10.0,
                        right: 5.0,
                        top: 10.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        bottom: 10.0,
                        right: 5.0,
                        top: 10.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About ChatApp',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        connectedUser = User(email: "", password: "");
                        SharedPreferences.getInstance().then((pref) {
                          pref.remove("user.email");
                          pref.remove("user.password");
                          pref.remove("user.username");
                          pref.remove("user.token");
                        });
                        if(stompClient!=null) {
                          stompClient.deactivate();
                        }
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (Route<dynamic> route) => false
                        );
                      },
                      child: Ink(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            bottom: 10.0,
                            right: 5.0,
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Log out',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
              ),
          ),
      ),
    );
  }
}