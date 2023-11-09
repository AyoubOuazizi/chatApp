import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/user.dart';
import '../api/notification_api.dart';

User connectedUser = User(email: "",password: "");
String serverUrl = "http://192.168.1.4:8080/";
String serverUrlWS = "ws://192.168.1.4e:8080/";
var database = null;
var stompClient = null;

StreamController<List<Map>> Chatscontroller = StreamController<List<Map>>.broadcast();

Future createDatabase() async{
  database = await openDatabase(
    'chat.db',
    version: 1,
    onCreate: (database, version) {
      print('database created');
      database.execute('CREATE TABLE chats(id INTEGER PRIMARY KEY, username TEXT, dest TEXT)').then((value) {
        print('table created');
        database.execute('CREATE TABLE messages(id INTEGER PRIMARY KEY, id_chat INTEGER, message TEXT, time TEXT, received INTEGER, FOREIGN KEY (id_chat) REFERENCES chats (id) ON DELETE NO ACTION ON UPDATE NO ACTION)').then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      }).catchError((error) {
        print('Error When Creating Table ${error.toString()}');
      });
    },
    onOpen: (database) {
      print('database opened');
    },
  );
  return database;
}

/***********************************************************/

// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   return true;
// }
//
// onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   stompClient = StompClient(
//     config: StompConfig(
//         url: "${serverUrlWS}websocket-chat",
//         onStompError: (StompFrame frame) {
//           print(
//               'A stomp error occurred in web socket connection :: ${frame
//                   .body}');
//         },
//         onWebSocketError: (dynamic frame) {
//           print(
//               'A Web socket error occurred in web socket connection :: ${frame
//                   .toString()}');
//         },
//         onDebugMessage: (dynamic frame) {
//           print(
//               'A debug error occurred in web socket connection :: ${frame
//                   .toString()}');
//         },
//         onConnect: onConnectCallback
//     ),
//   );
//   stompClient.activate();
// }
//
// Future<void> onConnectCallback(StompFrame connectFrame) async {
//   print('${stompClient.toString()} connected with the following frames ${connectFrame.body}');
//
//   var clientUnSubscribeFn = stompClient.subscribe(
//       destination: "/queue/${connectedUser.username}",
//       callback: onMessageReceived
//   );
//
//   stompClient.send(destination: '/app/register', body: connectedUser.username);
// }
//
// void onMessageReceived(frame) async{
//   var message = jsonDecode(frame.body);
//     if(database == null) {
//       await createDatabase();
//     }
//     List<Map> chat = await database.rawQuery('SELECT * FROM chats WHERE username="${connectedUser.username}" AND dest="${message['sender']}"');
//     if(chat.isEmpty){
//       database.transaction((txn) async{
//         txn.rawInsert(
//           'INSERT INTO chats(username, dest) VALUES("${connectedUser.username}", "${message['sender']}")'
//         ).then((value) async {
//           chat = await database.rawQuery('SELECT * FROM chats WHERE username="${connectedUser.username}" AND dest="${message['sender']}"');
//           database.transaction((txn) async{
//             txn.rawInsert(
//                 'INSERT INTO messages(id_chat, message, time, received) VALUES(${chat[0]['id']}, "${message['message']}", "${DateFormat.Hm().format(DateTime.parse(message['time'] + 'Z').toUtc().toLocal())}", 1)'
//             ).then((value) {
//               print('$value inserted successfully');
//               NotificationApi().addNotification(
//                 title: message['sender'],
//                 body: message['message']
//               );
//               Chatscontroller.add(chat);
//             }).catchError((error) {
//               print('Error When Inserting New Record ${error.toString()}');
//             });
//             return null;
//           });
//           print('$value inserted successfully');
//         }).catchError((error) {
//           print('Error When Inserting New Record ${error.toString()}');
//         });
//         return null;
//       });
//     } else {
//       database.transaction((txn) async{
//         txn.rawInsert(
//             'INSERT INTO messages(id_chat, message, time, received) VALUES(${chat[0]['id']}, "${message['message']}", "${DateFormat.Hm().format(DateTime.parse(message['time'] + 'Z').toLocal())}", 1)'
//         ).then((value) {
//           print('$value inserted successfully');
//           NotificationApi().addNotification(
//             title: message['sender'],
//             body: message['message']
//           );
//           Chatscontroller.add(chat);
//         }).catchError((error) {
//           print('Error When Inserting New Record ${error.toString()}');
//         });
//         return null;
//     });
//     }
// }