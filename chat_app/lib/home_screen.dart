// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // leading: Icon(
//         //   Icons.menu
//         // ),
//         title: Text(
//             "ChatApp",
//         ),
//         actions: [
//           IconButton(
//               icon: Icon(
//                       Icons.camera_alt_outlined,
//                     ),
//               onPressed: (){
//                 print("clicked");
//               }
//           ),
//           IconButton(
//               onPressed: (){
//                 print("clicked");
//               },
//               icon: Icon(
//                       Icons.search,
//                     )
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.more_vert,
//             ),
//             onPressed: () {
//               print("click");
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Text(
//               "text 1",
//               style: TextStyle(
//                 backgroundColor: Colors.yellow,
//                 fontSize: 70,
//               ),
//           ),
//           Container(
//             color: Colors.red,
//             child: Text(
//                 "text 2"
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//                 "text 3"
//             ),
//           ),
//           Text(
//               "text 4"
//           ),
//         ],
//       ),
//     );
//   }
//
// }