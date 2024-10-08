import 'package:driver_drowsiness_alert/Widgets/Drowsiness_Detection/drowsiness_detection.dart';
import 'package:driver_drowsiness_alert/Widgets/Map/Location_Map.dart';
import 'package:driver_drowsiness_alert/Widgets/Profile/profile_screen.dart';
import 'package:driver_drowsiness_alert/Widgets/ToDo/todo_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected_index=0;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(

      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.drive_eta_outlined),
              label: 'Sleepy Detection',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'location',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task_outlined),
              label: 'ToDo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          currentIndex: selected_index,
          selectedItemColor: Color(0xFF0583F2),
          unselectedItemColor: Colors.black,
          onTap: (index){
            setState(() {
              selected_index=index;
            });
      
          },
        ),
        body: Tabs[selected_index],
      
      ),
    );
  }
  List<Widget>Tabs=[DrowsinessDetection(),LocationMap(),ToDoScreen(),ProfileScreen()];

}
