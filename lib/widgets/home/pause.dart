import 'package:flutter/material.dart';
import '../../colors.dart';

class PauseWidget extends StatelessWidget {
  final width;
  final height;
  PauseWidget(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.toDouble(),
        height: height.toDouble(),
        child: Row(children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: dark,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          spreadRadius: 1),
                    ],
                  ),
                  child: Center(
                      child: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 37,
                  ))))
        ]));
  }
}
