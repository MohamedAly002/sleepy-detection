import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_drowsiness_alert/database/Task.dart';
import 'package:driver_drowsiness_alert/utils/Date%20Formate/Date_Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDatabase {
  static CollectionReference<Task> getTasksCollection({required String userId}) {
    var tasksCollection = FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('userTasks');
    return tasksCollection.withConverter<Task>(
      fromFirestore: (snapshot, options) => Task.FromFireStore(snapshot.data()!),
      toFirestore: (task, options) => task.tOFireStore(),
    );
  }

  static Future<void> insertTask(Task task) {
    var tasksCollection = FirebaseFirestore.instance
        .collection('tasks')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userTasks');

    var doc = tasksCollection.doc();
    task.id = doc.id;
    task.date = MyDateUtils.ExtractDateOnly(task.date);

    // Set the task data in the document
    return doc.set(task.tOFireStore());
  }

  static Future<List<Task>> getTasks(DateTime dateTime) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userId = user.uid;
      var querysnapshot = await getTasksCollection(userId: userId)
          .where('dateTime', isEqualTo: MyDateUtils.ExtractDateOnly(dateTime).millisecondsSinceEpoch)
          .get();
      var taskslist = querysnapshot.docs.map((doc) => Task.FromFireStore(doc.data() as Map<String, dynamic>)).toList();
      return taskslist;
    } else {
      throw Exception('User is not signed in');
    }
  }

  static Future<QuerySnapshot<Task>> getTaskofFuture(DateTime dateTime) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userId = user.uid;
      return getTasksCollection(userId: userId)
          .where('dateTime', isEqualTo: MyDateUtils.ExtractDateOnly(dateTime).millisecondsSinceEpoch)
          .get();
    } else {
      throw Exception('User is not signed in');
    }
  }

  static Stream<QuerySnapshot<Task>> getRealTimeUpdates(DateTime dateTime) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userId = user.uid;
      return getTasksCollection(userId: userId)
          .where('dateTime', isEqualTo: MyDateUtils.ExtractDateOnly(dateTime).millisecondsSinceEpoch)
          .snapshots();
    } else {
      throw Exception('User is not signed in');
    }
  }

  static Future<void> DeleteTask(Task task) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userId = user.uid;
      var docTask = getTasksCollection(userId: userId).doc(task.id);
      await docTask.delete();
    } else {
      throw Exception('User is not signed in');
    }
  }

  static Future<void> EditTaskDetails(Task task) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userId = user.uid;
      var tasksCollection = getTasksCollection(userId: userId);
      var taskDocument = tasksCollection.doc(task.id);
      await taskDocument.update({
        'title': task.title,
        'description': task.description,
        'dateTime': MyDateUtils.ExtractDateOnly(task.date).millisecondsSinceEpoch,
      });
    } else {
      throw Exception('User is not signed in');
    }
  }

  static void IsDone(Task task) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userId = user.uid;
      var tasksCollection = getTasksCollection(userId: userId);
      var taskDocument = tasksCollection.doc(task.id);
      await taskDocument.update({
        'isDone': task.isDone ? false : true,
      });
    } else {
      throw Exception('User is not signed in');
    }
  }
}
