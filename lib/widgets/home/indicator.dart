import 'package:flutter/material.dart';
import '../../colors.dart';

class IndicatorWidget extends StatelessWidget {
  final data;
  final width;
  final height;
  IndicatorWidget(this.data, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: dark,
        boxShadow: [
          BoxShadow(
              color: Colors.black38,
              offset: Offset(1, 1),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: Stack(children: [
        Positioned(
          top: 5,
          left: 10,
          child: Text(
            'speed',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
        Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '157',
            style: TextStyle(color: Colors.white, fontSize: 48),
          ),
          Text(
            'km/h',
            style: TextStyle(color: Colors.white),
          )
        ]))
      ]),
    );
  }
}
