import 'package:E_comarce_Test/constants.dart';
import 'package:E_comarce_Test/serivces/FirebaseServices.dart';
import 'package:E_comarce_Test/widgetss/ProductCart.dart';
import 'package:E_comarce_Test/widgetss/customInput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FireBaseServices _fireBaseServices = FireBaseServices();

  String _searchString = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
                child: Text(
              'Search Result',
              style: Constants.ligntHeading,
            ))
          else
            FutureBuilder<QuerySnapshot>(
                future: _fireBaseServices.productRef
                    .orderBy('search_String')
                    .startAt([_searchString]).endAt(
                        ['$_searchString\uf8ff']).get(),
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
                      padding: EdgeInsets.only(top: 100, bottom: 5),
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
          Padding(
            padding:
                const EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 0),
            child: CustomInput(
              levelText: 'Search',
              hintText: 'Search here',
              onSubmit: (value) {
                setState(() {
                  _searchString = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
