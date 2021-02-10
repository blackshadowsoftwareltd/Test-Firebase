import 'package:E_comarce_Test/constants.dart';
import 'package:E_comarce_Test/serivces/FirebaseServices.dart';
import 'package:E_comarce_Test/widgetss/customActionBar.dart';
import 'package:E_comarce_Test/widgetss/imageSwipe.dart';
import 'package:E_comarce_Test/widgetss/storageSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  // final Function (String) onSelected;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // getting data from FirebaseServices
  FireBaseServices _fireBaseServices = FireBaseServices();

  String _seletedStorageSize = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: _fireBaseServices.productRef.doc(widget.productId).get(),
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

                if (snapShot.connectionState == ConnectionState.done) {
                  // firebase document map
                  Map<String, dynamic> documentData = snapShot.data.data();
                  List imageList = documentData['images'];
                  List storageSize = documentData['storage'];

                  //Set an initial size
                  _seletedStorageSize = storageSize[0];

                  return ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      ImageSwipe(
                        imageList: imageList,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${documentData['name']}' ?? 'Name',
                          style: Constants.boldHeading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '\$ ${documentData['price']}' ?? 'Price',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${documentData['desc']}' ?? 'Desc',
                          style: Constants.ligntHeading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Select Storage Capacity',
                          style: Constants.regularHeading,
                        ),
                      ),
                      StorageSize(
                        storageSize: storageSize,
                        onSelected: (size) {
                          _seletedStorageSize = size;
                        },
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_savedSnackBar);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.bookmark_border_outlined,
                                size: 25,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_cartSnackBar);
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          CustomActionBar(
            hasTitle: false,
            hasBackArrow: true,
            hasBackGround: false,
          )
        ],
      ),
    );
  }

  // method for add to be cord
  Future _addToCart() {
    return _fireBaseServices.usersRef
        .doc(_fireBaseServices.getUserId())
        .collection('Cart')
        .doc(widget.productId)
        .set({'storage': _seletedStorageSize});
  }

  Future _addToSaved() {
    return _fireBaseServices.usersRef
        .doc(_fireBaseServices.getUserId())
        .collection('Saved')
        .doc(widget.productId)
        .set({'storage': _seletedStorageSize});
  }

  final SnackBar _cartSnackBar = SnackBar(
    content: Text(
      'Product added to the cart',
      style: TextStyle(fontSize: 20, color: Colors.deepOrange),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.grey[200],
  );
  final SnackBar _savedSnackBar = SnackBar(
    content: Text(
      'Product added to the cart',
      style: TextStyle(fontSize: 20, color: Colors.deepOrange),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.grey[200],
  );
}
