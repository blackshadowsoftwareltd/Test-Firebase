import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebasemessaging = FirebaseMessaging();

  List<Message> _message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
    _configurefirebaseListeners();
    _message = List<Message>();
  }

  @override
  Widget build(BuildContext context) {
    String data, value;
    return Scaffold(
        appBar: AppBar(title: Text('Notification')),
        body: ListView.builder(
            itemCount: null == _message ? 0 :
            _message.length,
            itemBuilder: (context, index) {
              print('title >>>>>> ${_message[index].message}');
              print('length >>>>>> ${_message.length}');

              value = _message[index].message;
              data = value ?? 'null';
              return Card(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 18),
                      )));
            }));
  }

  _getToken() {
    _firebasemessaging.getToken().then((deviceToken) {
      print('Device Token >>>>>> $deviceToken');
    });
  }

  _configurefirebaseListeners() {
    _firebasemessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _setMessage(message);
        print('onMessage : $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        _setMessage(message);
        print('onLaunch : $message');
      },
      onResume: (Map<String, dynamic> message) async {
        _setMessage(message);
        print('onResume : $message');
      },
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMesage = data['message'];
    setState(() {
      Message m = Message(title, body, mMesage);
      _message.add(m);
    });
  }
}

class Message {
  String title;
  String body;
  String message;

  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
//
// import 'dart:async';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// final Map<String, Item> _items = <String, Item>{};
// Item _itemForMessage(Map<String, dynamic> message) {
//   final dynamic data = message['data'] ?? message;
//   final String itemId = data['id'];
//   final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
//     ..status = data['status'];
//   return item;
// }
//
// class Item {
//   Item({this.itemId});
//   final String itemId;
//
//   StreamController<Item> _controller = StreamController<Item>.broadcast();
//   Stream<Item> get onChanged => _controller.stream;
//
//   String _status;
//   String get status => _status;
//   set status(String value) {
//     _status = value;
//     _controller.add(this);
//   }
//
//   static final Map<String, Route<void>> routes = <String, Route<void>>{};
//   Route<void> get route {
//     final String routeName = '/detail/$itemId';
//     return routes.putIfAbsent(
//       routeName,
//           () => MaterialPageRoute<void>(
//         settings: RouteSettings(name: routeName),
//         builder: (BuildContext context) => DetailPage(itemId),
//       ),
//     );
//   }
// }
//
// class DetailPage extends StatefulWidget {
//   DetailPage(this.itemId);
//   final String itemId;
//   @override
//   _DetailPageState createState() => _DetailPageState();
// }
//
// class _DetailPageState extends State<DetailPage> {
//   Item _item;
//   StreamSubscription<Item> _subscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _item = _items[widget.itemId];
//     _subscription = _item.onChanged.listen((Item item) {
//       if (!mounted) {
//         _subscription.cancel();
//       } else {
//         setState(() {
//           _item = item;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Item ${_item.itemId}"),
//       ),
//       body: Material(
//         child: Center(child: Text("Item status: ${_item.status}")),
//       ),
//     );
//   }
// }
//
// class PushMessagingExample extends StatefulWidget {
//   @override
//   _PushMessagingExampleState createState() => _PushMessagingExampleState();
// }
//
// class _PushMessagingExampleState extends State<PushMessagingExample> {
//   String _homeScreenText = "Waiting for token...";
//   bool _topicButtonsDisabled = false;
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final TextEditingController _topicController =
//   TextEditingController(text: 'topic');
//
//   Widget _buildDialog(BuildContext context, Item item) {
//     return AlertDialog(
//       content: Text("Item ${item.itemId} has been updated"),
//       actions: <Widget>[
//         FlatButton(
//           child: const Text('CLOSE'),
//           onPressed: () {
//             Navigator.pop(context, false);
//           },
//         ),
//         FlatButton(
//           child: const Text('SHOW'),
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//         ),
//       ],
//     );
//   }
//
//   void _showItemDialog(Map<String, dynamic> message) {
//     showDialog<bool>(
//       context: context,
//       builder: (_) => _buildDialog(context, _itemForMessage(message)),
//     ).then((bool shouldNavigate) {
//       if (shouldNavigate == true) {
//         _navigateToItemDetail(message);
//       }
//     });
//   }
//
//   void _navigateToItemDetail(Map<String, dynamic> message) {
//     final Item item = _itemForMessage(message);
//     // Clear away dialogs
//     Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//     if (!item.route.isCurrent) {
//       Navigator.push(context, item.route);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         _showItemDialog(message);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         _navigateToItemDetail(message);
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(
//             sound: true, badge: true, alert: true, provisional: true));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       print("Settings registered: $settings");
//     });
//     _firebaseMessaging.getToken().then((String token) {
//       assert(token != null);
//       setState(() {
//         _homeScreenText = "Push Messaging token: $token";
//       });
//       print(_homeScreenText);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Push Messaging Demo'),
//         ),
//         // For testing -- simulate a message being received
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => _showItemDialog(<String, dynamic>{
//             "data": <String, String>{
//               "id": "2",
//               "status": "out of stock",
//             },
//           }),
//           tooltip: 'Simulate Message',
//           child: const Icon(Icons.message),
//         ),
//         body: Material(
//           child: Column(
//             children: <Widget>[
//               Center(
//                 child: Text(_homeScreenText),
//               ),
//               Row(children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                       controller: _topicController,
//                       onChanged: (String v) {
//                         setState(() {
//                           _topicButtonsDisabled = v.isEmpty;
//                         });
//                       }),
//                 ),
//                 FlatButton(
//                   child: const Text("subscribe"),
//                   onPressed: _topicButtonsDisabled
//                       ? null
//                       : () {
//                     _firebaseMessaging
//                         .subscribeToTopic(_topicController.text);
//                     _clearTopicText();
//                   },
//                 ),
//                 FlatButton(
//                   child: const Text("unsubscribe"),
//                   onPressed: _topicButtonsDisabled
//                       ? null
//                       : () {
//                     _firebaseMessaging
//                         .unsubscribeFromTopic(_topicController.text);
//                     _clearTopicText();
//                   },
//                 ),
//               ])
//             ],
//           ),
//         ));
//   }
//
//   void _clearTopicText() {
//     setState(() {
//       _topicController.text = "";
//       _topicButtonsDisabled = true;
//     });
//   }
// }
//
// void main() {
//   runApp(
//     MaterialApp(
//       home: PushMessagingExample(),
//     ),
//   );
// }
