import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

import '../../models/user.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../calls/call_page/calling_page.dart';



class ChatScreen extends StatefulWidget {
  final String username;
  int chatId;
  ChatScreen({super.key, required this.username, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState(username: username, chatId: chatId);
}

class _ChatScreenState extends State<ChatScreen> {
  late var msgController = TextEditingController(text: message);

  List<Map> msgs = [];

  String message = "";

  final String username;
  int chatId;

  StreamSubscription? streamSubscription;

  _ChatScreenState({required this.username, required this.chatId});

  @override
  void initState() {
    super.initState();
    getMsgsFromDB().then((value) {
      if (mounted) {
        setState(() {
          msgs = value;
        });
      }
    });
    Stream stream = Chatscontroller.stream;
    streamSubscription?.cancel().then((value) => {
      streamSubscription = stream.listen((value) {
        getMsgsFromDB().then((value) {
          if (mounted) {
            setState(() {
              msgs = value;
            });
          }
        });
        print('Value from controller: $value');
      })
    });
    streamSubscription ??= stream.listen((value) {
        getMsgsFromDB().then((value) {
          if (mounted) {
            setState(() {
              msgs = value;
            });
          }
        });
        print('Value from controller: $value');
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/chat-background.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              widget.username=="chatGPT"? Text("") : IconButton(icon: Icon(Icons.call), onPressed: () async {
                var response = await http.get(Uri.parse("${serverUrl}token/${widget.username}"));
                String token = "";
                if (response.statusCode == 200) {
                  token = response.body.toString();
                }
                var destination = User(email: "", password: "", username: widget.username, token: token);
                // if (await Permission.camera.request().isGranted &&
                //     await Permission.microphone.request().isGranted &&
                //     await Permission.speech.request().isGranted /*&&*/
                //     // await Permission.bluetooth.request().isGranted
                // ) {

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CallAcceptDeclinePage(user: destination),
                    ),
                  );
                // }
              }),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  // height: MediaQuery.of(context).size.height - 150,
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                                if (msgs[msgs.length - 1 - index]['received'] == 0) {
                                  if (msgs.length - 1 - index == 0)
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: ownMessageCard(
                                        context: context,
                                        message: msgs[msgs.length - 1 - index]['message'],
                                        time: msgs[msgs.length - 1 - index]['time'],
                                      ),
                                    );
                                  return ownMessageCard(
                                    context: context,
                                    message: msgs[msgs.length - 1 - index]['message'],
                                    time: msgs[msgs.length - 1 - index]['time'],
                                  );
                                } else {
                                  if (msgs.length - 1 - index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: replyCard(
                                        context: context,
                                        message: msgs[msgs.length - 1 - index]['message'],
                                        time: msgs[msgs.length - 1 - index]['time'],
                                      ),
                                    );
                                  }
                                  return replyCard(
                                    context: context,
                                    message: msgs[msgs.length - 1 - index]['message'],
                                    time: msgs[msgs.length - 1 - index]['time'],
                                  );
                                }
                          },
                    itemCount: msgs.length,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 70,
                            child: Card(
                              margin: EdgeInsets.only(
                                  left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextFormField(
                                controller: msgController,
                                //textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                onChanged: (value) {
                                  message = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                              right: 2,
                              left: 2,
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: sendMessage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  askChatGPT(String Question) async {
    // Request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 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',
    };

    // Request body
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': Question}
      ],
      'temperature': 0.7,
    });

    var response = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Process the response data
      print("*****************************");
      print(jsonResponse);
      print("*****************************");
      // return List<String>.from(jsonDecode(response.body));
    }
    // return [];
  }

  Future<List<Map>> getMsgsFromDB() async{
    if (database == null)
      await createDatabase();
    var messages = await database.rawQuery('SELECT * FROM messages m JOIN chats c ON m.id_chat=c.id WHERE c.username="${connectedUser.username}" AND c.dest="${widget.username}"');
    return messages;
  }

  Future<void> sendMessage() async {
    final dateNow = DateTime.now().toUtc();
    String formattedTime = DateFormat.Hm().format(dateNow.toLocal());
    if(message!="" && stompClient!=null) {
      var chatMessage = {
        "sender": connectedUser.username,
        "receiver": username,
        "message": message,
        "time": dateNow.toIso8601String()
      };
      if (widget.username != "chatGPT")
        await stompClient.send(destination: '/app/message/$username', body: jsonEncode(chatMessage));
      } else {
        askChatGPT(message);
      }
      if(chatId == -1) {
        var chat = await database.rawQuery('SELECT * FROM chats WHERE username="${connectedUser.username}" AND dest="$username"');
        chatId = chat[0]['id'];
      }
      database.transaction((txn) async{
        txn.rawInsert(
            'INSERT INTO messages(id_chat, message, time, received) VALUES($chatId, "$message", "$formattedTime", 0)'
        ).then((value) {
          print('$value inserted successfully');
          Chatscontroller.add(msgs);
          setState(() {
            message = "";
            msgController.clear();
          });
          getMsgsFromDB().then((value) {
            setState(() {
              msgs = value;
            });
          });
        }).catchError((error) {
          print('Error When Inserting New Record ${error.toString()}');
        });
        return null;
      });
    }
}