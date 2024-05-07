import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  static const String routeName = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();

            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}
