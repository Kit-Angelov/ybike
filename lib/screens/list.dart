import 'package:flutter/material.dart';

import '../widgets/list/ridesCount.dart';
import '../widgets/list/distance.dart';
import '../widgets/list/avgSpeed.dart';
import '../widgets/list/maxSpeed.dart';
import '../widgets/list/duration.dart';
import '../widgets/list/maxAltitude.dart';
import '../widgets/list/elevationGain.dart';
import '../database.dart';
import '../rideModel.dart';

import '../screens/detail.dart';

import '../colors.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ScrollController _controller = new ScrollController();

  var items = [];
  bool load = false;

  getRideDataFromDB() async {
    var allRides = await DBProvider.db.getAllRides();
    setState(() {
      items = allRides;
      load = true;
    });
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getRideDataFromDB();
    return Scaffold(
        backgroundColor: backgroundDark,
        body: load == false
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.transparent,
              ))
            : items.length == 0
                ? Center(
                    child: Text(
                    'Ride list empty',
                    style: TextStyle(color: Colors.white),
                  ))
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 50),
                    physics: AlwaysScrollableScrollPhysics(),
                    primary: false,
                    controller: _controller,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var date = DateTime.fromMillisecondsSinceEpoch(
                          items[index].date);
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(ride: items[index])));
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(14, 14, 20, 14),
                                height: 75,
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
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${date.day}/${date.month}/${date.year}',
                                          style: TextStyle(
                                              fontSize: 9, color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${date.hour}:${date.minute < 10 ? 0 : ''}${date.minute}',
                                          style: TextStyle(
                                              fontSize: 9, color: Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Row(children: [
                                          Icon(
                                            Icons.timeline,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${(items[index].distance / 1000).toStringAsFixed(1)} km',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          )
                                        ]),
                                        Expanded(child: SizedBox()),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${items[index].duration ~/ 3600}h ${(items[index].duration % 3600) ~/ 60}m',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              )
                                            ]),
                                        Expanded(child: SizedBox()),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.trending_up,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${items[index].elevation.toInt()} m',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              )
                                            ]),
                                      ],
                                    )
                                  ],
                                ),
                              )));
                    }));
  }
}
