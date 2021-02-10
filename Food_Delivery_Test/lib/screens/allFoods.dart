import 'package:Food_Delivery_Test/screens/productView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllFoods extends StatefulWidget {
  final String foodRef;

  AllFoods({this.foodRef});

  @override
  _AllFoodsState createState() => _AllFoodsState();
}

class _AllFoodsState extends State<AllFoods> {
  // final CollectionReference pizzaRef =
  //     FirebaseFirestore.instance.collection('Pizza');

  @override
  Widget build(BuildContext context) {
    final CollectionReference pizzaRef =
        FirebaseFirestore.instance.collection(widget.foodRef);
    int price;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text(widget.foodRef),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: pizzaRef.get(),
          builder: (context, snapShot) {
            if (snapShot.hasError) {
              return Center(child: Text('Error'));
            }
            if (snapShot.connectionState == ConnectionState.done) {
              return ListView(
                padding: EdgeInsets.all(5),
                children: snapShot.data.docs.map((document) {
                  price = int.parse(document.data()['price']);
                  return ProductView(
                    title: document.data()['name'],
                    imageUrl: document.data()['imageUrl'][1],
                    price: price,
                    intPrice: price,
                    views: document.data()['view'],
                    productId: document.id,
                  );
                }).toList(),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
