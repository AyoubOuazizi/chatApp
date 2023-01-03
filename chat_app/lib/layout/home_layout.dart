import 'package:flutter/material.dart';

import '../modules/messages/messages_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ChatApp'
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
        onTap: (index){},
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
          Icons.message,
        ),
      ),
      body: MsgScreen(),
    );
  }
}
