import 'package:Food_Delivery_Test/screens/cartPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'getAllCartItems.dart';

class CartBar extends StatefulWidget {
  @override
  _CartBarState createState() => _CartBarState();
}

class _CartBarState extends State<CartBar> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartPage()));
      },
      child: Container(
        height: 70,
        width: double.infinity,
        margin: EdgeInsets.all(5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Cart',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Added items:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  getCartItemsValue(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCartItemsValue() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: GetAllCartItems(collectionStr: 'Cart',),
    );
  }
}
