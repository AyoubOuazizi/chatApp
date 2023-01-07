import 'package:flutter/material.dart';

import '../modules/calls/calls_screen.dart';
import '../modules/messages/messages_screen.dart';
import '../modules/settings/settings_screen.dart';
import '../shared/components/components.dart';

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
    SettingsScreen(),
  ];
  List<String> titles = [
    'Messages',
    'Calls',
    'Settings',
  ];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData icon = Icons.add;
  var userController = TextEditingController();
  int newChatResultCount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          isBottomSheetShown ? 'New chat' : titles[currentIndex],
        ),
        actions: [
          if (!isBottomSheetShown)
            IconButton(
              onPressed: (){},
              icon: Icon(
                Icons.search,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            if (isBottomSheetShown) {
              Navigator.pop(context);
              isBottomSheetShown = false;
              icon = Icons.add;
            }
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
      floatingActionButton: (currentIndex==0)? FloatingActionButton(
        onPressed: () {
          if(isBottomSheetShown){
            Navigator.pop(context);
            isBottomSheetShown = false;
            setState(() {
              icon = Icons.add;
            });
          } else {
            scaffoldKey.currentState?.showBottomSheet(
                    (context) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: userController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value!=null && value.isEmpty)
                              return 'username must not be empty';
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Username",
                            suffixIcon: Icon(
                              Icons.search,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => buildNewFriendItem(),
                            separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 20.0,
                                end: 20.0,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 1.0,
                                color: Colors.grey[300],
                              ),
                            ),
                            itemCount: newChatResultCount,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                    elevation: 20.0,
            ).closed.then((value)
            {
              isBottomSheetShown = false;
              setState(() {
                icon = Icons.add;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              icon = Icons.close;
            });
          }
        },
        child: Icon(
          icon,
        ),
        backgroundColor: isBottomSheetShown? Colors.lightBlueAccent : Colors.blue,
      ) : null,
      body: screens[currentIndex],
    );
  }
}
