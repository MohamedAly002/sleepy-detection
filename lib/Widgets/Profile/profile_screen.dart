import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = 'ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? currentUser;
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    // Retrieve current user
    currentUser = FirebaseAuth.instance.currentUser;
    // Fetch additional user data from Firestore
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (currentUser != null) {
      // Fetch user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      // Update username and email
      setState(() {
        username = userDoc['username'];
        email = currentUser!.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Username',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  username ?? 'Loading...',
                  style: TextStyle(fontSize: 16,color: Color(0xFF0583F2)),
                ),
              ),
              ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  email ?? 'Loading...',
                  style: TextStyle(fontSize: 16,color: Color(0xFF0583F2)),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFF0583F2)),
                          padding:
                              MaterialStatePropertyAll(EdgeInsets.all(10))),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Log Out',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
