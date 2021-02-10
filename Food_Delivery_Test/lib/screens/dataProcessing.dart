import 'package:Food_Delivery_Test/screens/orderPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataProcessing extends StatefulWidget {
  final int totalCarts;
  final String productsId, selectSize, title;

  final int totalItems, price;

  DataProcessing(
      {this.totalCarts,
      this.productsId,
      this.title,
      this.price,
      this.selectSize,
      this.totalItems});

  @override
  _DataProcessingState createState() => _DataProcessingState();
}

class _DataProcessingState extends State<DataProcessing> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  final CollectionReference orderReceivedRef =
      FirebaseFirestore.instance.collection('OrderReceived');
  final CollectionReference pizzaRef =
      FirebaseFirestore.instance.collection('Pizza');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String userName,
      selectSize,
      useraddress,
      contactNumber,
      userMail,
      productsId,
      title,
      imageUrl,
      itemsName;

  int totalItems = 0, price, totalAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: FutureBuilder(
            future: userdataRef.doc(_firebaseAuth.currentUser.uid).get(),
            builder: (context, snapShot) {
              if (snapShot.hasError) {
                return Text('Error');
              }
              if (snapShot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapShot.data.data();
                userName = data['userName'];
                useraddress = data['address'];
                contactNumber = data['contactNumber'];
                userMail = data['mail'];
                return Text('Ordered by $userName',
                        style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400));
              }
              return Text('Ordered by',
                  style: TextStyle(fontSize: 20, color: Colors.white));
            }),
      ),
      body: Stack(
        children: [
          Container(
            child: FutureBuilder<QuerySnapshot>(
              future: userdataRef
                  .doc(_firebaseAuth.currentUser.uid)
                  .collection('Cart')
                  .get(),
              builder: (context, snapShot) {
                if (snapShot.hasError) {
                  return Center(child: Text('Error ${snapShot.hasError}'));
                }
                if (snapShot.connectionState == ConnectionState.done) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 60),
                    child: ListView(
                      padding: EdgeInsets.only(left: 5, bottom: 60, right: 5),
                      children: snapShot.data.docs.map((document) {
                        productsId = document.id;
                        title = document.data()['title'];

                        return Container(
                          // height: 120,
                          child: FutureBuilder(
                            future: userdataRef
                                .doc(_firebaseAuth.currentUser.uid)
                                .collection('Cart')
                                .doc(productsId)
                                .get(),
                            builder: (context, productSnap) {
                              if (productSnap.hasError) {
                                return Container(
                                    child:
                                        Center(child: Text(productSnap.error)));
                              }
                              if (productSnap.connectionState ==
                                  ConnectionState.done) {
                                Map _productMap = productSnap.data.data();
                                title = document.data()['title'];
                                selectSize = document.data()['size'];
                                price = document.data()['price'];
                                totalItems = document.data()['quantity'];
                                totalAmount = document.data()['totalPrice'];
                                imageUrl = document.data()['imageUrl'];

                                _addToOrder(title, document.id, imageUrl,
                                    selectSize, totalItems, price, totalAmount);
                                _addPersonData(userName, useraddress,
                                    contactNumber, userMail);
                                _orderReceived(document.id, title, selectSize,
                                    totalItems, price, totalAmount);

                                return Container(
                                    height: 50,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text('$title',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ))),
                                          Container(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.done_all,
                                                size: 30,
                                                color: Colors.red,
                                              ))
                                        ]));
                              }
                              return Container(
                                  padding: EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator());
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
          _orderPageButton(),
        ],
      ),
    );
  }

  Future _addToOrder(String title, String productId, String imageUrl,
      String _selectedSize, int value, int price, int totalPrice) {
    final CollectionReference userdataRef =
        FirebaseFirestore.instance.collection('UsersInFo');
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return userdataRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Order')
        .doc(productId)
        .set({
      'title': title,
      'imageUrl': imageUrl,
      'size': _selectedSize,
      'quantity': value,
      'price': price,
      'totalPrice': totalPrice
    });
  }

  Future _addPersonData(String userName, String useraddress,
      String contactNumber, String userMail) {
    final CollectionReference orderReceivedRef =
        FirebaseFirestore.instance.collection('OrderReceived');
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var now = new DateTime.now().toString();
    return orderReceivedRef.doc(_firebaseAuth.currentUser.uid).set({
      'y_m_d_h_m_s': now,
      'userName': userName,
      'contactNumber': contactNumber,
      'address': useraddress,
      'mail': userMail
    });
  }

  Future _orderReceived(String productId, String title, String _selectedSize,
      int value, int price, int totalAmount) {
    final CollectionReference orderReceivedRef =
        FirebaseFirestore.instance.collection('OrderReceived');
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    return orderReceivedRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Order')
        .doc(productId)
        .set({
      'title': title,
      'productId': productId,
      'size': _selectedSize,
      'quantity': value,
      'price': price,
      'totalAmount': totalAmount
    });
  }

  Widget _orderPageButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrderPage()));
        },
        child: Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green[400]),
          child: Text(
            'Back to Order Page',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// Padding(
// padding: const EdgeInsets.all(5),
// child: Text('${_productMap['name']}',
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w600,
// )),
// ),
// Container(
// padding: EdgeInsets.all(5),
// child: Icon(
// Icons.done_all,
// size: 30,
// color: Colors.red,
// ),
// ),
// ],
// );

// _addToOrder(
// document.id, selectSize, itemsValue, price);
// _addPersonData(userName, useraddress,
//     contactNumber, userMail);
// _orderReceived(
// document.id, selectSize, itemsValue, price);
