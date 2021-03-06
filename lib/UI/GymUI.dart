import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_se/Entity/GymMap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health_se/Entity/PointSchema.dart';
import 'package:health_se/UI/mainUI.dart';
import 'package:health_se/Controller/GymMapController.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

class map extends StatefulWidget {
  map({Key key}) : super(key: key);

  @override
  mapState createState() => mapState();
}

class mapState extends State<map> {
  Position _location = Position(latitude: 0.0, longitude: 0.0);
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = <Marker>[];
  static final CameraPosition _myLocation = CameraPosition(
      target: LatLng(1.32941051118544, 103.887581360714), zoom: 7);

  getLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = location;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      searchDefault();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gyms"),
        leading: FlatButton.icon(
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyApp(tab: 1)));
            });
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
          ),
          label: Text(""),
          textColor: Colors.white,
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: _myLocation,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 575.0, left: 200.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await getLocation();
            searchFiltered(_location);
          },
          label: Text('Search Nearby'), // 3
          icon: Icon(Icons.place),
          backgroundColor: Color(0xFF479055), // 4
        ),
      ),
    );
  }

  void searchDefault() async {
    PointSchema userLocation = PointSchema();
    userLocation.setLongitude(103.68022);
    userLocation.setLatitude(1.34621);
    List<double> longs = [];
    List<double> lats = [];
    List<String> openingHours = [];
    List<String> names = [];
    print(userLocation.getLatitude());
    print(userLocation.getLongitude());
    GymMap mapNeeded = await GymMapController.loadMap();

    for (int i = 0; i < mapNeeded.pointList.length; i++) {
      lats.add(mapNeeded.pointList[i].getLatitude());
      longs.add(mapNeeded.pointList[i].getLongitude());
      openingHours.add(mapNeeded.pointList[i].getOperatingHour());
      names.add(mapNeeded.pointList[i].getName());
    }

    setState(() {
      markers.clear();
    });
    setState(() {
      for (int i = 0; i <= longs.length; i++) {
        String markerId = "$i";
        if (i == longs.length) {
          markers.add(
            Marker(
              markerId: MarkerId(markerId),
              position: LatLng(
                  userLocation.getLatitude(), userLocation.getLongitude()),
              infoWindow: InfoWindow(title: "Default user location"),
            ),
          );
        } else {
          String name = names[i];
          String openingHour = openingHours[i];
          markers.add(
            Marker(
              markerId: MarkerId(markerId),
              position: LatLng(lats[i], longs[i]),
              infoWindow: InfoWindow(title: "$name"),
              onTap: () {
                alertDialog("Opening hours: ", openingHour);
              },
            ),
          );
        }
      }
    });
  }

  void searchFiltered(Position loc) async {
    PointSchema userLocation = PointSchema();
    userLocation.setLongitude(loc.longitude);
    userLocation.setLatitude(loc.latitude);
    List<double> longs = [];
    List<double> lats = [];
    List<String> openingHours = [];
    List<String> names = [];
    print(userLocation.getLatitude());
    print(userLocation.getLongitude());
    GymMap mapNeeded = await GymMapController.loadMap();
    for (int i = 0; i < mapNeeded.pointList.length; i++) {
      var calculatedDistance =
          maps_toolkit.SphericalUtil.computeDistanceBetween(
              maps_toolkit.LatLng(mapNeeded.pointList[i].getLatitude(),
                  mapNeeded.pointList[i].getLongitude()),
              maps_toolkit.LatLng(
                  userLocation.getLatitude(), userLocation.getLongitude()));
      if (calculatedDistance <= 5000) {
        lats.add(mapNeeded.pointList[i].getLatitude());
        longs.add(mapNeeded.pointList[i].getLongitude());
        openingHours.add(mapNeeded.pointList[i].getOperatingHour());
        names.add(mapNeeded.pointList[i].getName());
      }
    }

    setState(() {
      markers.clear();
    });
    setState(() {
      for (int i = 0; i <= longs.length; i++) {
        String markerId = "$i";
        if (i == longs.length) {
          markers.add(
            Marker(
              markerId: MarkerId(markerId),
              position: LatLng(
                  userLocation.getLatitude(), userLocation.getLongitude()),
              infoWindow: InfoWindow(title: "Users location"),
            ),
          );
        } else {
          String name = names[i];
          String openingHour = openingHours[i];
          markers.add(
            Marker(
              markerId: MarkerId(markerId),
              position: LatLng(lats[i], longs[i]),
              infoWindow: InfoWindow(title: "$name"),
              onTap: () {
                alertDialog("Opening hours: ", openingHour);
              },
            ),
          );
        }
      }
    });
  }

  Future<void> alertDialog(String title, String description) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
