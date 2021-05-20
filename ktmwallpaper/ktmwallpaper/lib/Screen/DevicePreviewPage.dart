import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ktmwallpaper/Widgets/PreviewImage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class DevicePreviewPage extends StatefulWidget {
  final String url, subBrand, subBrandName, id;
  final int save;

  DevicePreviewPage(
      {this.url, this.id, this.subBrandName, this.subBrand, this.save});

  @override
  _DevicePreviewPageState createState() => _DevicePreviewPageState();
}

class _DevicePreviewPageState extends State<DevicePreviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = Random().nextInt(5);
    print('data ============= $data');
    isLoading = false;

    /// Register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'Downloading');

    /// Listening for the data is coming other isolates;
    _receivePort.listen((message) {
      // setState(() {
      //   progressValue = message[2];
      // });
      print(progressValue);
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }


  /// <<
  ReceivePort _receivePort = ReceivePort();
  int progressValue = 0;

  static downloadingCallback(id, status, progress) {
    /// Locking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName('Downloading');

    /// Sending the data
    sendPort.send([id, status, progress]);
  }

  /// >>

  final CollectionReference KTMRef =
      FirebaseFirestore.instance.collection('KTMWalpaper');
  int views, data;
  String _localPath;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return SafeArea(
        child: WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Container(
                padding: EdgeInsets.only(bottom: 50),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: DevicePreview(
                    builder: (context) => DevicePreviewImage(url: widget.url))),
            Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                child: FloatingActionButton(
                    heroTag: 'ok',
                    backgroundColor: Colors.deepOrange,
                    child: Icon(Icons.arrow_back_ios_rounded,
                        size: 20, color: Colors.white),
                    onPressed: () => Navigator.pop(context, data))),
            Positioned(
                bottom: 120,
                right: 10,
                child: FloatingActionButton(
                    heroTag: 'device',
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Icon(Icons.offline_pin,
                            size: 35, color: Colors.white),
                    backgroundColor: Colors.deepOrange,
                    onPressed: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        _showPopUp(context);
                        print('xxxxx');
                      } else {
                        _alart(context);
                      }
                    })),
          ])),
    ));
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context, data);
  }

  _showPopUp(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Oops!',
                  style: TextStyle(color: Colors.red, fontSize: 22)),
              content: Text(
                  'Connection Failed\nPlease check your Internet connection',
                  style: TextStyle(fontSize: 18)),
              actions: [
                Container(
                    width: 100,
                    child: FlatButton(
                        child: Text('OK',
                            style: TextStyle(
                                fontSize: 20, color: Colors.deepOrange)),
                        onPressed: () {
                          Navigator.pop(context);
                        }))
              ]);
        });
  }

  /// Alart for download
  _alart(context) {
    var value = Random().nextInt(100);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                'Download now!',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
              content: Text(
                'The image will be download to your Gallery..',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                Container(
                    width: 100,
                    child: FlatButton(
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                        onPressed: () async {
                          saveUpdating(widget.save);
                          final status = await Permission.storage.request();
                          if (status.isGranted) {
                            setState(() {
                              isLoading = true;
                            });
                            final externalDir =
                            await getExternalStorageDirectory();
                            final id = await FlutterDownloader.enqueue(
                                url: widget.url,
                                savedDir: externalDir.path,
                                fileName: 'KTM${widget.id}$value',
                                showNotification: true,
                                openFileFromNotification: true);

                            setState(() {
                              isLoading = false;
                            });

                            Navigator.pop(context);
                          } else {
                            print('Permission denied');
                          }
                        }))
              ]);
        });
  }

  Future saveUpdating(int value) async {
    print('updating views value');
    int _value = value + 1;
    return await KTMRef.doc(widget.subBrand)
        .collection(widget.subBrandName)
        .doc(widget.id)
        .update({'save': _value});
  }
}
