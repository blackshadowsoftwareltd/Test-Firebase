import 'dart:async';
import 'dart:math';

import 'package:Food_Delivery_Test/widget/appBar.dart';
import 'package:Food_Delivery_Test/widget/cartBar.dart';
import 'package:Food_Delivery_Test/widget/firstBanner.dart';
import 'package:Food_Delivery_Test/widget/foodCategory.dart';
import 'package:Food_Delivery_Test/widget/orderBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _userId;
  var now = new DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    _userId = _firebaseAuth.currentUser.uid;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // color: Colors.orange,
                margin: EdgeInsets.only(top: 60),
                child: LiquidPullToRefresh(
                  key: _refreshIndicatorKey,
                  onRefresh: _handleRefresh,
                  showChildOpacityTransition: false,
                  color: Colors.green[400],
                  child: _widgetList(),
                )),
            Positioned(left: 0, top: 0, right: 0, child: AppBars())
          ],
        ),
      ),
    );
  }

  Widget _widgetList() {
    return ListView(
      children: [
        FirstBanner(),
        FoodCategory(),
        CartBar(),
        OrderBar(),
      ],
    );
  }

  // pull to refresh <<<<<<<<
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(Duration(seconds: 3), (x) => refreshNum);

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

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
// >>>>>>>>>>>>>
}
