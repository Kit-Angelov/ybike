import 'package:flutter/material.dart';
import '../../colors.dart';

class ScreenSettingsWidget extends StatelessWidget {
  final width;
  final height;
  ScreenSettingsWidget(this.width, this.height);

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
      child: Center(
          child: Icon(
        Icons.settings,
        color: Colors.white,
        size: 25,
      )),
    );
  }
}
