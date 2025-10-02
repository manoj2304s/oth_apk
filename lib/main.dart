import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oth_apk/screens/Login/Login.dart';
import 'package:oth_apk/screens/Splash/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Location location = Location();

  // bool _serviceEnabled;

  // _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return;
  //   }
  // }

  // TODO:
  // 1. sequence in questions
  // 2. background images
  // 3. 9th question location

  try {

    await GetStorage.init();
    final store = GetStorage();
    // String email = store.read('email').toString();
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     runApp(const MyApp(isLoggedIn: false));
    //   } else {
    //     if (user.email == email) {
    //       runApp(const MyApp(isLoggedIn: true));
    //     } else {
    //       runApp(const MyApp(isLoggedIn: false));
    //     }
    //   }
    // });
    runApp(const MyApp(isLoggedIn: false));
  } catch (e) {
    print(e);
  }

  // runApp(MyApp(isLoggedIn: isLoggedIn));
  // runApp(const MyApp());
}

// Replace push by pushReplacement throughout app navigation
class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
  // const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'OTH',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromRGBO(174, 36, 11, 0.8),
        ),
        home: const AnimatedSplashScreen());
  }
}
