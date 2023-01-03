import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class MsgScreen extends StatelessWidget {
  int itemCount = 15;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == itemCount -1)
          return Column(
            children: [
              buildMsgItem(),
              SizedBox(
                height: 50.0,
              ),
            ],
          );
        return buildMsgItem();
      },
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
      itemCount: itemCount,
    );
  }
}
