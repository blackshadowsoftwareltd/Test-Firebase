
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final String title, body;

  const NotificationPage({Key key, this.title, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Page')),
      body: Container(width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(title),
          Text(body),
        ]),
      ),
    );
  }
}
// showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//         title: Text(notification.title),
//         content: SingleChildScrollView(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [Text(notification.body)]))));
