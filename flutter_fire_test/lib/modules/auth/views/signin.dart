import 'package:flutter/cupertino.dart'
    show CupertinoPageRoute, CupertinoTextField;
import 'package:flutter/material.dart';
import '/helpers/controllers/txt_edtng.dart' show txtEdtngCtrlProvider;
import '/modules/auth/views/signup.dart' show SignupScreen;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;

import '../providers/provider.dart' show signin;

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signin Screen')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              placeholder: 'Email',
              controller: ref.watch(txtEdtngCtrlProvider('Sign In Email')),
            ),
            const SizedBox(height: 20),
            CupertinoTextField(
              placeholder: 'Password',
              obscureText: true,
              controller: ref.watch(txtEdtngCtrlProvider('Sign In Pass')),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () async {
                    await signin(
                        ref.read(txtEdtngCtrlProvider('Sign In Email')).text,
                        ref.watch(txtEdtngCtrlProvider('Sign In Pass')).text);
                  },
                  child: const Text('Signin'),
                ),
                MaterialButton(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  ),
                  child: const Text('Signup'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
