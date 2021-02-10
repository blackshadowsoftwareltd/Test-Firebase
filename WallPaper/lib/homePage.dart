import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'imageViewer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Wallpaper'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('wallpaperImage').snapshots(),
            builder: (context, snapShot) {
              if (!snapShot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(5),
                  crossAxisCount: 4,
                  itemCount: snapShot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapShot.data.documents[index];
                    String imgUrl = data['url'];
                    // return Material(
                    return GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[100]),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover
                          )),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImgViewer(
                                      imgUrl: imgUrl,
                                    )));
                      }
                    );
                  },
                  staggeredTileBuilder: (index) =>
                      StaggeredTile.count(2, index.isEven ? 2 : 1.5),
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                );
              }
            }));
  }
}
