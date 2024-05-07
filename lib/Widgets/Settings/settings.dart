import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  static const String routeName = 'Settings';

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Log Out',style: TextStyle(color:Colors.black,fontSize: 18),),
                      SizedBox(width: 5,),
                      Icon(Icons.logout,color: Colors.black,)
                    ],
                  ),
                )
            ),
          ),
        ],
      )
    );
  }
}
