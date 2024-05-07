import 'package:driver_drowsiness_alert/Widgets/Home/home_screen.dart';
import 'package:driver_drowsiness_alert/Widgets/Sign%20in/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeSwitcher extends StatelessWidget {
  const HomeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (builder,snapshot){
        if(snapshot.hasData){
          return HomeScreen();
    }
        else{
          return SignInScreen();
    }
    },
      ));
  }
}
