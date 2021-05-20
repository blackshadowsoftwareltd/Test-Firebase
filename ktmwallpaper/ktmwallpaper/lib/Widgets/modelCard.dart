import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:ktmwallpaper/Screen/ViewPage.dart';

class ModelCard extends StatefulWidget {
  final String url, subBrand, subBrandName, id, demoUrl;
  final int save, views;

  ModelCard(
      {this.url,
      this.save,
      this.views,
      this.subBrandName,
      this.subBrand,
      this.demoUrl,
      this.id});

  @override
  _ModelCardState createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-7623473266641534~6037335678');
    loadInterstitial();
  }

  final CollectionReference KTMRef =
      FirebaseFirestore.instance.collection('KTMWalpaper');

  /// initialization
  InterstitialAd myInterstitial;

  int _adLoad;

  @override
  Widget build(BuildContext context) {
    // print('id>>>>>$views');
    return GestureDetector(
        onTap: () async {
          viewsUpdating(widget.views);
          _adLoad = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPage(
                        url: widget.url,
                        id: widget.id,
                        subBrand: widget.subBrand,
                        subBrandName: widget.subBrandName,
                      )));
          print(widget.url);
          print('return data for Interstitial Ad: >><< $_adLoad >><<');
          if (_adLoad == 0) {
            _interstitialAd();
            print(
                'Interstitial Ad: <><><><><><><><><><><><><><><><><><><><><><>');
          }
        },
        child: Container(margin: EdgeInsets.all(3),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300, blurRadius:5, spreadRadius:4)
          ], borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  // height: 200,
                  child: FadeInImage(
                      image: NetworkImage(widget.demoUrl),
                      fit: BoxFit.cover,
                      placeholder: AssetImage('images/icon.jpg')))),
        ));
  }

  Future viewsUpdating(int value) async {
    print('updating views value');
    int _value = value + 1;
    return await KTMRef.doc(widget.subBrand)
        .collection(widget.subBrandName)
        .doc(widget.id)
        .update({'views': _value});
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
      },
    );
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
