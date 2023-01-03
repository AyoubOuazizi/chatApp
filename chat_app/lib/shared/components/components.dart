import 'package:flutter/material.dart';

Widget buildMsgItem() => Padding(
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
                  '15:00'
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
);
