import 'package:flutter/material.dart';
import 'package:flutter_fire_test/modules/auth/views/signin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modules/home/providers/provider.dart';
import 'modules/home/views/home.dart';

class StartApp extends ConsumerWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userStreamProvider);
    return userData.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text('Error $e'),
      ),
      data: (data) {
        
        if (data != null) return const HomeScreen();
        return const SigninScreen();
      },
    );
  }
}
