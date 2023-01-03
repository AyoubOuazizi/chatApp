import 'package:flutter/material.dart';

import '../modules/calls/calls_screen.dart';
import '../modules/messages/messages_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    MsgScreen(),
    CallScreen(),
    CallScreen(),
  ];
  List<String> titles = [
    'Messages',
    'Calls',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.search
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        elevation: 10.0,
        iconSize: 30.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.call,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: '',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          (currentIndex==1)? Icons.add_ic_call:Icons.message,
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
