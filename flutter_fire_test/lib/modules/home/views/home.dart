import 'package:flutter/material.dart';
import 'package:flutter_fire_test/modules/auth/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () => signout(ref),
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: const Center(child: Text('Home')),
    );
  }
}
