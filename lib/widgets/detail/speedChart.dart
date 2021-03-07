import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../colors.dart';
import 'package:geolocator/geolocator.dart';

class SpeedChartWidget extends StatefulWidget {
  List trackPointList;

  SpeedChartWidget({Key key, this.trackPointList}) : super(key: key);
  @override
  SpeedChartWidgetState createState() => SpeedChartWidgetState();
}

class SpeedChartWidgetState extends State<SpeedChartWidget> {
  List<Color> gradientColors = [blue, green];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
          Radius.circular(18),
        )),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'speed/distance',
                style: TextStyle(color: Colors.white, fontSize: 9),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Row(children: [
                Expanded(
                    child: Container(
                        child: LineChart(
                  mainData(),
                )))
              ]))
            ]));
  }

  LineChartData mainData() {
    var speedMaxVar = 0.0;
    var speedMinVar = 0.0;
    List data = [];
    List<FlSpot> flData = [];
    var prevPoint;
    var distance = 0.0;
    for (var point in widget.trackPointList) {
      var pointSpeed = point.speed;
      var pointDistance = 0.0;
      if (pointSpeed > speedMaxVar) {
        speedMaxVar = pointSpeed;
      }
      if (speedMinVar == 0) {
        speedMinVar = pointSpeed;
      }
      if (pointSpeed < speedMinVar) {
        speedMinVar = pointSpeed;
      }
      if (prevPoint == null) {
        prevPoint = point;
      } else {
        distance += Geolocator.distanceBetween(
            prevPoint.lat, prevPoint.lng, point.lat, point.lng);
      }
      pointDistance = distance.toInt() / 1000;
      data.add([pointDistance, pointSpeed]);
      flData.add(FlSpot(pointDistance, pointSpeed));
    }
    var speedMax = speedMaxVar;
    var speedMin = speedMinVar;
    var distanceFirst = distance / 1000 * 0.2;
    var distanceSecond = distance / 1000 * 0.4;
    var distanceThird = distance / 1000 * 0.6;
    var distanceForth = distance / 1000 * 0.8;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 9),
          getTitles: (value) {
            if (value.toInt() == distanceFirst.toInt()) {
              return '${distanceFirst.toInt()} km';
            } else if (value.toInt() == distanceSecond.toInt()) {
              return '${distanceSecond.toInt()} km';
            } else if (value.toInt() == distanceThird.toInt()) {
              return '${distanceThird.toInt()} km';
            } else if (value.toInt() == distanceForth.toInt()) {
              return '${distanceForth.toInt()} km';
            } else {
              return '';
            }
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
          getTitles: (value) {
            if (value.toInt() == speedMax.toInt()) {
              return '${speedMax.toInt()} m';
            } else if (value.toInt() == speedMin.toInt()) {
              return '${speedMin.toInt()} m';
            } else {
              return '';
            }
          },
          reservedSize: 35,
          margin: 5,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: distance.toInt() / 1000,
      minY: speedMin.toDouble() - 10.0,
      maxY: speedMax.toDouble() + 10.0,
      lineBarsData: [
        LineChartBarData(
          spots: flData,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
