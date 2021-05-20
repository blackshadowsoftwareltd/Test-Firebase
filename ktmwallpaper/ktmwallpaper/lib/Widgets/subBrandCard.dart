import 'package:flutter/material.dart';

class SubBrandCard extends StatelessWidget {
  final name, imagePath;

  SubBrandCard({this.name, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 290,width: MediaQuery.of(context).size.width-30,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)
        ], borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(children: [
          Container(
              height: 220,
              width: MediaQuery.of(context).size.width - 30,
              margin: EdgeInsets.all(10),
              // color: Colors.green,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15)
                      ,
                  child:
                      Image.asset('images/$imagePath', fit: BoxFit.cover))),

          Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              alignment: Alignment.center,
              child: Text('$name',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w600,
                    // letterSpacing: .5
                  )))
        ]));
  }
}
