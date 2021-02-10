import 'package:Food_Delivery_Test/screens/productDetails.dart';
import 'package:Food_Delivery_Test/widget/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  final Function onPressed;
  final String title, imageUrl, productId;
  final int views, intPrice, price;

  ProductView(
      {this.onPressed,
      this.title,
      this.price,
      this.intPrice,
      this.imageUrl,
      this.productId,
      this.views});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _addViews();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetails(
                      title: widget.title,
                      imageUrl: widget.imageUrl,
                      // intPrice: widget.intPrice,
                      // currentPrice: widget.intPrice,
                      price: widget.intPrice,
                      productId: widget.productId,
                    )));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 250,
                          alignment: Alignment.center,
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                          ))),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black.withOpacity(.5),
                      ),
                      child: Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Price ${widget.price}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700))),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Views ${widget.views}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addViews() {
    final CollectionReference pizzaRef =
        FirebaseFirestore.instance.collection('Pizza');
    int view;

    setState(() {
      view = widget.views;
    });
    print('view : $view');
    //

    pizzaRef.doc(widget.productId).update({'view': view + 1});

  }
}
