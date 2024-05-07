import 'package:driver_drowsiness_alert/Widgets/ToDo/Edit_Task.dart';
import 'package:driver_drowsiness_alert/database/My_Database.dart';
import 'package:driver_drowsiness_alert/database/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/quickalert.dart';


class TaskItem extends StatefulWidget {
  Task task;
  TaskItem(this.task);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context0) =>
                  EditTaskScreen(widget.task)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.red,
        ),
        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
        child: Slidable(
          startActionPane:
              ActionPane(extentRatio: 0.25, motion: DrawerMotion(), children: [
            SlidableAction(
              onPressed: (buildContext) {
                deleteTask();
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            )
          ]),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color:Colors.white,
            ),
            child: Row(
              children: [
                Container(
                    height: 70,
                    width: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: widget.task.isDone
                          ? Colors.green
                          : Color(0xFF0583F2),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.task.title,
                          style: TextStyle(fontSize: 24)
                              ?.copyWith(
                                  color: widget.task.isDone
                                      ? Colors.green
                                      : Color(0xFF0583F2),)
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.task.description,
                          style: TextStyle(fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    MyDatabase.IsDone(widget.task);
                  },
                  child: widget.task.isDone
                      ? Text(
                          'Done!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.green),
                        )
                      : Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xFF0583F2),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteTask() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to delete this task?',
      confirmBtnText: 'Yes',
      onConfirmBtnTap: ()  {
         MyDatabase.DeleteTask(widget.task);
        Navigator.pop(context);
        QuickAlert.show(context: context, type: QuickAlertType.success,text: 'Task is Deleted Successfully');
        },
      cancelBtnText: 'Cancel',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }
}
