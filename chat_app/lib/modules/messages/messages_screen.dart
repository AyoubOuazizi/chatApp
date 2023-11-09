import 'dart:async';

import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class MsgScreen extends StatefulWidget {
  @override
  State<MsgScreen> createState() => _MsgScreenState();
}

class _MsgScreenState extends State<MsgScreen> {
  Future<List<Map>> oldChats = Future.value(<Map>[]);
  StreamSubscription? streamSubscription;
  List<Map> allChats = [];
  Map<String,Map> LastMsgs = {};

  @override
  void initState() {
    super.initState();
    getChatsFromDB().then((value) {
      if (mounted) {
        setState(() {
          allChats = value;
        });
      }
    });
    getLastMsgsFromDB().then((result) {
      List<Map> list = [];
      List<Map> finalList = [];
      List<Map> chats = [];
      result.forEach((k, v) => list.add(v));
      list.sort((a, b) => a['id'].compareTo(b['id']));
      finalList = list.reversed.toList();
      finalList.forEach((element) {
        Map msg = allChats.firstWhere((elm) => elm['id']==element['id_chat']);
        chats.add(msg);
      });
      allChats = chats;
      if (mounted) {
        setState(() {
          LastMsgs = result;
        });
      }
    });
    Stream stream = Chatscontroller.stream;
    streamSubscription?.cancel().then((value) => {
      streamSubscription = stream.listen((value) {
        getChatsFromDB().then((value) {
        if (mounted) {
          setState(() {
            allChats = value;
          });
        }
        });
        getLastMsgsFromDB().then((result) {
          List<Map> list = [];
          List<Map> finalList = [];
          List<Map> chats = [];
          result.forEach((k, v) => list.add(v));
          list.sort((a, b) => a['id'].compareTo(b['id']));
          finalList = list.reversed.toList();
          finalList.forEach((element) {
            Map msg = allChats.firstWhere((elm) => elm['id']==element['id_chat']);
            chats.add(msg);
          });
          allChats = chats;
          if (mounted) {
            setState(() {
              LastMsgs = result;
            });
          }
        });
        print('Value from controller: $value');
      })
    });
    streamSubscription ??= stream.listen((value) {
      getChatsFromDB().then((value) {
        if (mounted) {
          setState(() {
            allChats = value;
          });
        }
      });
      getLastMsgsFromDB().then((result) {
        List<Map> list = [];
        List<Map> finalList = [];
        List<Map> chats = [];
        result.forEach((k, v) => list.add(v));
        list.sort((a, b) => a['id'].compareTo(b['id']));
        finalList = list.reversed.toList();
        finalList.forEach((element) {
          Map msg = allChats.firstWhere((elm) => elm['id']==element['id_chat']);
          chats.add(msg);
        });
        allChats = chats;
        if (mounted) {
          setState(() {
            LastMsgs = result;
          });
        }
      });
      print('Value from controller: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
          itemBuilder: (context, index) {
            if (index == allChats.length - 1)
              return Column(
                children: [
                  buildMsgItem(context, allChats[index], LastMsgs["${allChats[index]['id']}"]),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              );
            return buildMsgItem(context, allChats[index], LastMsgs["${allChats[index]['id']}"]);
          },
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
          itemCount: allChats.length,
        );
  }

  Future<List<Map>> getChatsFromDB() async{
    if (database == null)
      await createDatabase();
    List<Map> chatgpt = await database.rawQuery('SELECT * FROM chats WHERE username="${connectedUser.username}" AND dest="chatGPT"');
    if(chatgpt.isEmpty) {
      await database.transaction((txn) async{
        txn.rawInsert(
            'INSERT INTO chats(username, dest) VALUES("${connectedUser.username}", "chatGPT")'
        );
      });
    }
    var response = await database.rawQuery('SELECT * FROM chats WHERE username="${connectedUser.username}"');
    return response;
  }

  Future<Map<String,Map>> getLastMsgsFromDB() async{
    if (database == null)
      await createDatabase();
    Map<String,Map> lastMsgs = {};
    List<Map> chatsID = await database.rawQuery('SELECT id FROM chats WHERE username="${connectedUser.username}"');
    for (var element in chatsID) {
      List<Map> chats = await database.rawQuery('SELECT * FROM messages WHERE id_chat=${element['id']} AND id=(SELECT max(id) FROM messages WHERE id_chat=${element['id']})');
      lastMsgs["${chats[0]['id_chat']}"] = chats[0];
    }
    return lastMsgs;
  }
}
