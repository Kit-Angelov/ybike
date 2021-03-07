import 'package:flutter/material.dart';
import '../../colors.dart';

class DistanceWidget extends StatelessWidget {
  final data;
  final width;
  final height;
  DistanceWidget(this.data, this.width, this.height);

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
            colors: [blue, darkBlue]),
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
                Icons.timeline,
                size: 37,
                color: Colors.white,
              ),
              Expanded(
                  child: FittedBox(
                      child: RichText(
                text: TextSpan(
                    text: "443",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    children: [
                      TextSpan(text: ' km', style: TextStyle(fontSize: 9))
                    ]),
              )))
            ]))),
        Positioned(
          bottom: 7,
          right: 12,
          child: Text(
            'distance',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ]),
    );
  }
}
