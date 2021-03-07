import 'package:flutter/material.dart';
import '../../colors.dart';

class CurrentTimeWidget extends StatelessWidget {
  DateTime data;
  final width;
  final height;
  CurrentTimeWidget(this.data, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: dark,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [dark, gradientBlue]),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
              spreadRadius: 1),
        ],
      ),
      child: Stack(children: [
        Positioned(
          top: 7,
          left: 12,
          child: Text(
            'current time',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
        Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '${data.hour}:${data.minute < 10 ? 0 : ''}${data.minute}',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ])
        ]))
      ]),
    );
  }
}
