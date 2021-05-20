import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ktmwallpaper/Widgets/appBarListPage.dart';
import 'package:ktmwallpaper/Widgets/modelCard.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ListOfWallpaper extends StatefulWidget {
  final String subBrandName, name;
  int toatalImages;

  ListOfWallpaper({this.subBrandName, this.name, this.toatalImages});

  @override
  _ListOfWallpaperState createState() => _ListOfWallpaperState();
}

class _ListOfWallpaperState extends State<ListOfWallpaper> {
  /// PullToRefresh
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);

  /// initialization
  // InterstitialAd myInterstitial;
  BannerAd myBanner;

  /// initState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('List Of Wallpaper Page');
    print('SubBrand Name >>>>${widget.name}');
    _scrollController = new ScrollController();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-7623473266641534~6037335678');
    _adLoading();
  }

  ///  dispose
  @override
  void dispose() {
    // TODO: implement dispose
    myBanner.dispose();
    print('banner ad data <><> dispose <><>');
    super.dispose();
  }

  /// ///////////////////////////////////
  final CollectionReference KTMRef =
      FirebaseFirestore.instance.collection('KTMWalpaper');

  ScrollController _scrollController;
  List _documents;
  String subBrand = 'subBrand', url, id, demoUrl;
  int _totalItems = 0, save, views;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return Scaffold(
        body: SafeArea(
            child: LiquidPullToRefresh(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                showChildOpacityTransition: false,
                color: Colors.deepOrange,
                child: Stack(children: [
                  StreamBuilder(
                      stream: KTMRef.doc(subBrand)
                          .collection(widget.subBrandName)
                          .snapshots(),
                      builder: (context, snapShot) {
                        if (snapShot.hasError) {
                          return Text(snapShot.error);
                        }
                        if (snapShot.connectionState ==
                            ConnectionState.active) {
                          _totalItems = snapShot.data.documents.length;
                          print('total Image>>>>>>>$_totalItems');
                          return StaggeredGridView.countBuilder(
                              // scrollDirection: Axis.vertical,
                              padding: EdgeInsets.fromLTRB(3, 50, 3, 50),
                              crossAxisCount: 4,
                              itemCount: snapShot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data =
                                    snapShot.data.documents[index];
                                url = data['url'];
                                save = data['save'];
                                views = data['views'];
                                demoUrl = data['demo'];
                                id = data.id;
                                // print('id >>>>>>>>>>>>>>>$id');
                                // return Material(
                                return ModelCard(
                                    url: url,
                                    id: id,
                                    subBrand: subBrand,
                                    subBrandName: widget.subBrandName,
                                    views: views,
                                    save: save,
                                    demoUrl: demoUrl);
                              },
                              staggeredTileBuilder: (index) =>
                                  StaggeredTile.count(
                                      2, index.isEven ? 2.5 : 2),
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2);
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  AppBarListPage(
                    name: widget.name,
                    subBrandName: widget.subBrandName,
                    totalImages: widget.toatalImages,
                  )
                ]))));
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

  _adLoading() {
    ///
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
        // keywords: <String>['flutterio', 'beautiful apps'],
        // contentUrl: 'https://flutter.io',
        // birthday: DateTime.now(),
        // childDirected: false,
        // designedForFamilies: true,
        // gender: MobileAdGender.male,
        // or MobileAdGender.female, MobileAdGender.unknown
        /// testDevices: for Emulator device. otherwise Remove it
        // testDevices: <String>[],
        );

    /// calling in it state
    // interstitialInItState();

    /// BannerAd
    myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: 'ca-app-pub-7623473266641534/1523375597',
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("\nBannerAd event is $event");
      },
    );
    _bannerAd();
  }

  _bannerAd() {
    /// calling Banner ads
    myBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 0.0 pixels from the bottom of the screen
        anchorOffset: 0.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 10.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
    print('banner ad data <><> start <><>');
  }

// Future<bool> _onBackPressed() {
//   myBanner.dispose();
//   Navigator.pop(context);
// }
}
