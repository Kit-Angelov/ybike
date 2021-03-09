import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/detail/distance.dart';
import '../widgets/detail/avgSpeed.dart';
import '../widgets/detail/maxSpeed.dart';
import '../widgets/detail/duration.dart';
import '../widgets/detail/maxAltitude.dart';
import '../widgets/detail/minAltitude.dart';
import '../widgets/detail/elevationGain.dart';

import '../widgets/detail/heightChart.dart';
import '../widgets/detail/speedChart.dart';
import '../widgets/detail/map.dart';
import '../widgets/detail/minimap.dart';
import '../database.dart';
import '../rideModel.dart';
import '../colors.dart';

import '../widgets/detail/minimap.dart';

class DetailPage extends StatefulWidget {
  Ride ride;

  DetailPage({Key key, this.ride}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ScrollController _controller = new ScrollController();

  var trackPoints = [];

  getTrackPoints() async {
    var allTrackPoints = await DBProvider.db.getTrackPoints(widget.ride.id);
    setState(() {
      trackPoints = allTrackPoints;
    });
  }

  @override
  void initState() {
    setState(() {
      getTrackPoints();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(widget.ride.date);
    return Scaffold(
      backgroundColor: backgroundDark,
      body: ListView(
        padding: EdgeInsets.fromLTRB(7, 30, 7, 50),
        physics: AlwaysScrollableScrollPhysics(),
        primary: false,
        controller: _controller,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            height: 370,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${date.hour}:${date.minute < 10 ? 0 : ''}${date.minute}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                        onTap: () async {
                          showAlertDialogDeleteRide(context);
                        },
                        child: Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
                            Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ]))
                          ]),
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Row(children: [
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                            child:
                                DistanceWidget(widget.ride.distance, 154, 75))),
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                            child:
                                DurationWidget(widget.ride.duration, 154, 75))),
                  ]),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Row(children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                          child: MaxAltitudeWidget(
                              widget.ride.maxaltitude, 154, 75)),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                          child: MinAltitudeWidget(
                              widget.ride.minaltitude, 154, 75)),
                    ),
                  ]),
                ),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                              child:
                                  AvgSpeedWidget(widget.ride.avgspeed, 72, 75)),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                              child:
                                  MaxSpeedWidget(widget.ride.maxspeed, 72, 75)),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                              child: ElevationGainWidget(
                                  widget.ride.elevation, 154, 75)),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          trackPoints.length > 0
              ? Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
                    ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: MiniMapWidget(
                          trackPointList: trackPoints,
                        )),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapWidget(
                                        trackPointList: trackPoints,
                                      )));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                                height: 220, color: Colors.transparent)))
                  ]))
              : SizedBox(),
          SizedBox(
            height: 20,
          ),
          trackPoints.length > 0
              ? Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: dark,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          spreadRadius: 1),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SpeedChartWidget(
                        trackPointList: trackPoints,
                      )))
              : SizedBox(),
          SizedBox(
            height: 20,
          ),
          trackPoints.length > 0
              ? Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: dark,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          spreadRadius: 1),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: HeightChartWidget(
                        trackPointList: trackPoints,
                      )))
              : SizedBox(),
        ],
      ),
    );
  }

  showAlertDialogDeleteRide(BuildContext context) {
    Widget ok = FlatButton(
      child: Text('ok'),
      onPressed: () async {
        await DBProvider.db.deleteRide(widget.ride.id);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    Widget cancel = FlatButton(
      child: Text('cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Delete ride?'),
      content: Text(''),
      actions: [ok, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
