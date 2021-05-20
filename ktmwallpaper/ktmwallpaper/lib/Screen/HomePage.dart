import 'dart:async';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ktmwallpaper/Screen/ListOfWallpaper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ktmwallpaper/Widgets/subBrandCard.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// PullToRefresh
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);

  ScrollController _scrollController;

  ///
  final CollectionReference KTMRef =
      FirebaseFirestore.instance.collection('KTMWalpaper');
  int version = 1, currentVersion = 0, totalRc, totalDuke, totalAdventure;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController();
    print('HomePage.....');
    _checkConnection();
    _showVersion();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title:Text('KTM Wallpaper'),
        centerTitle: true,
        titleSpacing: 1,
      ),
      body: LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          color: Colors.deepOrange,
          child:
              ListView(padding: EdgeInsets.symmetric(vertical: 5), children: [
            Container(
                // height: MediaQuery.of(context).size.height-100,
                height: 1150,
                // color: Colors.purple,
                child: Column(children: [
                  Container(
                      // height: 50,
                      alignment: Alignment.center,
                      child: FutureBuilder(
                          future: KTMRef.doc('currentVersion').get(),
                          builder: (context, ktmSnap) {
                            if (ktmSnap.hasError) {
                              return Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.deepOrange,
                                  ));
                            }
                            if (ktmSnap.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> documentData =
                                  ktmSnap.data.data();
                              currentVersion = documentData['version'];
                              print('Current Version>>>>>>>>$currentVersion');

                              return totalImageList(context);
                            }
                            return Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            );
                          })),
                  GestureDetector(
                    onTap: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        _showPopUp(context);
                        print('xxxxx');
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOfWallpaper(
                                      subBrandName: 'KtmRc',
                                      name: 'KTM RC',
                                      toatalImages: totalRc,
                                    )));
                      }
                    },
                    child: SubBrandCard(name: 'KTM RC', imagePath: 'ktmrc.jpg'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        _showPopUp(context);
                        print('xxxxx');
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOfWallpaper(
                                      subBrandName: 'KtmDuke',
                                      name: 'KTM DUKE',
                                      toatalImages: totalDuke,
                                    )));
                      }
                    },
                    child: SubBrandCard(
                        name: 'KTM DUKE', imagePath: 'ktmduke.jpg'),
                  ),
                  GestureDetector(
                      onTap: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
                          _showPopUp(context);
                          print('xxxxx');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListOfWallpaper(
                                        subBrandName: 'KtmAdventure',
                                        name: 'KTM ADVENTURE & OTHERS',
                                        toatalImages: totalAdventure,
                                      )));
                        }
                      },
                      child: SubBrandCard(
                          name: 'KTM ADVENTURE & OTHERS',
                          imagePath: 'adventure.jpg'))
                ]))
          ])),
    );
  }

  Widget _appBAr(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.deepOrange,
    );
  }

  /// Checking Internet Connection
  Future _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print('xxxxx');
    }
  }

  /// Internet Connection PopUp
  _showPopUp(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                'Oops!',
                style: TextStyle(color: Colors.red, fontSize: 22),
              ),
              content: Text(
                'Connection Failed\nPlease check your Internet connection',
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                Container(
                    width: 100,
                    child: FlatButton(
                        child: Text(
                          'OK',
                          style:
                              TextStyle(fontSize: 20, color: Colors.deepOrange),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }))
              ]);
        });
  }

  /// Update Popup
  _showVersion() {
    Future.delayed(Duration(seconds: 5), () {
      if (currentVersion != 0) {
        if (currentVersion != version) {
          _versionPopUp(context);
          print(version);
          print(currentVersion);
        }
      }
    });
  }

  /// Update Popup
  _versionPopUp(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Update'),
              content: Text('A new version is released.\nPlease update now'),
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

  /// for Pull to Refresh
  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = new Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }

  totalImageList(BuildContext context) {
    return Container(
        height: 150,
        width: MediaQuery.of(context).size.width - 30,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)
        ], borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Total Images',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w700)),
              totalNumber(context, 'KtmRc', 'KTM RC'),
              totalNumber(context, 'KtmDuke', 'KTM DUKE'),
              totalNumber(context, 'KtmAdventure', 'KTM ADVENTURE & OTHERS')
            ]));
  }

  Widget totalNumber(
      BuildContext context, String collectionStr, String subBrandName) {
    // String collectionStr;

    final CollectionReference KTMRef =
        FirebaseFirestore.instance.collection('KTMWalpaper');
    String subBrand = 'subBrand';
    return StreamBuilder(
        stream: KTMRef.doc(subBrand).collection(collectionStr).snapshots(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Text(snapShot.error);
          }
          if (snapShot.connectionState == ConnectionState.active) {
            List _documents = snapShot.data.docs;

            if (collectionStr == 'KtmRc') {
              totalRc = _documents.length;
              print('total $totalRc');
            } else if (collectionStr == 'KtmDuke') {
              totalDuke = _documents.length;
              print('total $totalDuke');
            } else if (collectionStr == 'KtmAdventure') {
              totalAdventure = _documents.length;
              print('total $totalAdventure');
            }

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(subBrandName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(' ${_documents.length}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500)),
                        Icon(Icons.image_outlined,
                            size: 22, color: Colors.black54)
                      ])
                ]);
          }

          return Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  backgroundColor: Colors.white, strokeWidth: 1));
        });
  }
}
