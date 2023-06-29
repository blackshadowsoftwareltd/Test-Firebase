import 'package:flutter/material.dart';
import '/modules/auth/views/signin.dart' show SigninScreen;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValueX, ConsumerWidget, WidgetRef;

import 'modules/home/providers/provider.dart' show userStreamProvider;
import 'modules/home/views/home.dart' show HomeScreen;

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
        print(data?.uid);
        if (data != null) return const HomeScreen();
        return const SigninScreen();
      },
    );
    // return StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: ((context, snapshot) {
    //       print(snapshot.data?.uid);
    //       if (snapshot.data?.uid != null) return const HomeScreen();
    //       return const SigninScreen();
    //     }));
  }
}
