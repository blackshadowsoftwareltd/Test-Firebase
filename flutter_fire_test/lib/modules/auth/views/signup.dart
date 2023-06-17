import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_test/helpers/controllers/txt_edtng.dart';
import 'package:flutter_fire_test/modules/auth/providers/provider.dart';
import 'package:flutter_fire_test/modules/home/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Signup Screen')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CupertinoTextField(
              placeholder: 'Name',
              controller: ref.watch(txtEdtngCtrlProvider('Sign up Name')),
            ),
            const SizedBox(height: 20),
            CupertinoTextField(
              placeholder: 'Email',
              controller: ref.watch(txtEdtngCtrlProvider('Sign up Email')),
            ),
            const SizedBox(height: 20),
            CupertinoTextField(
              placeholder: 'Password',
              obscureText: true,
              controller: ref.watch(txtEdtngCtrlProvider('Sign up Pass')),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () async {
                await signup(ref);
              },
              child: const Text('Signup'),
            )
          ],
        ),
      ),
    );
  }
}
