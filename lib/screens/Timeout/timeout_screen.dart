import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class TimeoutScreen extends StatefulWidget {
  final int timeoutSeconds;
  final VoidCallback onTimeoutComplete;

  const TimeoutScreen({
    Key? key,
    required this.timeoutSeconds,
    required this.onTimeoutComplete,
  }) : super(key: key);

  @override
  State<TimeoutScreen> createState() => _TimeoutScreenState();
}

class _TimeoutScreenState extends State<TimeoutScreen> {
  late Timer _timer;
  int _remainingSeconds = 0;

  final List<String> carouselImages = [
    "assets/images/screen3.jpg",
    "assets/images/background.jpeg",
    "assets/images/background1.jpeg",
    "assets/images/backgrounds.jpg",
    "assets/images/bg1.jpeg",
  ];

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.timeoutSeconds;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          widget.onTimeoutComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevents back button
      child: Scaffold(
      backgroundColor: const Color.fromRGBO(174, 36, 11, 0.8),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Timeout: $_remainingSeconds seconds',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ImageSlideshow(
              width: double.infinity,
              height: 400,
              initialPage: 0,
              indicatorColor: Colors.blue,
              indicatorBackgroundColor: Colors.grey,
              autoPlayInterval: 3000,
              isLoop: true,
              children: carouselImages.map((image) => Image.asset(
                image,
                fit: BoxFit.cover,
              )).toList(),
            ),
          ],
        ),
      ),
    ));
  }
}