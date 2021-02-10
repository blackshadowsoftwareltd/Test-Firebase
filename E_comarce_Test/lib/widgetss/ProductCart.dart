import 'package:E_comarce_Test/Screen/productPage.dart';
import 'package:flutter/material.dart';

class ProductCart extends StatefulWidget {
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String price;
  final String productId;

  ProductCart(
      {this.title, this.onPressed, this.imageUrl, this.price, this.productId});

  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              productId: widget.productId,
            ),
          ),
        );
      },
      child: Container(
        height: 300,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Container(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  '${widget.imageUrl}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 5,
              right: 5,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                // color: Colors.green,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.price,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
