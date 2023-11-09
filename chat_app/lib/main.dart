import 'dart:convert';

import 'package:chat_app/shared/api/notification_api.dart';
import 'package:chat_app/shared/components/constants.dart';
import 'package:chat_app/shared/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'layout/home_layout.dart';
import 'models/user.dart';
import 'modules/calls/call_page/calling_page.dart';
import 'modules/login/login_screen.dart';

// User user = User(
//     email: "yashmakan.fake.email@gmail.com",
//     username: "yashmakan",
//     password: "79aa7b81bcdd14fd98282b810b61312b",
//     firebaseToken: "e1E1sZR4T-ysib46L2idFq:APA91bFRtT1a2Q_HqIWMwN7iKX6TIt4nBHIum3sQPTl3lTYWYx0nSh1khX8Tg0ntOzTWlnZgsh_PowXEKl58MF_9tO2Sn5QFZ_6yRkdiU-B54EgwP680vozB4zfeIEi_vxI4IzOGWKcd",
//     uuid: "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
// );
//
// User rick = User(
//     email: "rick.fake.email@gmail.com",
//     username: "rickkk",
//     password: "79aa7b81bcdd14fd98282b810b61312a",
//     firebaseToken: "dvj3V4o_RL6Pxzciibm6Kc:APA91bGEAwG27eHHsraJ-b_4K0DXaUpwcUVPyjvr0M7AKJeyoR-UzmG3ey7rTqKKwVm40ellYiD0ZYUhyclpIGXcb0XFdY_LhaNDwUP6ooy_BIYQl4Ae_scfdTyCu8-Ojg4Q7QsTdzj1",
//     uuid: "b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6a",
// );

Future<void> myBackgroundMessageHandler(RemoteMessage event) async {
  Map message = event.toMap();
  print('backgroundMessage: message => ${message.toString()}');
  var payload = message['data'];
  var roomId = payload['room_id'] as String;
  var callerName = payload['caller_name'] as String;
  var uuid = payload['uuid'] as String?;
  var hasVideo = payload['has_video'] == "true";

  final callUUID = uuid ?? const Uuid().v4();

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: '$callerName is calling...',
        body: 'Pick up!!!',
      ),
      actionButtons: [
        NotificationActionButton(
          label: 'Decline',
          enabled: true,
          isDangerousOption: true,
          buttonType: ActionButtonType.DisabledAction,
          key: 'decline',
        ),
        NotificationActionButton(
          label: 'Accept',
          enabled: true,
          buttonType: ActionButtonType.Default,
          key: 'accept-$roomId',
        )
      ]
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Whatsapp',
            channelDescription: 'Whatsapp calling',
            defaultColor: Colors.green,
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);


  await NotificationApi().setup();

  SharedPreferences prefs =await SharedPreferences.getInstance();
  var email=prefs.getString("user.email");
  var password=prefs.getString("user.password");
  bool isLogged = false;
  if(email!=null && password!=null) {
    isLogged = true;
    connectedUser = User(email: email,password: password);
    connectedUser.username = prefs.getString("user.username")!;
    connectedUser.token = prefs.getString("user.token")!;
  }
  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
      home: isLogged? HomeScreen() : LoginScreen(),
      navigatorKey: NavigationService().navigationKey,
    );
  }
}