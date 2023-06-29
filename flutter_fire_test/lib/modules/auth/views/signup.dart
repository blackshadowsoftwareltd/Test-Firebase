import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/material.dart';
import '/helpers/controllers/txt_edtng.dart' show txtEdtngCtrlProvider;
import '/modules/auth/providers/provider.dart' show signup;
import '/modules/home/providers/provider.dart' show userStreamProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;

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
