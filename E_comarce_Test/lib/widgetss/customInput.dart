import 'package:E_comarce_Test/constants.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final String levelText;
  final Function(String) onChanged;
  final Function(String) onSubmit;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPassField;

  CustomInput(
      {this.hintText,
      this.levelText,
      this.onChanged,
      this.onSubmit,
      this.focusNode,
      this.textInputAction,
      this.isPassField});

  @override
  Widget build(BuildContext context) {
    bool _isPassField = isPassField ?? false;
    return Container(
      height: 50,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          // border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextField(
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmit,
        textInputAction: textInputAction,
        obscureText: _isPassField,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? 'hint txt',
            labelText: levelText ?? 'level txt'),
        style: Constants.ligntHeading,
        textAlign: TextAlign.center,
      ),
    );
  }
}
