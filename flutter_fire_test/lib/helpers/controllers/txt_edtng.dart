import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FamilyNotifier, NotifierProviderFamily;

final txtEdtngCtrlProvider =
    NotifierProviderFamily<_TxtEdtngCtrl, TextEditingController, String>(
        _TxtEdtngCtrl.new);

class _TxtEdtngCtrl extends FamilyNotifier<TextEditingController, String> {
  @override
  build(arg) => TextEditingController();
}
