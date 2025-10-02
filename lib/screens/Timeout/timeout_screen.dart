import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class TimeoutScreen extends StatefulWidget {
  final int timeoutSeconds;
  final VoidCallback onTimeoutComplete;
  final String question;
  final String hint;
  final bool isHintTimeout;

  const TimeoutScreen({
    Key? key,
    required this.timeoutSeconds,
    required this.onTimeoutComplete,
    required this.question,
    required this.hint,
    required this.isHintTimeout,
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
          child: SingleChildScrollView(
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (widget.isHintTimeout) 
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          title: const Text('Hint'),
                          content: Text(widget.hint),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.lightbulb, color: Colors.yellow),
                    label: const Text('View Hint'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
                  child: ImageSlideshow(
                    width: double.infinity,
                    height: double.infinity,
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
                ),
                const SizedBox(height: 20), // Add padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
