import 'package:bmind/src/constants/app_color.dart';
import 'package:bmind/src/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Eco Survey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: AppColor.primarySwatch),
      home: const SplashScreen(),
    );
  }
}
