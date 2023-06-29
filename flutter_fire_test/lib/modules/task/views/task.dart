import 'package:flutter/cupertino.dart'
    show CupertinoButton, CupertinoListTile, CupertinoTextField;
import 'package:flutter/material.dart';
import '/helpers/controllers/txt_edtng.dart' show txtEdtngCtrlProvider;
import '/modules/task/providers/provider.dart'
    show addTask, deleteTask, selectedTaskProvider, tasksProvider, updateTask;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValueX, ConsumerWidget, WidgetRef;

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTile = ref.watch(selectedTaskProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Task')),
      body: Column(
        children: [
          const _Tasks(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CupertinoTextField(
              placeholder: 'Your Task',
              controller: ref.watch(txtEdtngCtrlProvider('task')),
            ),
          ),
          MaterialButton(
              child: Text(selectedTile == null ? 'Add Task' : 'Update Task'),
              onPressed: () async => selectedTile == null
                  ? await addTask(ref)
                  : await updateTask(ref)),
        ],
      ),
    );
  }
}

class _Tasks extends ConsumerWidget {
  const _Tasks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksData = ref.watch(tasksProvider);
    final selectedTile = ref.watch(selectedTaskProvider);
    return Expanded(
      child: tasksData.when(
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
        data: (data) {
          final list = data.docs;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => CupertinoListTile(
              trailing: Row(
                children: [
                  CupertinoButton(
                      onPressed: () async => ref
                          .watch(selectedTaskProvider.notifier)
                          .update(list[index].data()),
                      child: Icon(selectedTile == list[index].data()
                          ? Icons.remove
                          : Icons.edit)),
                  CupertinoButton(
                      onPressed: () async =>
                          await deleteTask(list[index].data().id),
                      child: const Icon(Icons.delete)),
                ],
              ),
              onTap: () {},
              title: Text(list[index].data().task),
              subtitle: Text('ID: ${list[index].data().id}'),
            ),
          );
        },
      ),
    );
  }
}
