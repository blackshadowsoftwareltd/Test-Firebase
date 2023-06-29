import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, QuerySnapshot;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import '/helpers/controllers/txt_edtng.dart' show txtEdtngCtrlProvider;
import '/modules/task/models/task.dart' show Task;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Notifier, NotifierProvider, StreamProvider, WidgetRef;

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

final selectedTaskProvider =
    NotifierProvider<_SelectedUpdate, Task?>(_SelectedUpdate.new);

class _SelectedUpdate extends Notifier<Task?> {
  @override
  Task? build() => null;
  void update(Task t) {
    if (state == t) {
      ref.read(txtEdtngCtrlProvider('task')).clear();
      state = null;
    } else {
      ref.read(txtEdtngCtrlProvider('task')).text = t.task;
      state = t;
    }
  }
}

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
        .doc(task.id)
        .withConverter<Task>(
          fromFirestore: (snapshot, _) => Task.fromMap(snapshot.data()!),
          toFirestore: (user, _) => user.toMap(),
        );
    final success = await taskCollection.set(task).then((value) {
      ref.read(txtEdtngCtrlProvider('task')).clear();
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

Future<bool> updateTask(WidgetRef ref) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final task = ref.read(selectedTaskProvider);
    if (user == null || task == null) return false;
    final taskTxt = ref.read(txtEdtngCtrlProvider('task')).text;

    final taskCollection = FirebaseFirestore.instance
        .collection('UsersInFo')
        .doc(user.uid)
        .collection('Tasks')
        .doc(task.id)
        .withConverter<Task>(
          fromFirestore: (snapshot, _) => Task.fromMap(snapshot.data()!),
          toFirestore: (user, _) => user.toMap(),
        );
    final success = await taskCollection
        .update(task.copyWith(task: taskTxt).toMap())
        .then((value) {
      log('Data Update in DB');
      ref.read(selectedTaskProvider.notifier).update(task);
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

Future<bool> deleteTask(String id) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;
  return await FirebaseFirestore.instance
      .collection('UsersInFo')
      .doc(user.uid)
      .collection('Tasks')
      .doc(id)
      .delete()
      .then((value) => true)
      .catchError((error) {
    log("Failed to delete user: $error");
    return false;
  });
}
