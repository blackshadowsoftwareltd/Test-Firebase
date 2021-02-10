import 'package:E_comarce_Test/Screen/productPage.dart';
import 'package:E_comarce_Test/constants.dart';
import 'package:E_comarce_Test/widgetss/ProductCart.dart';
import 'package:E_comarce_Test/widgetss/customActionBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('Priducts');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _productRef.get(),
              builder: (context, snapShot) {
                if (snapShot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(
                        'Error...${snapShot.error}',
                      ),
                    ),
                  );
                }
                //collection data ready to display
                if (snapShot.connectionState == ConnectionState.done) {
                  //displaying the data inside a list View
                  return ListView(
                    padding: EdgeInsets.only(top: 70, bottom: 5),
                    children: snapShot.data.docs.map((document) {
                      return ProductCart(
                        title: document.data()['name'],
                        imageUrl: document.data()['images'][0],
                        price: '\$ ${document.data()['price']}',
                        productId: document.id,
                      );
                    }).toList(),
                  );
                }
                //loading state
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          CustomActionBar(
            hasTitle: true,
            title: 'Home',
            hasBackGround: true,
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
