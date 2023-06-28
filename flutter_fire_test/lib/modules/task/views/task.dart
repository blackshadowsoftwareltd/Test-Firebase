import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_test/helpers/controllers/txt_edtng.dart';
import 'package:flutter_fire_test/modules/task/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: const Text('Add Task'),
              onPressed: () async => await addTask(ref)),
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
    return Expanded(
      child: tasksData.when(
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text(e.toString()),
        data: (data) {
          final list = data.docs;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => CupertinoListTile(
              trailing: CupertinoButton(
                  onPressed: () {}, child: const Icon(Icons.delete)),
              onTap: () {},
              title: Text(list[index].data().task),
              subtitle: Text(list[index].data().id),
            ),
          );
        },
      ),
    );
  }
}
