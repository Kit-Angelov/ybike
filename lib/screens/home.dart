import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wakelock/wakelock.dart';

import '../widgets/home/map.dart';
import '../widgets/home/speed.dart';
import '../widgets/home/currentTime.dart';
import '../widgets/home/startRide.dart';
import '../widgets/home/rideList.dart';
import '../widgets/home/altitude.dart';
import '../widgets/home/avgSpeed.dart';
import '../widgets/home/maxSpeed.dart';
import '../widgets/home/duration.dart';
import '../widgets/home/elevation.dart';
import '../widgets/home/distance.dart';
import '../widgets/home/stop.dart';
import '../widgets/home/pause.dart';
import '../widgets/home/play.dart';
import '../database.dart';
import '../rideModel.dart';

import 'package:location/location.dart' as l;
import 'package:geolocator/geolocator.dart';

import '../colors.dart';

import '../screens/list.dart';

import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = null;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<MapWidgetState> mapWidgetState = GlobalKey<MapWidgetState>();

  InterstitialAd _interstitialAd;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
  );

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {},
    );
  }

  void initAd() async {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-5070541116762629~7708625515');
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
    _interstitialAd?.show();
  }

  Position lastPosition;

  Widget mapWidget = SizedBox();

  bool rideStarted = false;
  bool ridePaused = false;

  // location data
  var location = new l.Location();
  var speed = 0;
  var altitude = 0;
  var positionStream;

  // time data
  var currentTime;
  var currentTimer;

  var geoTimer;

  // ride data
  var rideDate = 0;
  var rideDistance = 0;
  var rideElevationGain = 0;
  var rideDuration = 0;
  var rideDurationTimer;
  var rideAvgSpeed = 0;
  var rideMaxSpeed = 0;
  var trackPoints = [];
  var rideMaxAltitude = 0;
  var rideMinAltitude = 0;

  getLocationPermission() async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == l.PermissionStatus.DENIED) {
      showAlertDialogLocationPermission(context);
    } else {
      initMapAndLocationGetting();
      initAd();
    }
  }

  requestLocationPermission() async {
    var permissionGranted = await location.requestPermission();
    if (permissionGranted == l.PermissionStatus.GRANTED) {
      initMapAndLocationGetting();
      initAd();
    }
  }

  initMapAndLocationGetting() {
    setState(() {
      mapWidget = MapWidget(
        key: mapWidgetState,
      );
      runGeolocatorGetter();
    });
  }

  runGeolocatorGetter() {
    geoTimer = Stream.periodic(Duration(seconds: 1), (i) async {
      var position = await Geolocator.getLastKnownPosition();
      setState(() {
        var currentSpeed =
            position == null ? 0 : ((position.speed.toInt() * 18) ~/ 5);
        if (rideStarted && ridePaused == false && position != null) {
          updateRideData(position, currentSpeed);
        }
        speed = currentSpeed;
        altitude = position.altitude.toInt();
      });
    });
    geoTimer.listen((_) {});
  }

  currentTimeStreamInit() {
    currentTime = DateTime.now();
    currentTimer = Stream.periodic(Duration(seconds: 1), (i) {
      setState(() {
        currentTime = currentTime.add(Duration(seconds: 1));
      });
      return currentTime;
    });
    currentTimer.listen((_) {});
  }

  startRide() {
    clearRideData();
    setState(() {
      rideDate = DateTime.now().millisecondsSinceEpoch;
      rideStarted = true;
      startCalcRideDuration();
    });
  }

  pauseRide() {
    setState(() {
      ridePaused = true;
    });
  }

  playRide() {
    setState(() {
      ridePaused = false;
    });
  }

  stopRide() {
    showAlertDialogStopRide(context);
  }

  clearRideData() {
    setState(() {
      rideDate = 0;
      rideDistance = 0;
      rideElevationGain = 0;
      rideDuration = 0;
      rideDurationTimer?.cancel();
      rideAvgSpeed = 0;
      rideMaxSpeed = 0;
      trackPoints = [];
      mapWidgetState.currentState.removeTrack();
      rideMaxAltitude = 0;
      rideMinAltitude = 0;
    });
  }

  updateRideData(Position position, currentSpeed) {
    setState(() {
      if (lastPosition != null) {
        var distanceCurrent = Geolocator.distanceBetween(lastPosition.latitude,
            lastPosition.longitude, position.latitude, position.longitude);
        if (distanceCurrent < 1) {
          return;
        }
      }
      trackPoints.add([
        position.latitude,
        position.longitude,
        position.altitude,
        currentSpeed
      ]);
      mapWidgetState.currentState.drawTrack(trackPoints);
      calcDistance();
      calcElevation();
      calcAvgSpeed();
      calcMaxMinAltitude(position.altitude.toInt());
      calcMaxSpeed(currentSpeed);
      lastPosition = position;
    });
  }

  startCalcRideDuration() {
    rideDuration = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        rideDurationTimer = timer;
        if (ridePaused != true) {
          rideDuration += 1;
        }
      });
    });
  }

  calcDistance() {
    rideDistance = 0;
    if (trackPoints.length < 2) {
      return;
    }
    var distanceSum = 0.0;
    var prevPoint = trackPoints[0];
    for (var nextPoint in trackPoints) {
      if (prevPoint == nextPoint) {
        continue;
      }
      distanceSum += Geolocator.distanceBetween(
          prevPoint[0], prevPoint[1], nextPoint[0], nextPoint[1]);
      prevPoint = nextPoint;
    }
    rideDistance = distanceSum.toInt();
  }

  calcElevation() {
    rideElevationGain = 0;
    if (trackPoints.length < 2) {
      return;
    }
    var elevationGainSum = 0.0;
    var prevPoint = trackPoints[0];
    for (var nextPoint in trackPoints) {
      if (prevPoint == nextPoint) {
        continue;
      }
      var delta = nextPoint[2] - prevPoint[2];
      if (delta > 0) {
        elevationGainSum += delta;
      }
      prevPoint = nextPoint;
    }
    rideElevationGain = elevationGainSum.toInt();
  }

  calcAvgSpeed() {
    setState(() {
      if (rideDuration > 0 && trackPoints.length > 1) {
        var pointCount = 0;
        var speedSum = 0;
        for (var point in trackPoints) {
          pointCount += 1;
          speedSum += point[3];
        }
        rideAvgSpeed = speedSum ~/ pointCount;
      }
    });
  }

  calcMaxSpeed(currentSpeed) {
    setState(() {
      if (currentSpeed > rideMaxSpeed) {
        rideMaxSpeed = currentSpeed;
      }
    });
  }

  calcMaxMinAltitude(newAltitude) {
    setState(() {
      if (newAltitude > rideMaxAltitude) {
        rideMaxAltitude = newAltitude;
      }
      if (rideMinAltitude == 0.0) {
        rideMinAltitude = newAltitude;
      }
      if (newAltitude < rideMinAltitude) {
        rideMinAltitude = newAltitude;
      }
    });
  }

  saveRideDataToDB() async {
    var newRide = Ride(
        distance: rideDistance,
        date: rideDate,
        duration: rideDuration,
        maxaltitude: rideMaxAltitude,
        minaltitude: rideMinAltitude,
        avgspeed: rideAvgSpeed,
        maxspeed: rideMaxSpeed,
        elevation: rideElevationGain);
    var raw = await DBProvider.db.newRide(newRide, trackPoints);
  }

  @override
  void dispose() {
    Wakelock.disable();
    geoTimer?.cancel();
    currentTimer?.cancel();
    rideDurationTimer?.cance();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Wakelock.enable();
    setState(() {
      getLocationPermission();
      currentTimeStreamInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundDark,
        body: Stack(
          children: [
            mapWidget,
            Positioned(top: 40, left: 5, child: SpeedWidget(speed, 166, 80)),
            Positioned(
                top: 40,
                right: 5,
                child: CurrentTimeWidget(currentTime, 124, 80)),
            rideStarted == false
                ? Positioned(
                    bottom: 30,
                    left: 5,
                    child: GestureDetector(
                        onTap: () {
                          startRide();
                        },
                        child: StartRideWidget(145, 50)))
                : SizedBox(),
            rideStarted == true
                ? Positioned(
                    bottom: 30,
                    left: 5,
                    child: GestureDetector(
                        onTap: () {
                          stopRide();
                        },
                        child: StopWidget(67, 50)))
                : SizedBox(),
            (rideStarted == true && ridePaused == false)
                ? Positioned(
                    bottom: 30,
                    left: 82,
                    child: GestureDetector(
                        onTap: () {
                          pauseRide();
                        },
                        child: PauseWidget(67, 50)))
                : SizedBox(),
            (rideStarted == true && ridePaused == true)
                ? Positioned(
                    bottom: 30,
                    left: 82,
                    child: GestureDetector(
                        onTap: () {
                          playRide();
                        },
                        child: PlayWidget(67, 50)))
                : SizedBox(),
            rideStarted == false
                ? Positioned(
                    bottom: 30,
                    right: 5,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListPage()));
                        },
                        child: RideListWidget(50, 50)))
                : SizedBox(),
            Positioned(
                bottom: 100, right: 5, child: AltitudeWidget(altitude, 80, 55)),
            rideStarted == true
                ? Positioned(
                    bottom: 165,
                    right: 5,
                    child: ElevationWidget(rideElevationGain, 80, 55))
                : SizedBox(),
            rideStarted == true
                ? Positioned(
                    top: 130,
                    left: 5,
                    child: AvgSpeedWidget(rideAvgSpeed, 80, 55))
                : SizedBox(),
            rideStarted == true
                ? Positioned(
                    top: 130,
                    left: 91,
                    child: MaxSpeedWidget(rideMaxSpeed, 80, 55))
                : SizedBox(),
            rideStarted == true
                ? Positioned(
                    top: 130,
                    right: 5,
                    child: DurationWidget(rideDuration, 124, 55))
                : SizedBox(),
            rideStarted == true
                ? Positioned(
                    bottom: 30,
                    right: 5,
                    child: DistanceWidget(rideDistance, 124, 60))
                : SizedBox(),
          ],
        ));
  }

  showAlertDialogStopRide(BuildContext context) {
    Widget ok = FlatButton(
      child: Text('ok'),
      onPressed: () {
        Navigator.pop(context);
        saveRideDataToDB();
        clearRideData();
        setState(() {
          rideStarted = false;
        });
      },
    );
    Widget cancel = FlatButton(
      child: Text('cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Сomplete the ride'),
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

  showAlertDialogLocationPermission(BuildContext context) {
    Widget ok = FlatButton(
      child: Text('ok'),
      onPressed: () {
        Navigator.pop(context);
        requestLocationPermission();
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Please allow to receive location data'),
      content: Text('This is required for the application to work'),
      actions: [ok],
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
