import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppBArViewPage extends StatelessWidget {
  final int views, save;

  AppBArViewPage({this.save, this.views});

  final CollectionReference KTMRef =
      FirebaseFirestore.instance.collection('KTMWalpaper');
  String subBrand = 'subBrand';

  @override
  Widget build(BuildContext context) {
    print('save >>>>>$save views >>>>>$views');
    int _views = views ?? 0;
    int _save = save ?? 0;
    var _width = MediaQuery.of(context).size.width - 50;
    var _viewsWidth = _width / 2;
    // var nameWidth = _viewWidth + _viewWidth;
    return Container(
        height: 50,
        width: _width,
        // color: Colors.green,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(.3)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            // width: 100,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Icon(Icons.visibility_outlined,
                                  size: 22, color: Colors.white),
                              _textModifing(_views)
                            ]))
                      ])),
              Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(.3)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            // width: 90,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Icon(Icons.offline_pin,
                                  size: 22, color: Colors.white),
                              _textModifing(_save)
                            ]))
                      ]))
            ]));
  }

  Widget _textModifing(int v) {
    return Text(
        v < 999
            ? '$v'
            : v < 1099
                ? '1K+'
                : v < 1199
                    ? '1.1K+'
                    : v < 1299
                        ? '1.2K+'
                        : v < 1399
                            ? '1.3K+'
                            : v < 1499
                                ? '1.4K+'
                                : v < 1599
                                    ? '1.5K+'
                                    : v < 1699
                                        ? '1.6K+'
                                        : v < 1799
                                            ? '1.7K+'
                                            : v < 1899
                                                ? '1.8K+'
                                                : v < 1999
                                                    ? '1.9K+'
                                                    : v < 2099
                                                        ? '2K+'
                                                        : v < 2199
                                                            ? '2.1K+'
                                                            : v < 2299
                                                                ? '2.2K+'
                                                                : v < 2399
                                                                    ? '2.3K+'
                                                                    : v < 2499
                                                                        ? '2.4K+'
                                                                        : v < 2599
                                                                            ? '2.5K+'
                                                                            : v < 2699
                                                                                ? '2.6K+'
                                                                                : v < 2799
                                                                                    ? '2.7K+'
                                                                                    : v < 2899
                                                                                        ? '2.8K+'
                                                                                        : v < 2999
                                                                                            ? '2.9K+'
                                                                                            : v < 3099
                                                                                                ? '3K+'
                                                                                                : v < 3999
                                                                                                    ? '3K+'
                                                                                                    : v < 4999
                                                                                                        ? '4K+'
                                                                                                        : v < 5999
                                                                                                            ? '5K+'
                                                                                                            : v < 6999
                                                                                                                ? '6K+'
                                                                                                                : v < 7999
                                                                                                                    ? '7K+'
                                                                                                                    : v < 8999
                                                                                                                        ? '8K+'
                                                                                                                        : v < 9999
                                                                                                                            ? '9K+'
                                                                                                                            : v < 14999
                                                                                                                                ? '10K+'
                                                                                                                                : v < 19999
                                                                                                                                    ? '15K+'
                                                                                                                                    : v < 24999
                                                                                                                                        ? '20K+'
                                                                                                                                        : v < 29999
                                                                                                                                            ? '25K+'
                                                                                                                                            : v < 34999
                                                                                                                                                ? '30K+'
                                                                                                                                                : v < 39999
                                                                                                                                                    ? '35K+'
                                                                                                                                                    : v < 44999
                                                                                                                                                        ? '40K+'
                                                                                                                                                        : v < 49999
                                                                                                                                                            ? '45K+'
                                                                                                                                                            : '50K+',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w300));
  }
}
