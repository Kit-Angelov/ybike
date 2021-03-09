import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'rideModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ydb.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ride ("
          "id INTEGER PRIMARY KEY,"
          "distance INTEGER,"
          "date INTEGER,"
          "duration INTEGER,"
          "maxaltitude INTEGER,"
          "minaltitude INTEGER,"
          "avgspeed INTEGER,"
          "maxspeed INTEGER,"
          "elevation INTEGER"
          ");");
      await db.execute("CREATE TABLE point ("
          "id INTEGER PRIVARY KEY,"
          "lat REAL,"
          "lng REAL,"
          "alt REAL,"
          "speed INTEGER,"
          "rideid INTEGER,"
          "FOREIGN KEY(rideid) REFERENCES ride(id)"
          ");");
    });
  }

  newRide(Ride newRide, trackPoints) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM ride");
    int id = table.first["id"];
    var rideid = await db.rawInsert(
        "INSERT Into ride (id,distance,date,duration,maxaltitude,minaltitude,avgspeed,maxspeed,elevation)"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          id,
          newRide.distance,
          newRide.date,
          newRide.duration,
          newRide.maxaltitude,
          newRide.minaltitude,
          newRide.avgspeed,
          newRide.maxspeed,
          newRide.elevation
        ]);
    for (var point in trackPoints) {
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM point");
      int id = table.first["id"];
      var raw = await db.rawInsert(
          "INSERT Into point (id,lat,lng,alt,speed,rideid)"
          " VALUES (?,?,?,?,?,?)",
          [
            id,
            point[0],
            point[1],
            point[2],
            point[3],
            rideid,
          ]);
    }
    return rideid;
  }

  getRide(int id) async {
    final db = await database;
    var res = await db.query("ride", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Ride.fromMap(res.first) : null;
  }

  Future<List<Ride>> getAllRides() async {
    final db = await database;
    var res = await db.query("ride");
    List<Ride> list =
        res.isNotEmpty ? res.map((c) => Ride.fromMap(c)).toList() : [];
    return list;
  }

  deleteRide(int id) async {
    final db = await database;
    db.delete("point", where: "rideid = ?", whereArgs: [id]);
    return db.delete("ride", where: "id = ?", whereArgs: [id]);
  }

  Future<List<TrackPoint>> getTrackPoints(int rideId) async {
    final db = await database;
    var res = await db.query("point", where: "rideid = ?", whereArgs: [rideId]);
    List<TrackPoint> list =
        res.isNotEmpty ? res.map((c) => TrackPoint.fromMap(c)).toList() : [];
    return list;
  }
}
