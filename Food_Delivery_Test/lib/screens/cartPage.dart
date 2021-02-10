import 'dart:async';
import 'dart:math';

import 'package:Food_Delivery_Test/screens/dataProcessing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  final CollectionReference pizzaRef =
      FirebaseFirestore.instance.collection('Pizza');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String productsId, selectSize, imageUrl, title, _amount;
  int itemsValue, price, totalAmount = 0, dollar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Cart Page'),
      ),
      body: Stack(
        children: [
          LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              showChildOpacityTransition: false,
              color: Colors.green[400],
              child: Container(
                  padding:
                      EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 90),
                  child: FutureBuilder<QuerySnapshot>(
                      future: userdataRef
                          .doc(_firebaseAuth.currentUser.uid)
                          .collection('Cart')
                          .get(),
                      builder: (context, snapShot) {
                        if (snapShot.hasError) {
                          return Center(
                              child: Text('Error ${snapShot.hasError}'));
                        }
                        if (snapShot.connectionState == ConnectionState.done) {
                          return ListView(
                              padding: EdgeInsets.only(
                                bottom: 5,
                              ),
                              children: snapShot.data.docs.map((document) {
                                productsId = document.id;

                                return Container(
                                    height: 150,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: FutureBuilder(
                                            future: userdataRef
                                                .doc(_firebaseAuth
                                                    .currentUser.uid)
                                                .collection('Cart')
                                                .doc(productsId)
                                                .get(),
                                            builder: (context, productSnap) {
                                              if (productSnap.hasError) {
                                                return Container(
                                                    height: 150,
                                                    child: Center(
                                                        child: Text(
                                                            'Error ${productSnap.error}')));
                                              }
                                              if (productSnap.connectionState ==
                                                  ConnectionState.done) {
                                                Map _productMap =
                                                    productSnap.data.data();
                                                title =
                                                    document.data()['title'];
                                                selectSize =
                                                    document.data()['size'];
                                                price =
                                                    document.data()['price'];
                                                itemsValue =
                                                    document.data()['quantity'];
                                                totalAmount = document
                                                    .data()['totalPrice'];
                                                imageUrl =
                                                    document.data()['imageUrl'];

                                                print(
                                                    'total amount $totalAmount');

                                                return Container(
                                                    height: 150,
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    top: 7),
                                                            child: Text(
                                                                '$title',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                            .green[
                                                                        400])),
                                                          ),
                                                          Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                Container(
                                                                  height: 110,
                                                                  width: 130,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child: Image.network(
                                                                        '$imageUrl',
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5,
                                                                          horizontal:
                                                                              5),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      // Text('${_productMap['name']}',
                                                                      //     style: TextStyle(
                                                                      //       fontSize: 20,
                                                                      //       fontWeight: FontWeight.w600,
                                                                      //     )),
                                                                      Text(
                                                                          'Price: \$ $price',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.red)),
                                                                      Text(
                                                                          'Size: ${document.data()['size']}',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: Colors.black45)),
                                                                      Text(
                                                                          'Quantity: ${document.data()['quantity']}',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: Colors.black45)),
                                                                      Text(
                                                                          'Total: \$ ${document.data()['totalPrice']}',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: Colors.red)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                    height: 110,
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: Container(
                                                                        height: 40,
                                                                        width: 40,
                                                                        margin: EdgeInsets.all(5),
                                                                        alignment: Alignment.bottomCenter,
                                                                        // color: Colors.orange,
                                                                        child: IconButton(
                                                                            icon: Icon(
                                                                              Icons.remove_circle,
                                                                              size: 35,
                                                                              color: Colors.red,
                                                                            ),
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                _removeCart(document.id);
                                                                              });
                                                                            })))
                                                              ]))
                                                        ]));
                                              }
                                              return Container(
                                                  height: 120,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            })));
                              }).toList());
                        }
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      }))),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // getTotalAmount(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataProcessing(
                                  title: title,
                                  productsId: productsId,
                                  price: price,
                                  totalItems: totalAmount,
                                  selectSize: selectSize,
                                )));
                    print('Clicked on Proceed Order Button');
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                        child: Text(
                      'Proceed Order',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _removeCart(String productId) {
    return userdataRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Cart')
        .doc(productId)
        .delete()
        .then((value) => print("Cart Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
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

// Future _cartsAmount(int amounts) {
//   int amount = amounts ?? 0;
//
//   final CollectionReference userdataRef =
//       FirebaseFirestore.instance.collection('UsersInFo');
//   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   return userdataRef
//       .doc(_firebaseAuth.currentUser.uid)
//       .collection('CartAmount')
//       .doc('totalAmount')
//       .set({'total': amount});
// }

// Widget getTotalAmount() {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 5),
//     alignment: Alignment.centerRight,
//     child: FutureBuilder(
//         future: userdataRef
//             .doc(_firebaseAuth.currentUser.uid)
//             .collection('CartAmount')
//             .doc('totalAmount')
//             .get(),
//         builder: (context, snapShot) {
//           if (snapShot.hasError) {
//             return Text(
//               'Internet Connection lost',
//               style: TextStyle(fontSize: 18, color: Colors.black),
//             );
//           }
//           if (snapShot.connectionState == ConnectionState.done) {
//             Map<String, dynamic> data = snapShot.data.data();
//             return Text('Total Amount: \$ ${data['total']}',
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400));
//           }
//           return Text('Total Amount 0',
//               style: TextStyle(fontSize: 18, color: Colors.black));
//         }),
//   );
// }
}

// Future _addToOrder(String productId, String _selectedSize, String value) {
//   final CollectionReference userdataRef =
//       FirebaseFirestore.instance.collection('UsersInFo');
//   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   return userdataRef
//       .doc(_firebaseAuth.currentUser.uid)
//       .collection('Order')
//       .doc(productId)
//       .set({'size': _selectedSize, 'quantity': value});
// }
