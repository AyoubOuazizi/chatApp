import 'dart:convert';
import 'package:chat_app/shared/components/constants.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';

class Api {
  static const String apiUrl = "https://fcm.googleapis.com/fcm/send";

  static sendNotificationRequestToFriendToAcceptCall(String roomId, User user) async {
    var data = {
      "uuid": user.uuid,
      "caller_id": connectedUser.username,
      "caller_name": connectedUser.username,
      "caller_id_type": "number",
      "has_video": "false",
      "room_id": roomId,
      "fcm_token": user.token
    };
    print({"to": user.token, "data":data});
    var r = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA8Lr83G8:APA91bFBJdKiEpmnejm34ZSahXmnvgdPWfH4kYm8EzdFp4viTZxN2i-nwEI_Q-RKq2IfqY3wz60pFGxEYfVrNHljid2LM-52LJiF743NEbxfaLzrDm4n9bzl107SvU4FNwZ5UKlQWcyQ',
        },
        body: json.encode({
          "to": user.token,
          "data":data,
          'priority': 'high'
        }));
    print("***********************************");
    print(r.body);
  }
}