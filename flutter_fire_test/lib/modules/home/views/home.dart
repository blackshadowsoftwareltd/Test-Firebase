import 'package:flutter/material.dart';
import 'package:flutter_fire_test/modules/auth/providers/provider.dart';
import 'package:flutter_fire_test/modules/home/providers/provider.dart';
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
      body: const Column(
        children: [
          _UserInfo(),
          Text('Home'),
        ],
      ),
    );
  }
}

class _UserInfo extends ConsumerWidget {
  const _UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoData = ref.watch(profileInfoProvider);
    return SizedBox(
      width: double.maxFinite,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: userInfoData.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text(e.toString()),
            data: (data) => Text(data?.name ?? 'Name Not Found'),
          ),
        ),
      ),
    );
  }
}
