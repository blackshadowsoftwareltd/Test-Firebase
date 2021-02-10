import 'package:E_comarce_Test/Screen/productPage.dart';
import 'package:E_comarce_Test/constants.dart';
import 'package:E_comarce_Test/serivces/FirebaseServices.dart';
import 'package:E_comarce_Test/widgetss/customActionBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FireBaseServices _fireBaseServices = FireBaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _fireBaseServices.usersRef
                  .doc(_fireBaseServices.getUserId())
                  .collection('Cart')
                  .get(),
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                productId: document.id,
                              ),
                            ),
                          );
                        },
                        child: FutureBuilder(
                          future: _fireBaseServices.productRef
                              .doc(document.id)
                              .get(),
                          builder: (context, productSnap) {
                            if (productSnap.hasError) {
                              return Container(
                                child: Center(
                                  child: Text('${productSnap.error}'),
                                ),
                              );
                            }
                            if (productSnap.connectionState ==
                                ConnectionState.done) {
                              Map _productMap = productSnap.data.data();
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '${_productMap['images'][0]}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Expanded(
                                              child: Container(
                                                child: Text(
                                                  '${_productMap['name']}',
                                                  style: Constants.regularHeading,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Text(
                                              'Price \$${_productMap['price']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Text(
                                              'Storage ${document.data()['storage']}',
                                              style: Constants.regularHeading,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
            title: 'Cart',
            hasBackGround: true,
            hasBackArrow: true,
          )
        ],
      ),
    );
  }
}
