import 'package:flutter/material.dart';

class ImgViewer extends StatelessWidget {
  String imgUrl;

  ImgViewer({this.imgUrl});

  @override
  Widget build(BuildContext context) {
    print(imgUrl);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: imgUrl == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: 500,
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Hero(tag: 'img', child: Image.network(imgUrl)),
            ),
    );
  }
}
