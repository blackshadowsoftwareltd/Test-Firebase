import 'package:WallTest/FullView.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Fatching data from cloudFireStore
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpaperList;

  final CollectionReference collectionReference =
      Firestore.instance.collection('wall');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //for firestore
    subscription = collectionReference.snapshots().listen((dataSnapShot) {
      setState(() {
        wallpaperList = dataSnapShot.documents;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    //for firestore
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Wallpaper'),
        ),
        body: wallpaperList != null
            ? StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(5),
                itemCount: wallpaperList.length,
                crossAxisCount: 4,
                itemBuilder: (context, index) {
                  String imgUrl = wallpaperList[index].data['url'];
                  return Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: InkWell(
                      child: Hero(
                        tag: imgUrl,
                        child: FadeInImage(
                          image: NetworkImage(imgUrl),
                          fit: BoxFit.cover,
                          placeholder: NetworkImage(
                              'https://cdn.iconscout.com/icon/free/png-512/loading-load-spinner-volume-control-percentage-9760.png'),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullView(imgUrl)));
                      },
                    ),
                  );
                },
                staggeredTileBuilder: (i) =>
                    StaggeredTile.count(2, i.isEven ? 2 : 3),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
