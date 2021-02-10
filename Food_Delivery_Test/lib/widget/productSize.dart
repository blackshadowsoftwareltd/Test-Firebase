import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final List productSize;
  final Function(String) onSelected;

  ProductSize({this.onSelected, this.productSize});

  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.productSize.length; i++)
          GestureDetector(
            onTap: () {
              widget.onSelected('${widget.productSize[i]}');
              setState(() {
                _selected = i;
              });
            },
            child: Container(
              alignment: Alignment.center,
              // height: 30,
              margin: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                  color: _selected == i ? Colors.green[400] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                widget.productSize[i],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: _selected == i ? Colors.white : Colors.black),
              ),
            ),
          )
      ],
    );
  }
}
