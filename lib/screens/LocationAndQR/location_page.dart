import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:oth_apk/components/CustomText.dart';

class LocationWithCompassPage extends StatefulWidget {
  final double distance;
  const LocationWithCompassPage({Key? key, required this.distance})
      : super(key: key);

  @override
  State<LocationWithCompassPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationWithCompassPage> {
  bool _hasPermissions = false;
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;

  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_hasPermissions) {
        return Column(
          children: <Widget>[
            Expanded(child: _buildCompass()),
          ],
        );
      } else {
        return _buildPermissionSheet();
      }
    });
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 60, 30, 1),
            ),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Stack(children: [
            Material(
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(228, 200, 179, 177),
                      Color.fromARGB(228, 168, 104, 99)
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromRGBO(120, 14, 1, 0.9),
                      Color.fromRGBO(52, 8, 4, 0.9)
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.distance == 0.0
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 60, 30, 1),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Customtext(
                            text: '${widget.distance.toString()} m ',
                            textCenter: true,
                            size: 32.0,
                            color: Colors.white,
                            bold: FontWeight.w500),
                      ),
                Center(
                  child: Container(),
                ),
              ],
            )
          ]),
        );
      },
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Location Permission Required'),
          ElevatedButton(
            child: Customtext(
                text: 'Request Permissions',
                color: Colors.black,
                bold: FontWeight.w500,
                size: 18.0),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }
}
