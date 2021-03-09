import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../colors.dart';

import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  List trackPointList;
  MapWidget({Key key, this.trackPointList}) : super(key: key);
  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(51.852, 39.211),
    zoom: 13.0,
  );

  MapboxMapController mapController;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  Map<String, String> _styleStrings = {
    'Dark': MapboxStyles.DARK,
    'Light': MapboxStyles.LIGHT,
    'Outdoors': MapboxStyles.OUTDOORS,
    'Sattelite': MapboxStyles.SATELLITE,
  };
  String currentStyleItem = 'Dark';
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = false;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;

  Line trackLine;

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      accessToken:
          "pk.eyJ1Ijoia2l0YW5nZWxvdiIsImEiOiJjamd1aHZncTMxMjF6MndtcWdjZGZhY2g1In0.s4vQ4pbKkTCpKt6psOPxMw",
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      compassEnabled: true,
      compassViewPosition: CompassViewPosition.BottomLeft,
      compassViewMargins: Point(20, 350),
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      styleString: _styleStrings[currentStyleItem],
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      onMapClick: (point, latLng) async {},
      onMapLongClick: (point, latLng) async {},
    );
    return Stack(children: [
      mapboxMap,
      Positioned(
          top: MediaQuery.of(context).size.height / 2 - 60,
          left: 5,
          child: GestureDetector(
              onTap: () {
                mapController.animateCamera(CameraUpdate.zoomIn());
              },
              child: Container(
                width: 50,
                height: 50,
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
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                )),
              ))),
      Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: 5,
          child: GestureDetector(
              onTap: () {
                mapController.animateCamera(CameraUpdate.zoomOut());
              },
              child: Container(
                width: 50,
                height: 50,
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
                  Icons.remove,
                  color: Colors.white,
                  size: 25,
                )),
              ))),
      Positioned(
          top: MediaQuery.of(context).size.height / 2 + 80,
          left: 5,
          child: GestureDetector(
              onTap: _selectLayer,
              child: Container(
                width: 50,
                height: 50,
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
                  Icons.layers,
                  color: Colors.white,
                  size: 25,
                )),
              )))
    ]);
  }

  void onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    if (widget.trackPointList.length > 0) {
      drawTrack(widget.trackPointList);
    }
  }

  // move to my position

  void animateCameraPosition(LatLng position, {double zoom: 0}) {
    if (zoom != 0) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(position, zoom),
      );
    } else {
      mapController.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  void toMyLocation() async {
    Position position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      LatLng latlng = LatLng(position.latitude, position.longitude);
      animateCameraPosition(latlng);
    } else {
      Position position = await Geolocator.getCurrentPosition();
      LatLng latlng = LatLng(position.latitude, position.longitude);
      animateCameraPosition(latlng);
    }
  }

  void drawTrack(trackPoints) async {
    List<LatLng> geometry = [];
    for (var point in trackPoints) {
      geometry.add(LatLng(point.lat, point.lng));
    }
    Future.delayed(const Duration(seconds: 2), () async {
      trackLine = await mapController.addLine(LineOptions(
          geometry: geometry,
          lineColor: "#3bde9b",
          lineWidth: 4.0,
          lineOpacity: 0.9,
          draggable: false));
      var latLngList = await mapController.getLineLatLngs(trackLine);
      var bounds = boundsFromLatLngList(latLngList);
      mapController.moveCamera(CameraUpdate.newLatLngBounds(
        bounds,
      ));
    });
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1 + 0.0001, y1 + 0.0001),
        southwest: LatLng(x0 - 0.0001, y0 - 0.0001));
  }

  // select map layer

  void _selectLayer() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: _bottomSheetSelectLayer(),
            height: 240,
            decoration: BoxDecoration(
                color: backgroundDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                )),
          );
        });
  }

  Column _bottomSheetSelectLayer() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.check,
            color: currentStyleItem == 'Dark' ? green : dark,
          ),
          title: Text(
            'Dark',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            _setMapStyle('Dark');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check,
            color: currentStyleItem == 'Light' ? green : dark,
          ),
          title: Text(
            'Light',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            _setMapStyle('Light');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check,
            color: currentStyleItem == 'Outdoors' ? green : dark,
          ),
          title: Text(
            'Outdoors',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            _setMapStyle('Outdoors');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.check,
            color: currentStyleItem == 'Sattelite' ? green : dark,
          ),
          title: Text(
            'Sattelite',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            _setMapStyle('Sattelite');
          },
        ),
      ],
    );
  }

  _setMapStyle(styleName) {
    setState(() {
      currentStyleItem = styleName;
      Navigator.pop(context);
    });
  }
}
