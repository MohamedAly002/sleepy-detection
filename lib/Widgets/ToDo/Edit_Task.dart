import 'package:driver_drowsiness_alert/database/My_Database.dart';
import 'package:driver_drowsiness_alert/database/Task.dart';
import 'package:driver_drowsiness_alert/utils/Date%20Formate/Date_Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


class EditTaskScreen extends StatefulWidget {
  Task task;
  EditTaskScreen(this.task);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // static const String routeName='EditScreen';
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF0583F2),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
                child: Container(
              width: double.infinity,
              height: mediaQuery.height * .15,
              color: Color(0xFF0583F2),
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    width: mediaQuery.width * 0.89,
                    height: mediaQuery.height * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Center(
                            child: Text(
                          "Edit Task",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                        )),
                        SizedBox(
                          height: 70,
                        ),
                        Form(
                          key: formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Task Title",
                                style:TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
                              TextFormField(
                                onChanged: (String value) {
                                  widget.task.title=value;
                                },
                                style: Theme.of(context).textTheme.headline6,
                                initialValue: widget.task.title,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Task Details",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)
                              ),
                              TextFormField(
                                onChanged: (String value) {
                                  widget.task.description=value;
                                },
                                style: Theme.of(context).textTheme.headline6,
                                initialValue: widget.task.description,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Date",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
                              ),
                              InkWell(
                                onTap: () {
                                  ShowTaskDatePicker();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    MyDateUtils.formateTaskDate(widget.task.date),
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)
                                        ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                            onPressed: () {
                              EditTask();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            height: 55,
                            color: Color(0xFF0583F2),
                            child: Text(
                              'Save Changes',
                              style:TextStyle(color: Colors.white,fontSize: 22),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  var selectedDate = DateTime.now();

  void ShowTaskDatePicker() async {
    var userSelectedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (userSelectedDate == null) {
      return;
    }
    widget.task.date=userSelectedDate;
    selectedDate = userSelectedDate;
    setState(() {});
  }

  void EditTask()async{
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    await MyDatabase.EditTaskDetails(widget.task).
    then((value) {
      Navigator.pop(context);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Task updated Successfully');
    })
        .onError((error, stackTrace) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Task not Updated !!');
    })
    .timeout(Duration(seconds: 10),onTimeout: (){
      QuickAlert.show(context: context, type: QuickAlertType.info,text:"The Task has been updated locally" );
    });

  }
}
