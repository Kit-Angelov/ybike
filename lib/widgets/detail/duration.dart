import 'package:flutter/material.dart';
import '../../colors.dart';

class DurationWidget extends StatelessWidget {
  final data;
  final width;
  final height;
  DurationWidget(this.data, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width.toDouble(),
      // height: height.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: dark,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [violet, purple]),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
              spreadRadius: 1),
        ],
      ),
      child: Stack(children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.access_time,
                size: 37,
                color: Colors.white,
              ),
              Expanded(
                  child: FittedBox(
                      child: RichText(
                text: TextSpan(
                    text: (data ~/ 3600).toString(),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    children: [
                      TextSpan(text: ' h ', style: TextStyle(fontSize: 9)),
                      TextSpan(text: (data % 3600 ~/ 60).toString()),
                      TextSpan(text: ' m', style: TextStyle(fontSize: 9))
                    ]),
              ))),
            ]))),
        Positioned(
          bottom: 7,
          right: 12,
          child: Text(
            'duration',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ]),
    );
  }
}
