import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// List _documents = snapShot.data.docs

class TotalImage extends StatelessWidget {
  final String collectionStr;

  TotalImage({this.collectionStr});

  final CollectionReference KTMRef =
      FirebaseFirestore.instance.collection('KTMWalpaper');
  String subBrand = 'subBrand';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: KTMRef.doc(subBrand).collection(collectionStr).snapshots(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Text(snapShot.error);
          }
          if (snapShot.connectionState == ConnectionState.active) {
            List _documents = snapShot.data.docs;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 22,color: Colors.white,
                ),
                Text(' ${_documents.length}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
              ],
            );
          }

          return Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  backgroundColor: Colors.white, strokeWidth: 1));
        });
  }
}
