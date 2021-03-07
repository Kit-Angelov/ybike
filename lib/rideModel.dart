import 'dart:convert';

Ride rideFromJson(String str) {
  final jsonData = json.decode(str);
  return Ride.fromMap(jsonData);
}

String rideToJson(Ride data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Ride {
  int id;
  double distance;
  int date;
  int duration;
  double maxaltitude;
  double minaltitude;
  double avgspeed;
  double maxspeed;
  double elevation;

  Ride(
      {this.id,
      this.distance,
      this.date,
      this.duration,
      this.maxaltitude,
      this.minaltitude,
      this.avgspeed,
      this.maxspeed,
      this.elevation});

  factory Ride.fromMap(Map<String, dynamic> json) => new Ride(
        id: json["id"],
        distance: json["distance"],
        date: json["date"],
        duration: json["duration"],
        maxaltitude: json["maxaltitude"],
        elevation: json["elevation"],
        minaltitude: json["minaltitude"],
        avgspeed: json["avgspeed"],
        maxspeed: json["maxspeed"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "distance": distance,
        "date": date,
        "duration": duration,
        "maxaltitude": maxaltitude,
        "elevation": elevation,
        "minaltitude": minaltitude,
        "avgspeed": avgspeed,
        "maxspeed": maxspeed,
      };
}

class TrackPoint {
  int id;
  double lat;
  double lng;
  double alt;
  double speed;
  int rideid;

  TrackPoint({this.id, this.lat, this.lng, this.alt, this.speed, this.rideid});

  factory TrackPoint.fromMap(Map<String, dynamic> json) => new TrackPoint(
        id: json["id"],
        lat: json["lat"],
        lng: json["lng"],
        alt: json["alt"],
        speed: json["speed"],
        rideid: json["rideid"],
      );
}
