import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../colors.dart';

import 'package:geolocator/geolocator.dart';
import '../../rideModel.dart';

class MiniMapWidget extends StatefulWidget {
  List trackPointList;
  MiniMapWidget({Key key, this.trackPointList}) : super(key: key);
  @override
  MiniMapWidgetState createState() => MiniMapWidgetState();
}

class MiniMapWidgetState extends State<MiniMapWidget> {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(51.5, 35.5),
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
  bool _rotateGesturesEnabled = false;
  bool _scrollGesturesEnabled = false;
  bool _tiltGesturesEnabled = false;
  bool _zoomGesturesEnabled = false;
  bool _myLocationEnabled = false;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;

  Line trackLine;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      accessToken:
          "pk.eyJ1Ijoia2l0YW5nZWxvdiIsImEiOiJjamd1aHZncTMxMjF6MndtcWdjZGZhY2g1In0.s4vQ4pbKkTCpKt6psOPxMw",
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
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
    ]);
  }

  void onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    if (widget.trackPointList.length > 0) {
      drawTrack(widget.trackPointList);
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
      print('ERERER');
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
}
