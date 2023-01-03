import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class CallScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => buildCallItem(),
      separatorBuilder: (context, index) => Padding(
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
      itemCount: 15,
    );
  }
}
