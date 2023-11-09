import 'dart:async';
import 'dart:convert';

import 'package:chat_app/modules/login/login_screen.dart';
import 'package:chat_app/shared/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_exception.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';
import 'package:stomp_dart_client/stomp_parser.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/shared/api/notification_api.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../main.dart';
import '../models/user.dart';
import '../modules/calls/call_page/calling_page.dart';
import '../modules/calls/calls_screen.dart';
import '../modules/messages/messages_screen.dart';
import '../modules/settings/settings_screen.dart';
import '../shared/api/notification_api.dart';
import '../shared/components/components.dart';
import 'package:http/http.dart' as http;

import '../shared/navigation_service.dart';

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
  List<String> users = [];
  String url = serverUrl+"users/";
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData icon = Icons.add;
  var userController = TextEditingController();

  // final ScrollController scrollController = ScrollController();
  StreamSubscription<ReceivedAction>? _actionStreamSubscription;
  void listen() async {
    await _actionStreamSubscription?.cancel();

    _actionStreamSubscription = AwesomeNotifications().actionStream.listen((message) {
      if(message.buttonKeyPressed.startsWith("accept")){
        print("/////////////////////////");
        print(message);
        NavigationService().navigateToScreen(CallAcceptDeclinePage(
          user: User(email: "",password: "",username: message.title!.replaceAll(" is calling...", "")),
          callStatus: CallStatus.accepted,
          roomId: message.buttonKeyPressed.replaceAll("accept-", ""),
        ));
      }else if(message.buttonKeyPressed == "decline"){
        // decline call
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listen();
    FirebaseMessaging.instance.getToken().then((token) async {
      connectedUser.token = token!;
      http.put(
          Uri.parse(serverUrl + "setToken"), headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': connectedUser.email,
            'password': connectedUser.password,
            'token': connectedUser.token
          }));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("backgroundMessagebackgroundMessage");
      myBackgroundMessageHandler(message);
    });


    stompClient ??= StompClient(
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

    createDatabase();
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
                  (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
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
                                onChanged: (value) async {
                                  var result = await search(value);
                                  setState(() {
                                    users = result;
                                  });
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
                                  itemBuilder: (context, index) =>
                                      buildNewFriendItem(context, users[index]),
                                  separatorBuilder: (context, index) =>
                                      Padding(
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
                                  itemCount: users.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
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

  Future<List<String>> search(String cle) async {
    var response = await http.get(Uri.parse(url+cle),headers: {"token": connectedUser.token});
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    }
    return [];
  }
}
