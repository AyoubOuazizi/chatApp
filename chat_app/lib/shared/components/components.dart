import 'package:flutter/material.dart';

import '../../modules/chat/chat_screen.dart';

Widget buildMsgItem(context) => InkWell(
  onTap: (){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(),
      ),
    );
  },
  child:   Ink(
    child:   Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
              ),
              CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.white,
              ),
              CircleAvatar(
                radius: 7.0,
                backgroundColor: Colors.green,
              ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'OUAZIZI Ayoub',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '15:00',
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.done_all,
                      color: Colors.blue,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      'hhhhhhh exam rda',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);


Widget buildNewFriendItem() => Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 10.0,
  ),
  child: Row(
    children: [
      Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
          ),
        ],
      ),
      SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'OUAZIZI Ayoub',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);

Widget buildCallItem() => Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 10.0,
  ),
  child: Row(
    children: [
      CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
      ),
      SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OUAZIZI Ayoub',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.call_received,
                  color: Colors.green,
                  size: 15.0,
                ),
                SizedBox(
                  width: 3.0,
                ),
                Text(
                  '31/12/2022 à 21:11',
                ),
              ],
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: (){},
        icon: Icon(
          Icons.call,
          color: Colors.green,
        ),
      ),
    ],
  ),
);

Widget ownMessageCard({
  required context,
  required message,
  required time,
}) => Align(
  alignment: Alignment.centerRight,
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width - 45,
    ),
    child: Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.blue[200],
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 30,
              top: 5,
              bottom: 20,
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 10,
            child: Row(
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.done_all,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

Widget replyCard({
  required context,
  required message,
  required time,
}) => Align(
  alignment: Alignment.centerLeft,
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width - 45,
    ),
    child: Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // color: Color(0xffdcf8c6),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 50,
              top: 5,
              bottom: 10,
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 10,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);