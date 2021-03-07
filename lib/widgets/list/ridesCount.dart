import 'package:flutter/material.dart';
import '../../colors.dart';

class RidesCountWidget extends StatelessWidget {
  final data;
  final width;
  final height;
  RidesCountWidget(this.data, this.width, this.height);

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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.directions_bike,
                size: 37,
                color: Colors.white,
              ),
              Expanded(
                  child: FittedBox(
                child: Text(
                  '3',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              )),
            ]))),
        Positioned(
          bottom: 7,
          right: 12,
          child: Text(
            'rides',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ]),
    );
  }
}
