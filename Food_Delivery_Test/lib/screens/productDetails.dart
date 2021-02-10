import 'package:Food_Delivery_Test/screens/imageSwipe.dart';
import 'package:Food_Delivery_Test/widget/customButton.dart';
import 'package:Food_Delivery_Test/widget/getAllCartItems.dart';
import 'package:Food_Delivery_Test/widget/productSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'cartPage.dart';

class ProductDetails extends StatefulWidget {
  final String productId, title, imageUrl;
  final int price;

  ProductDetails({this.productId, this.price, this.title, this.imageUrl});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final CollectionReference pizzaRef =
      FirebaseFirestore.instance.collection('Pizza');
  String _selectedSize = '0';
  int value = 1, totalPrice, price = 0, intotal;

  @override
  Widget build(BuildContext context) {
    price = widget.price ?? 0;
    totalPrice = widget.price ?? 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Product Details'),
      ),
      body: FutureBuilder(
        future: pizzaRef.doc(widget.productId).get(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(child: Text('Error...${snapShot.error}'));
          }
          if (snapShot.connectionState == ConnectionState.done) {
            Map<String, dynamic> documentData = snapShot.data.data();
            List imageList = documentData['imageUrl'];
            List productSize = documentData['size'];
            _selectedSize = productSize[0];
            return ListView(
              padding: EdgeInsets.all(5),
              children: [
                ImageSwipe(
                  imageList: imageList
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    documentData['name'],
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.green[400],
                        fontWeight: FontWeight.w600)
                  )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Price \$ ${documentData['price']}',
                        style: TextStyle(fontSize: 18, color: Colors.red))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(documentData['desc'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            letterSpacing: .3))),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.remove_red_eye_sharp,
                            size: 25
                          )
                        ),
                        Text(' ${documentData['view']} ',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Size :',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                      ProductSize(
                        productSize: productSize,
                        onSelected: (size) {
                          _selectedSize = size;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity :',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black45,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (value > 1) {
                                      setState(() {
                                        value--;
                                        intotal = totalPrice = price * value;
                                        print(intotal);
                                      });
                                    } else {
                                      showToast('You can select minimum 1',
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  }),
                              Text(
                                '$value',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (value < 3) {
                                      setState(() {
                                        value++;
                                        intotal = totalPrice = price * value;
                                        print(totalPrice);
                                      });
                                    } else {
                                      showToast('You can select maximum 3',
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: GestureDetector(
                              onTap: () async {
                                await _addToCart();
                                showToast('One item Added in Cart',
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              },
                              child: Container(
                                  height: 45,
                                  // width:
                                  //     MediaQuery.of(context).size.width - 150,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.green[400],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'Add to cart',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  )),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()));
                        },
                        child: Container(
                          height: 45,
                          width: 100,
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Cart: ',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              GetAllCartItems(
                                textColor: true,
                                collectionStr: 'Cart',
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future _addToCart() {
    final CollectionReference userdataRef =
        FirebaseFirestore.instance.collection('UsersInFo');
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return userdataRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('Cart')
        .doc(widget.productId)
        .set({
      'title': widget.title,
      'size': _selectedSize,
      'imageUrl': widget.imageUrl,
      'quantity': value,
      'price': widget.price,
      'totalPrice': intotal ?? widget.price
    });
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
