import 'package:flutter/material.dart';
import '../../colors.dart';

class AvgSpeedWidget extends StatelessWidget {
  final data;
  final width;
  final height;
  AvgSpeedWidget(this.data, this.width, this.height);

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
            'avg speed',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
        Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${((data.toInt() * 18) / 5).toInt()}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  'km/h',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ])
        ]))
      ]),
    );
  }
}
