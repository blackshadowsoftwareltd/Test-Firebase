import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  final CollectionReference pizzaRef =
      FirebaseFirestore.instance.collection('Pizza');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String productsId, selectSize;
  int totalItems, totalPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Order Page'),
      ),
      body: Stack(
        children: [
          Container(
            // padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
            child: FutureBuilder<QuerySnapshot>(
              future: userdataRef
                  .doc(_firebaseAuth.currentUser.uid)
                  .collection('Order')
                  .get(),
              builder: (context, snapShot) {
                if (snapShot.hasError) {
                  return Center(child: Text('Error ${snapShot.hasError}'));
                }
                if (snapShot.connectionState == ConnectionState.done) {
                  return LiquidPullToRefresh(
                      key: _refreshIndicatorKey,
                      onRefresh: _handleRefresh,
                      showChildOpacityTransition: false,
                      color: Colors.green[400],
                      child: ListView(
                          padding: EdgeInsets.only(
                            bottom: 60,
                          ),
                          children: snapShot.data.docs.map((document) {
                            productsId = document.id;

                            return Card(margin: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: FutureBuilder(
                                future: userdataRef
                                    .doc(_firebaseAuth.currentUser.uid)
                                    .collection('Order')
                                    .doc(productsId)
                                    .get(),
                                builder: (context, productSnap) {
                                  if (productSnap.hasError) {
                                    return Container(
                                        child: Center(
                                            child: Text(
                                                'Error ${productSnap.error}')));
                                  }
                                  if (productSnap.connectionState ==
                                      ConnectionState.done) {
                                    Map _productMap = productSnap.data.data();
                                    selectSize = document.data()['size'];
                                    totalItems = document.data()['quantity'];
                                    return Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Text(
                                                '${_productMap['title']}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.green[400],
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 130,
                                                padding: EdgeInsets.all(5),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                      '${_productMap['imageUrl']}',
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text('${_productMap['name']}',
                                                    //     style: TextStyle(
                                                    //       fontSize: 20,
                                                    //       fontWeight: FontWeight.w600,
                                                    //     )),
                                                    Text(
                                                        'Price: \$ ${_productMap['price']}',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.red)),
                                                    Text('Size: $selectSize',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors
                                                                .black45)),
                                                    Text(
                                                        'Quantity: $totalItems',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors
                                                                .black45)),
                                                    Text(
                                                        'Total : \$ ${document.data()['totalPrice']}',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.red)),
                                                  ],
                                                ),
                                              ),
                                              // Container(
                                              //   child: Positioned(
                                              //     right: 0,
                                              //     bottom: 0,
                                              //     child: Column(
                                              //       children: [
                                              //         Container(
                                              //             height: 50,
                                              //             width: 50,
                                              //             alignment: Alignment.center,
                                              //             // color: Colors.deepPurple,
                                              //             child: IconButton(
                                              //                 icon: Icon(
                                              //                   Icons.edit_outlined,
                                              //                   size: 35,
                                              //                   color: Colors.black45,
                                              //                 ),
                                              //                 onPressed: () {
                                              //                   Navigator.push(
                                              //                       context,
                                              //                       MaterialPageRoute(
                                              //                           builder:
                                              //                               (context) =>
                                              //                                   ProductDetails(
                                              //                                     productId:
                                              //                                         document.id,
                                              //                                   )));
                                              //                 })),
                                              //         Container(
                                              //             height: 40,
                                              //             width: 40,
                                              //             alignment: Alignment.center,
                                              //             // color: Colors.orange,
                                              //             child: IconButton(
                                              //                 icon: Icon(
                                              //                   Icons.remove_circle,
                                              //                   size: 35,
                                              //                   color: Colors.red,
                                              //                 ),
                                              //                 onPressed: () {
                                              //                   setState(() {
                                              //                     _removeCart(
                                              //                         document.id);
                                              //                   });
                                              //                 })),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container(
                                      height: 120,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                },
                              ),
                            );
                          }).toList()));
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // pull to refresh
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
}
