import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ktmwallpaper/Screen/DevicePreviewPage.dart';
import 'package:ktmwallpaper/Widgets/PreviewImage.dart';
import 'package:ktmwallpaper/Widgets/appBarViewPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ViewPage extends StatefulWidget {
  final String url, subBrand, subBrandName, id;

  ViewPage({this.url, this.subBrand, this.subBrandName, this.id});

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    data = Random().nextInt(5);
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-7623473266641534~6037335678');
    loadInterstitial();

    /// Register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'Downloading');

    /// Listening for the data is coming other isolates;
    _receivePort.listen((message) {
      print(progressValue);
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  final CollectionReference KTMRef =
      FirebaseFirestore.instance.collection('KTMWalpaper');

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

  int save, views, data;
  String _localPath;
  int conditionValue;

  /// initialization
  InterstitialAd myInterstitial;

  @override
  Widget build(BuildContext context) {
    print(
        'subBrand >> ${widget.subBrand} subBrandName >> ${widget.subBrandName} id >>${widget.id}');
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return Scaffold(
        body: SafeArea(
            child: WillPopScope(
                onWillPop: _onBackPressed,
                child: Stack(children: [
                  Container(
                      alignment: Alignment.topCenter,
                      // color: Colors.grey,
                      // height: 650,
                      child: PreviewImage(url: widget.url)),
                  Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      child: Container(
                          height: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _backButton(),
                                Container(
                                    child: FutureBuilder(
                                        future: KTMRef.doc(widget.subBrand)
                                            .collection(widget.subBrandName)
                                            .doc(widget.id)
                                            .get(),
                                        builder: (context, snap) {
                                          if (snap.connectionState ==
                                              ConnectionState.done) {
                                            Map<String, dynamic> document =
                                                snap.data.data();
                                            save = document['save'];
                                            views = document['views'];
                                            // print('save >>>>>$save views >>>>>$views');
                                            return AppBArViewPage(
                                                save: save, views: views);
                                          }
                                          return Container(
                                              height: 25,
                                              width: 25,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 30),
                                              // padding: EdgeInsets.symmetric(horizontal:20),
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  backgroundColor:
                                                      Colors.white));
                                        }))
                              ]))),
                  Positioned(
                      bottom: 60,
                      right: 10,
                      child: FloatingActionButton(
                          heroTag: 'ok',
                          child: isLoading
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
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
                  Positioned(
                      bottom: 60,
                      left: 10,
                      child: Container(
                          height: 100,
                          width: 120,
                          alignment: Alignment.bottomLeft,
                          // color: Colors.green,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 25,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 3),
                                    // padding: const EdgeInsets.only(
                                    //     left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                            Colors.grey[700].withOpacity(.5)),
                                    child: Text('Device Preview',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white))),
                                FloatingActionButton(
                                    heroTag: 'device',
                                    backgroundColor: Colors.deepOrange,
                                    child: Icon(Icons.smartphone, size: 35),
                                    onPressed: () async {
                                      conditionValue = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DevicePreviewPage(
                                                    url: widget.url,
                                                    id: widget.id,
                                                    subBrandName:
                                                        widget.subBrandName,
                                                    subBrand: widget.subBrand,
                                                    save: save,
                                                  )));
                                      print(
                                          'conditionValue is >>>> $conditionValue');
                                      if (conditionValue == 0) {
                                        _interstitialAd();
                                        print(
                                            'Interstitial Ad: <><><><><><><><><><><><><><><><><><><><><><>');
                                      }
                                    })
                              ])))
                ]))));
  }

  Widget _backButton() {
    return Container(
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: CircleAvatar(
            backgroundColor: Colors.deepOrange,
            // maxRadius: 20,
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined,
                    size: 20, color: Colors.white),
                onPressed: () => Navigator.pop(context, data))));
  }

  Future saveUpdating(int value) async {
    print('updating views value');
    int _value = value + 1;
    return await KTMRef.doc(widget.subBrand)
        .collection(widget.subBrandName)
        .doc(widget.id)
        .update({'save': _value});
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
                          saveUpdating(save);
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

  Future<bool> _onBackPressed() {
    Navigator.pop(context, data);
  }

  loadInterstitial() {
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: false,
      gender: MobileAdGender.male,
      // or MobileAdGender.female, MobileAdGender.unknown
      /// testDevices: for Emulator device. otherwise Remove it
      // testDevices: <String>[],
    );

    ///  InterstitialAd
    myInterstitial = InterstitialAd(

        /// adUnitId: original Ad Unit Id
        adUnitId: 'ca-app-pub-7623473266641534/4887905531',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
        });
    // _interstitialAd();
  }

  _interstitialAd() {
    /// calling Interstitial ads
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
  }
}
