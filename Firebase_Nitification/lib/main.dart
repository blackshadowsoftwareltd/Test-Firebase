import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_nitification/Notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// AndroidNotificationChannel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    'This channel is used for important notifications.', //description
    importance: Importance.high,
    playSound: true);

/// FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// FirebaseMessagingBackgroundHandler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

/// main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  ///  flutterLocalNotificationsPlugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// setForegroundNotificationPresentationOptions
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MaterialApp(home: Home()));
}

/// StatefulWidget clss
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    /// when app is opened
    /// onMessage listen
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.green,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));

        /// navigate another page and send data
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => NotificationPage(
        //           title: notification.title,
        //           body: notification.body,
        //         )));
        /// show dialog
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(notification.body)]))));
      }
    });

    /// when app is background
    /// onMessageOpenedApp
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new OnMessageOpendApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null)

        /// navigate another page and send data
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationPage(
                      title: notification.title,
                      body: notification.body,
                    )));

      /// show dialog
      // showDialog(
      //     context: context,
      //     builder: (_) => AlertDialog(
      //         title: Text(notification.title),
      //         content: SingleChildScrollView(
      //             child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [Text(notification.body)]))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase Push Notification'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => flutterLocalNotificationsPlugin.show(
                0,
                'title',
                'body',
                NotificationDetails(
                    android: AndroidNotificationDetails(
                        channel.id, channel.name, channel.description,
                        color: Colors.green,
                        playSound: true,
                        icon: '@mipmap/ic_launcher')))));
  }
}
