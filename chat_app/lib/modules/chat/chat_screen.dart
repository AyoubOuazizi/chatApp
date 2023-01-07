import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class ChatScreen extends StatelessWidget {
  var msgController = TextEditingController();

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
                      "OUAZIZI AYOUB",
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
              IconButton(icon: Icon(Icons.call), onPressed: () {}),
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
                    itemCount: 25,
                    itemBuilder: (context, index) {
                      if ((25 - 1 - index)%2 == 0) {
                        if (25 - 1 - index == 0)
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: ownMessageCard(
                              context: context,
                              message: "hhhh exam rda ${25 - 1 - index}",
                              time: "19:00",
                            ),
                          );
                        return ownMessageCard(
                          context: context,
                          message: "hhhh exam rda ${25 - 1 - index}",
                          time: "19:00",
                        );
                      } else {
                        if (25 - 1 - index == 0)
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: replyCard(
                              context: context,
                              message: "de3na hhhhhhhhhhhhhhhh",
                              time: "00:00",
                            ),
                          );
                        return replyCard(
                          context: context,
                          message: "de3na hhhhhhhhhhhhhhhh",
                          time: "00:00",
                        );
                      }
                    },
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
                                onChanged: (value) {},
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
                                onPressed: () {},
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
}