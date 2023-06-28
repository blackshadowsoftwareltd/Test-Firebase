import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_test/helpers/controllers/txt_edtng.dart';
import 'package:flutter_fire_test/modules/task/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<bool> addTask(WidgetRef ref) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    final taskTxt = ref.read(txtEdtngCtrlProvider('task')).text;
    final task = Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(), task: taskTxt);
    final taskCollection = FirebaseFirestore.instance
        .collection('UsersInFo')
        .doc(user.uid)
        .collection('Tasks')
        .withConverter<Task>(
          fromFirestore: (snapshot, _) => Task.fromMap(snapshot.data()!),
          toFirestore: (user, _) => user.toMap(),
        );
    final success = await taskCollection.add(task).then((value) {
      log('Data Saved in DB');
      return true;
    }).catchError((e) {
      log(e.toString());
      return false;
    });
    log(success.toString());
    return success;
  } catch (e) {
    return false;
  }
}

final tasksProvider = StreamProvider<QuerySnapshot<Task>>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  return FirebaseFirestore.instance
      .collection('UsersInFo')
      .doc(user?.uid)
      .collection('Tasks')
      .withConverter<Task>(
        fromFirestore: (snapshot, _) => Task.fromMap(snapshot.data()!),
        toFirestore: (user, _) => user.toMap(),
      )
      .snapshots();
});
