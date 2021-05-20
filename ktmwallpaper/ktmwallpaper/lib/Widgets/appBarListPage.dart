import 'package:flutter/material.dart';

class AppBarListPage extends StatelessWidget {
  final String name, subBrandName;
  int totalImages;

  AppBarListPage({this.name, this.subBrandName, this.totalImages});

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width - 80;
    var _viewWidth = _width / 3;
    var nameWidth = _viewWidth + _viewWidth;
    int _totalImage = totalImages ?? 0;

    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        // color: Colors.purple,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: FloatingActionButton(
                      heroTag: 'ok',
                      backgroundColor: Colors.deepOrange,
                      child: Icon(Icons.arrow_back_ios_rounded,
                          size: 20, color: Colors.white),
                      onPressed: () => Navigator.pop(context))),
              Container(
                  height: 40,
                  width: _width,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40,
                            width: nameWidth - 5,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            // color: Colors.blue,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.deepOrange),
                            child: Text(name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white))),
                        Container(
                            height: 40,
                            width: _viewWidth - 5,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            // color: Colors.green,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.deepOrange),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined,
                                      size: 22, color: Colors.white),
                                  Text('$_totalImage',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300))
                                ])

                            )
                      ]))
            ]));
  }
}
