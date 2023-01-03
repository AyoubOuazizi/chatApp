import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
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
                    'Chaouki Mansour',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('I hate school'),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Mail adress'),
                    subtitle: Text("0666778899"),
                    onTap: () {
                      // show dialog to update phone number
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Email'),
                    subtitle: Text("chaouki@gmail.com"),
                    onTap: () {
                      // show dialog to update email
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('About our Chat App'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Log out',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                    textColor: Colors.red,
                  ),
                  Row(
                    children: [
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRt7ROwCM_0CZhrhmZ_svE5m1KhfTu5gNUdduLqLuZP9XhPseMtoc52HGIPXvX3VO2AlH8&usqp=CAU',
                        width: 19,
                      ),
                    ],
                  ),
                ])));
  }
}