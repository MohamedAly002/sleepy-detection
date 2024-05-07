import 'package:driver_drowsiness_alert/Widgets/Drowsiness_Detection/drowsiness_detection.dart';
import 'package:driver_drowsiness_alert/Widgets/Home/home_screen.dart';
import 'package:driver_drowsiness_alert/Widgets/Map/Location_Map.dart';
import 'package:driver_drowsiness_alert/Widgets/Settings/settings.dart';
import 'package:driver_drowsiness_alert/Widgets/Sign%20Up/sign_up.dart';
import 'package:driver_drowsiness_alert/Widgets/Sign%20in/forget_passward.dart';
import 'package:driver_drowsiness_alert/Widgets/Sign%20in/sign_in.dart';
import 'package:driver_drowsiness_alert/firebase_options.dart';
import 'package:driver_drowsiness_alert/utils/Detection_Logic/LiveCameraDetection.dart';
import 'package:driver_drowsiness_alert/utils/Home%20Switcher/home_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:driver_drowsiness_alert/Widgets/ToDo/todo_screen.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driver Drowsiness Alert',
      theme: ThemeData(
        primaryColor: Color(0xFF0583F2)
      ),
      home: HomeSwitcher(),
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        DrowsinessDetection.routeName: (_) => DrowsinessDetection(),
        LocationMap.routeName: (_) => LocationMap(),
        Settings.routeName: (_) => Settings(),
        ToDoScreen.routeName: (_) => ToDoScreen(),
        LiveCameraDetection.routeName: (_) => LiveCameraDetection(),
        SignInScreen.routeName: (_) => SignInScreen(),
        SignUpScreen.routeName: (_) => SignUpScreen(),
        ForgetPassward.routeName: (_) => ForgetPassward(),



      },
    );
  }
}
