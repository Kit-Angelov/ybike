import 'package:flutter/material.dart';
import '../../colors.dart';

class MaxSpeedWidget extends StatelessWidget {
  final data;
  final width;
  final height;
  MaxSpeedWidget(this.data, this.width, this.height);

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
            colors: [green, blue]),
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
            padding: EdgeInsets.fromLTRB(8, 10, 8, 20),
            child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: FittedBox(
                      child: RichText(
                text: TextSpan(
                    text: data.toInt().toString(),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    children: [
                      TextSpan(text: ' km/h', style: TextStyle(fontSize: 9))
                    ]),
              )))
            ]))),
        Positioned(
          bottom: 7,
          right: 12,
          child: Text(
            'max speed',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ]),
    );
  }
}
