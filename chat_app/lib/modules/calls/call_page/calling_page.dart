import 'dart:convert';
import 'dart:ui';

import 'package:chat_app/modules/calls/call_page/signaling.dart';
import 'package:chat_app/modules/calls/call_page/webrtc_logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

import '../../../helper/countup.dart';
import '../../../models/user.dart';
import '../../../shared/api/api.dart';
import '../../../shared/components/constants.dart';

enum CallStatus { calling, accepted, ringing }

class CallAcceptDeclinePage extends StatefulWidget {
  final User user;
  final CallStatus? callStatus;
  final String? roomId;

  const CallAcceptDeclinePage(
      {Key? key, required this.user, this.callStatus, this.roomId})
      : super(key: key);

  @override
  _CallAcceptDeclinePageState createState() => _CallAcceptDeclinePageState();
}

class _CallAcceptDeclinePageState extends State<CallAcceptDeclinePage> {
  late CallStatus callStatus;
  List<IconData> bottomSheetIcons = [
    LineIcons.speakerDeck,
    LineIcons.bluetooth,
    LineIcons.videoAlt,
    LineIcons.microphoneSlash,
    LineIcons.phoneSlash
  ];
  // WebRTCLogic webrtcLogic = WebRTCLogic();
  // final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  // final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  // String? roomId;
  //
  // initializeWebRTC() async {
  //     await _localRenderer.initialize();
  //     await _remoteRenderer.initialize();
  //
  //     webrtcLogic.onAddRemoteStream = ((stream) {
  //       _remoteRenderer.srcObject = stream;
  //       setState(() {});
  //     });
  //
  //     webrtcLogic.openUserMedia(_localRenderer, _remoteRenderer);
  //     if (callStatus == CallStatus.calling) {
  //       roomId = await webrtcLogic.createRoom(_remoteRenderer);
  //       print("roomID: $roomId");
  //       Api.sendNotificationRequestToFriendToAcceptCall(roomId!, widget.user);
  //     } else {
  //       roomId = widget.roomId;
  //       webrtcLogic.joinRoom(
  //         roomId!,
  //         _remoteRenderer,
  //       );
  //     }
  //
  //     if (kDebugMode) {
  //       print("connected successfully");
  //     }
  // }
  //
  // @override
  // void initState() {
  //   callStatus = widget.callStatus ?? CallStatus.calling;
  //   initializeWebRTC();
  //   super.initState();
  // }
  //
  // @override
  // void dispose() async{
  //   await _localRenderer.dispose();
  //   await _remoteRenderer.dispose();
  //   webrtcLogic.hangUp(_localRenderer);
  //   super.dispose();
  // }
  //
  Widget getBody() {
    // switch (callStatus) {
    //   case CallStatus.calling:
    //     return Center(
    //       child: Column(
    //         children: [
    //           const SizedBox(
    //             height: 100,
    //           ),
    //           Column(
    //             children: [
    //               Container(
    //                 width: 150,
    //                 height: 150,
    //                 decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     image: DecorationImage(
    //                         image: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
    //                         fit: BoxFit.cover)),
    //               ),
    //               const SizedBox(
    //                 height: 16,
    //               ),
    //               Text(
    //                 widget.user.username,
    //                 style: const TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 26,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //               const SizedBox(
    //                 height: 8,
    //               ),
    //               const Text(
    //                 "Calling...",
    //                 style: TextStyle(
    //                     color: Colors.white,
    //                     shadows: [
    //                       BoxShadow(color: Colors.black, blurRadius: 3)
    //                     ],
    //                     fontSize: 16),
    //               )
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   case CallStatus.accepted:
    //     return Center(
    //       child: Column(
    //         children: [
    //           const SizedBox(
    //             height: 100,
    //           ),
    //           Column(
    //             children: [
    //               Container(
    //                 width: 150,
    //                 height: 150,
    //                 decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     image: DecorationImage(
    //                         image: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
    //                         fit: BoxFit.cover)),
    //               ),
    //               const SizedBox(
    //                 height: 16,
    //               ),
    //               Text(
    //                 widget.user.username,
    //                 style: const TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 26,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //               const SizedBox(
    //                 height: 8,
    //               ),
    //               Countup(
    //                 style: const TextStyle(
    //                     color: Colors.white,
    //                     shadows: [
    //                       BoxShadow(color: Colors.black, blurRadius: 3)
    //                     ],
    //                     fontSize: 16),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   case CallStatus.ringing:
    //     return Column(
    //       children: [
    //         const Spacer(),
    //         Column(
    //           children: [
    //             Container(
    //               width: 150,
    //               height: 150,
    //               decoration: BoxDecoration(
    //                   shape: BoxShape.circle,
    //                   image: DecorationImage(
    //                       image: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
    //                       fit: BoxFit.cover)),
    //             ),
    //             const SizedBox(
    //               height: 16,
    //             ),
    //             Text(
    //               widget.user.username,
    //               style: const TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 26,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             const Text(
    //               "Calling...",
    //               style: TextStyle(
    //                   color: Colors.white,
    //                   shadows: [BoxShadow(color: Colors.black, blurRadius: 3)],
    //                   fontSize: 16),
    //             )
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 60,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             Column(
    //               children: [
    //                 Container(
    //                   width: 70,
    //                   height: 70,
    //                   decoration: BoxDecoration(
    //                       color: Colors.lightGreen,
    //                       shape: BoxShape.circle),
    //                   child: const Icon(LineIcons.phone, color: Colors.white),
    //                 ),
    //                 const SizedBox(
    //                   height: 8,
    //                 ),
    //                 const Text(
    //                   "Accept",
    //                   style: TextStyle(color: Colors.white),
    //                 )
    //               ],
    //             ),
    //             Column(
    //               children: [
    //                 Container(
    //                   width: 70,
    //                   height: 70,
    //                   decoration: const BoxDecoration(
    //                       color: Colors.redAccent, shape: BoxShape.circle),
    //                   child:
    //                   const Icon(LineIcons.phoneSlash, color: Colors.white),
    //                 ),
    //                 const SizedBox(
    //                   height: 8,
    //                 ),
    //                 const Text(
    //                   "Decline",
    //                   style: TextStyle(color: Colors.white),
    //                 )
    //               ],
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 60,
    //         ),
    //         const Text(
    //           "Decline & Send Message",
    //           style: TextStyle(color: Colors.white60, fontSize: 14),
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         ClipRect(
    //           child: BackdropFilter(
    //             filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
    //             child: Container(
    //               width: MediaQuery.of(context).size.width * 0.75,
    //               decoration: BoxDecoration(
    //                   color: Colors.grey.shade200.withOpacity(0.2),
    //                   borderRadius:
    //                   const BorderRadius.all(Radius.circular(20))),
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     vertical: 8.0, horizontal: 20),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: const [
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                     Text(
    //                       "I'll call you back",
    //                       style: TextStyle(color: Colors.white54),
    //                     ),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                     Text(
    //                       "Sorry, I can't talk right now",
    //                       style: TextStyle(color: Colors.white54),
    //                     ),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 80,
    //         ),
    //       ],
    //     );
    // }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 8),
      // ElevatedButton(
      //               onPressed: () {
      //                 // Add roomId
      //                 signaling.joinRoom(
      //                   roomId!,
      //                   _remoteRenderer,
      //                 );
      //               },
      //               child: Text("Join room"),
      //             ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
              Expanded(child: RTCVideoView(_remoteRenderer)),
            ],
          ),
        ),
      )
    ],
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                    fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          getBody(),
          SlidingUpPanel(
            panel: Container(
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    bottomSheetIcons.length,
                        (index) => IconButton(
                          color: index == 0 ? Colors.redAccent : Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(bottomSheetIcons[index]),
                        )),
              ),
            ),
            minHeight: 90,
            maxHeight: 200,
            collapsed: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    bottomSheetIcons.length,
                        (index) => IconButton(
                      color: index == 0 ? Colors.redAccent : Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(bottomSheetIcons[index]),
                    )),
              ),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          )
        ],
      ),
    );
  }

  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  void initState() {
    callStatus = widget.callStatus ?? CallStatus.calling;

    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    openMedia();

    if (callStatus == CallStatus.calling) {
      newRoom();
      // roomId = await webrtcLogic.createRoom(_remoteRenderer);
      // print("roomID: $roomId");
    } else {
      roomId = widget.roomId;
      print("**************************************");
      print(roomId);
      print("**************************************");
      join();
      // webrtcLogic.joinRoom(
      //   roomId!,
      //   _remoteRenderer,
      // );
    }
    super.initState();
  }

  void openMedia() async {
    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
    setState(() {});
  }

  join() async {
    await signaling.joinRoom(
      roomId!,
      _remoteRenderer,
    );
    setState(() {});
  }

  newRoom() async {
    roomId = await signaling.createRoom(_remoteRenderer);
    setState(() {});
    // textEditingController.text = roomId!;
    print("**************************************");
    print(roomId);
    print("**************************************");
    Api.sendNotificationRequestToFriendToAcceptCall(roomId!, widget.user);
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    signaling.hangUp(_localRenderer);
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Welcome to Flutter Explained - WebRTC"),
  //     ),
  //     body: Column(
  //       children: [
  //         SizedBox(height: 8),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ElevatedButton(
  //               onPressed: () {
  //                 signaling.openUserMedia(_localRenderer, _remoteRenderer);
  //               },
  //               child: Text("Open camera & microphone"),
  //             ),
  //             SizedBox(
  //               width: 8,
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 roomId = await signaling.createRoom(_remoteRenderer);
  //                 textEditingController.text = roomId!;
  //                 setState(() {});
  //               },
  //               child: Text("Create room"),
  //             ),
  //             SizedBox(
  //               width: 8,
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // Add roomId
  //                 signaling.joinRoom(
  //                   textEditingController.text,
  //                   _remoteRenderer,
  //                 );
  //               },
  //               child: Text("Join room"),
  //             ),
  //             SizedBox(
  //               width: 8,
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 signaling.hangUp(_localRenderer);
  //               },
  //               child: Text("Hangup"),
  //             )
  //           ],
  //         ),
  //         SizedBox(height: 8),
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
  //                 Expanded(child: RTCVideoView(_remoteRenderer)),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text("Join the following Room: "),
  //               Flexible(
  //                 child: TextFormField(
  //                   controller: textEditingController,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 8)
  //       ],
  //     ),
  //   );
  // }



}
