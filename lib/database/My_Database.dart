import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_drowsiness_alert/database/Task.dart';
import 'package:driver_drowsiness_alert/utils/Date%20Formate/Date_Utils.dart';


class MyDatabase {
  static CollectionReference<Task> getTasksCollection() {
    var tasksCollection = FirebaseFirestore.instance
        .collection('tasks')
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.FromFireStore(snapshot.data()!),
            toFirestore: (task, options) => task.tOFireStore());
    return tasksCollection;
  }

  static Future<void> insertTask(Task task) {
    var tasksCollection = getTasksCollection();

    var doc = tasksCollection.doc();
    task.id = doc.id;
    task.date = MyDateUtils.ExtractDateOnly(task.date);
    return doc.set(task);
  }

  static Future<List<Task>> getTasks(DateTime dateTime) async {
    var querysnapshot = await getTasksCollection()
        .where('dateTime',
            isEqualTo:
                MyDateUtils.ExtractDateOnly(dateTime).millisecondsSinceEpoch)
        .get();
    var taskslist = querysnapshot.docs.map((doc) => doc.data()).toList();
    return taskslist;
  }

  static Future<QuerySnapshot<Task>> getTaskofFuture(DateTime dateTime) {
    return getTasksCollection().where('dateTime',
        isEqualTo:
        MyDateUtils.ExtractDateOnly(dateTime).millisecondsSinceEpoch).get();
  }

  static Stream<QuerySnapshot<Task>> getRealTimeUpdates(DateTime dateTime) {
    return getTasksCollection().where('dateTime',
        isEqualTo:
        MyDateUtils.ExtractDateOnly(dateTime).millisecondsSinceEpoch).snapshots();
  }

  static Future<void> DeleteTask(Task task) {
    var docTask = getTasksCollection().doc(task.id);
    return docTask.delete();
  }

  static Future<void> EditTaskDetails(Task task){
    var tasksCollection =getTasksCollection();
    var taskDocument=tasksCollection.doc(task.id);
    return taskDocument.update({
      'title':task.title,
      'description':task.description  ,
      'dateTime':MyDateUtils.ExtractDateOnly(task.date).millisecondsSinceEpoch,

    });

  }

  static void IsDone(Task task){
    var tasksCollection =getTasksCollection();
    var taskDocument=tasksCollection.doc(task.id);
    taskDocument.update({
      'isDone':task.isDone? false:true,
    });
  }
}
