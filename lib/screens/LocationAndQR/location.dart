import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'package:oth_apk/components/CustomButton.dart';
import 'package:oth_apk/components/CustomText.dart';
import 'package:oth_apk/components/warning_for_closing_app/warning_before_closing.dart';
import 'package:oth_apk/screens/LastScreen/last_screen.dart';
import 'package:oth_apk/screens/LocationAndQR/location_page.dart';
import 'package:oth_apk/screens/Questions/Question.dart';
import 'package:oth_apk/services/questions/extra_time_counter.dart';
import 'package:oth_apk/services/timer/count_player_time.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../components/CustomSnackbar.dart';
import '../../services/auth/updateUser.dart';

class LocationPage extends StatefulWidget {
  final double correctLat;
  final double correctLong;
  final String code;
  final bool isLastQuestion;

  const LocationPage(
      {Key? key,
      required this.correctLat,
      required this.correctLong,
      required this.code,
      required this.isLastQuestion})
      : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final CountPlayerTime time = Get.put(CountPlayerTime());
  final ExtraTimeCounter extraTime = Get.put(ExtraTimeCounter());

  final int distanceRange = 30;
  Location location = Location();
  late PermissionStatus _permissionGranted;
  late StreamSubscription<LocationData> locationSubscription;
  var distance = 0.0;
  bool isReached = false;
  var isCorrectQR = '';

  // QR Scanner
  String result = '';
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    controller?.resumeCamera();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  Future<void> checkLocationPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //On Location Change...
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      if (kDebugMode) {
        print(currentLocation);
      }
      var dist = calculateDistance(currentLocation.latitude,
          currentLocation.longitude, widget.correctLat, widget.correctLong);

      if (dist * 1000 < distanceRange) {
        isReached = true;
      } else {
        isReached = false;
      }
      setState(() {
        distance = double.parse((dist * 1000).toStringAsFixed(2));
      });
      if (kDebugMode) {
        print(dist * 1000);
      }
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (widget.code != scanData.code.toString().trim()) {
        setState(() {
          isCorrectQR = 'Wrong QR! Wrong QR!! Wrong QR!!! Virat doesn\'t like wrong QR! Scan the correct QR!!!';
        });
        Vibrate.vibrate();
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   setState(() {
        //     isCorrectQR = '';
        //   });
        // });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            isCorrectQR = '';
          });
        });
      } else {
        setState(() {
          isCorrectQR = 'Correct QR';
        });
        this.controller?.dispose();
        if (!widget.isLastQuestion) {
          this.controller!.pauseCamera();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Question()),
              (Route<dynamic> route) => false);
        } else {
          await time.stopWatchTimer.dispose();
      var finalTime = time.stopWatchTimer.rawTime.value;
      var value = StopWatchTimer.getDisplayTime(finalTime,
        hours: true, milliSecond: true);
      if (kDebugMode) {
      print(time.stopWatchTimer.rawTime.value);
      StopWatchTimer.getDisplayTime(finalTime,
        hours: true, milliSecond: true);
      }
      UpdateUsers(field: 'timer', value: value.toString())
        .then((value) => {
                    this.controller!.pauseCamera(),
                    // controller.stopCamera(),
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LastScreen()),
                        (Route<dynamic> route) => false)
                  })
              // ignore: invalid_return_type_for_catch_error
              .catchError((onError) => {
                    CustomSnackbarWithoutAction(
                        context: context,
                        text: 'Something went wrong. Please try again')
                  });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 400.0;

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(12.0, 20, 12, 8),
            child: Text(
              '',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color.fromARGB(255, 21, 4, 4),
                  fontSize: 28,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900),
            ),
          ),
          titleSpacing: 4,
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/background.jpeg"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.dstATop),
          )),
          child: SafeArea(
              child: isReached
                  ? Stack(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: QRView(
                              key: qrKey,
                              overlay: QrScannerOverlayShape(
                                  borderColor: Colors.red,
                                  borderRadius: 10,
                                  borderLength: 30,
                                  borderWidth: 10,
                                  cutOutSize: scanArea),
                              onQRViewCreated: _onQRViewCreated,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 26.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Remaining Distance : ${distance.toString()} m  ",
                                        style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.blue,
                              size: 42,
                            ),
                            onPressed: () {
                              if (kDebugMode) {
                                print("Refreshing Camera");
                              }
                              controller?.pauseCamera();
                              Timer(const Duration(microseconds: 500), () {
                                controller?.resumeCamera();
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 300, 8, 8),
                          child: Customtext(
                              text: isCorrectQR,
                              color: Colors.white,
                              bold: FontWeight.w500),
                        ),
                      ),
                    ])
                  : LocationWithCompassPage(distance: distance)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // print("disposed");
    controller?.dispose();
    locationSubscription.cancel();
    super.dispose();
  }
}
