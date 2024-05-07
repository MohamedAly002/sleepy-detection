import 'package:driver_drowsiness_alert/database/My_Database.dart';
import 'package:driver_drowsiness_alert/database/Task.dart';
import 'package:driver_drowsiness_alert/utils/Date%20Formate/Date_Utils.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add New Task",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6,
                controller: titleController,
                validator: (inpute) {
                  if (inpute == null || inpute.trim().isEmpty) {
                    return 'Please Enter a valid title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: Theme.of(context).textTheme.headline5,
                  hintText: 'Enter Your Task',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6,
                controller: descriptionController,
                minLines: 4,
                maxLines: 4,
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: Theme.of(context).textTheme.headline5,
                    hintText: 'Enter Your Description',
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (inpute) {
                  if (inpute == null || inpute.trim().isEmpty) {
                    return 'Please Enter a valid description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Select Date",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  ShowTaskDatePicker();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    MyDateUtils.formateTaskDate(selectedDate),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                     insertTask();
                     if (formKey.currentState?.validate() == true) {
                       Navigator.pop(context);
                     }
                  },
                  child: Text("Submit"))
            ],
          ),
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
    selectedDate = userSelectedDate;
    setState(() {});
  }

  Future<void> insertTask() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    Task task = Task(
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate);

    try {
      QuickAlert.show(
          context: context, type: QuickAlertType.loading, text: 'Adding Task...');
      await MyDatabase.insertTask(task);
      Navigator.pop(context);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'The Task Inserted Successfuly');
    } catch (e) {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Something went Wrong While Adding the Task',
        confirmBtnText: 'Try again',
        onConfirmBtnTap: () {
          insertTask();
        },
        cancelBtnText: 'Cancel',
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
      );
    }
  }
}
