import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderDone extends StatefulWidget {
  final String productsId,
      selectSize,
      title,
      userName,
      useraddress,
      contactNumber,
      userMail;

  final int totalItems, price;

  OrderDone(
      {this.productsId,
      this.title,
      this.price,
      this.selectSize,
      this.totalItems,
      this.userName,
      this.useraddress,
      this.contactNumber,
      this.userMail});

  @override
  _OrderDoneState createState() => _OrderDoneState();
}

class _OrderDoneState extends State<OrderDone> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  final CollectionReference orderReceivedRef =
      FirebaseFirestore.instance.collection('OrderReceived');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addToOrder(
        widget.productsId, widget.selectSize, widget.totalItems, widget.price);
    _addPersonData(widget.userName, widget.useraddress, widget.contactNumber,
        widget.userMail);
    _orderReceived(
        widget.productsId, widget.selectSize, widget.totalItems, widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.done_all,
                size: 30,
                color: Colors.red,
              ),
            ),
          ],
        ));
  }

  Future _addToOrder(
      String productId, String _selectedSize, int value, int price) {
    final CollectionReference userdataRef =
        FirebaseFirestore.instance.collection('UsersInFo');
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return userdataRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Order')
        .doc(productId)
        .set({'size': _selectedSize, 'quantity': value, 'TotalPrice': price});
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

  Future _orderReceived(
      String productId,
      // String productName,
      String _selectedSize,
      int value,
      int price) {
    final CollectionReference orderReceivedRef =
        FirebaseFirestore.instance.collection('OrderReceived');
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    return orderReceivedRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Order')
        .doc(productId)
        .set({
      'productId': productId,
      'size': _selectedSize,
      'quantity': value,
      'totalPrice': price
    });
  }
}
