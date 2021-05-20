import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  List data = [
    {'id': 1, 'title': 'Untitle Data'},
    {'id': 2, 'title': 'Unspacified Data'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List of Data')),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => ListTile(
                title: Text('${'title'[index]}'),
              )),
    );
  }
}
