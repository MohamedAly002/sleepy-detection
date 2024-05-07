import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_drowsiness_alert/Widgets/Drives_of_the_day/Add_Task.dart';
import 'package:driver_drowsiness_alert/Widgets/Drives_of_the_day/Task_Item.dart';
import 'package:driver_drowsiness_alert/database/My_Database.dart';
import 'package:driver_drowsiness_alert/database/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';

class DrivesOfTheDay extends StatefulWidget {
  const DrivesOfTheDay({Key? key}) : super(key: key);
  static const String routeName = 'DrivesOfTheDay';

  @override
  State<DrivesOfTheDay> createState() => _DrivesOfTheDayState();
}

var selectedDate = DateTime.now();

class _DrivesOfTheDayState extends State<DrivesOfTheDay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            'Drives of the Day',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            return ShowAddTaskBottomSheet();
          },
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
          shape: StadiumBorder(
            side: BorderSide(width: 5, color: Color(0xFF0583F2)),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.14,
                child: CalendarWeek(
                  // controller: _controller,
                  showMonth: true,
                  minDate: DateTime.now().add(
                    Duration(days: -365),
                  ),
                  maxDate: DateTime.now().add(
                    Duration(days: 365),
                  ),
                  onDatePressed: (DateTime datetime) {
                    // Do something
                    setState(() {
                      selectedDate = datetime;
                    });
                  },
                  onWeekChanged: () {
                    // Do something
                  },
                  monthViewBuilder: (DateTime time) => Align(
                    alignment: FractionalOffset.center,
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          DateFormat.yMMMM().format(time),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        )),
                  ),
                  decorations: [
                    DecorationItem(
                        decorationAlignment: FractionalOffset.bottomRight,
                        date: DateTime.now(),
                        decoration: Icon(
                          Icons.today,
                          color: Colors.blue,
                        )),
                  ],

                ),
              ),
              Expanded(
                  child:
                      // allTasks.isEmpty?Center(child: CircularProgressIndicator()):
                      StreamBuilder<QuerySnapshot<Task>>(
                stream: MyDatabase.getRealTimeUpdates(selectedDate),
                builder: (buildContext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error in Loading Tasks\nCheck ur internet connection'));
                  }
                  var tasks =
                      snapshot.data?.docs.map((doc) => doc.data()).toList();
                  return ListView.builder(
                    itemBuilder: (_, index) {
                      return TaskItem(tasks![index]);
                    },
                    itemCount: tasks?.length ?? 0,
                  );
                },
              ))
            ],
          ),
        ));
  }

  void ShowAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (buildContext) {
        return AddTask();
      },
    );
  }
}
